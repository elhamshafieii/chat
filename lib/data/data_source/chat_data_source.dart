import 'dart:io';

import 'package:chat/common/enums/message_enum.dart';
import 'package:chat/models/chat_contact.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/message_reply.dart';
import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

abstract class IChatDataSource {
  Stream<List<ChatContact>> getChatContacts();
  Stream<List<Message>> getChatStream(String contactUid);
  Stream<UserModel> getContactUserModelStream(String uid);
  Future<UserModel> getContactUserModel(String contactUid);
  Future<void> setChatMessageSeen(String contactUid, String messageId);
  Future<void> sendMessage(
      {required String message,
      required String contactUid,
      required UserModel senderUserData,
      required MessageEnum messageEnum,
      required MessageReply? messageReply});
}

class ChatFirebaseDataSource implements IChatDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final FirebaseStorage firebaseStorage;

  ChatFirebaseDataSource(
      {required this.firestore,
      required this.auth,
      required this.firebaseStorage});

  @override
  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> chatContacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        chatContacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
            phoneNumber: chatContact.phoneNumber,
          ),
        );
      }
      return chatContacts;
    });
  }

  @override
  Stream<List<Message>> getChatStream(String contactUid) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(contactUid)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  @override
  Stream<UserModel> getContactUserModelStream(String uid) {
    return firestore.collection('users').doc(uid).snapshots().map((event) {
      return UserModel.fromMap(event.data()!);
    });
  }

  @override
  Future<UserModel> getContactUserModel(String contactUid) async {
    final snapshot = await firestore.collection('users').doc(contactUid).get();
    final UserModel contactUserModel =
        UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    return contactUserModel;
  }

  @override
  Future<void> setChatMessageSeen(String contactUid, String messageId) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(contactUid)
        .collection('messages')
        .doc(messageId)
        .update({'isSeen': true});
    await firestore
        .collection('users')
        .doc(contactUid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .update({'isSeen': true});
  }

  @override
  Future<void> sendMessage(
      {required String message,
      required String contactUid,
      required UserModel senderUserData,
      required MessageEnum messageEnum,
      required MessageReply? messageReply}) async {
    String fileUrl = '';
    var userDataMap = await firestore.collection('users').doc(contactUid).get();
    UserModel contactUserData = UserModel.fromMap(userDataMap.data()!);
    var timeSent = DateTime.now();
    var messageId = const Uuid().v1();
    if (messageEnum != MessageEnum.text) {
      String filePath =
          'chat/${messageEnum.type}/${senderUserData.uid}/${contactUid}/$messageId';
      File file = File(message);
      await firebaseStorage.ref(filePath).putFile(file);
      fileUrl = await firebaseStorage.ref(filePath).getDownloadURL();
    }
    String contactMsg;
    switch (messageEnum) {
      case MessageEnum.image:
        contactMsg = '📷 Photo';
        break;
      case MessageEnum.video:
        contactMsg = '📸 Video';
        break;
      case MessageEnum.audio:
        contactMsg = '🎵 Audio';
        break;
      case MessageEnum.gif:
        contactMsg = 'GIF';
        break;
      case MessageEnum.file:
        contactMsg = '📃 File';
        break;
      case MessageEnum.text:
        contactMsg = message;
        break;
      default:
        contactMsg = 'GIF';
    }

    _saveDataToContactsSubcollection(
      senderUserData,
      contactUserData,
      contactMsg,
      timeSent,
    );

    _saveMessageToMessageSubcollection(
      contactUid: contactUid,
      text: messageEnum != MessageEnum.text ? fileUrl : message,
      timeSent: timeSent,
      messageId: messageId,
      username: senderUserData.name,
      messageType: messageEnum,
      recieverUserName: contactUserData.name,
      senderUsername: senderUserData.name,
      messageReply: messageReply,
    );
  }

  Future<void> _saveDataToContactsSubcollection(
    UserModel senderUser,
    UserModel? recieverUserData,
    String text,
    DateTime timeSent,
  ) async {
    var recieverChatContact = ChatContact(
      name: senderUser.name,
      profilePic: senderUser.profilePic,
      contactId: senderUser.uid,
      timeSent: timeSent,
      lastMessage: text,
      phoneNumber: recieverUserData!.phoneNumber,
    );
    await firestore
        .collection('users')
        .doc(recieverUserData.uid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          recieverChatContact.toMap(),
        );
    var senderChatContact = ChatContact(
      name: recieverUserData.name,
      profilePic: recieverUserData.profilePic,
      contactId: recieverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
      phoneNumber: recieverUserData.phoneNumber,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserData.uid)
        .set(
          senderChatContact.toMap(),
        );
  }

  Future<void> _saveMessageToMessageSubcollection(
      {required String contactUid,
      required String text,
      required DateTime timeSent,
      required MessageEnum messageType,
      required String messageId,
      required String username,
      required String recieverUserName,
      required String senderUsername,
      required MessageReply? messageReply}) async {
    final message = Message(
      senderUid: auth.currentUser!.uid,
      contactUid: contactUid,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : recieverUserName,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(contactUid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
    await firestore
        .collection('users')
        .doc(contactUid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }
}
