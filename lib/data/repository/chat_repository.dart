import 'package:chat/common/enums/message_enum.dart';
import 'package:chat/data/data_source/chat_data_source.dart';
import 'package:chat/models/chat_contact.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/message_reply.dart';
import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final chatRepository = ChatRepository(
    dataSource: ChatFirebaseDataSource(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
        firebaseStorage: FirebaseStorage.instance));

abstract class IChatRepository {
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

class ChatRepository implements IChatRepository {
  final IChatDataSource dataSource;

  ChatRepository({required this.dataSource});
  @override
  Stream<List<ChatContact>> getChatContacts() {
    return dataSource.getChatContacts();
  }

  @override
  Stream<List<Message>> getChatStream(String contactUid) {
    return dataSource.getChatStream(contactUid);
  }

  @override
  Stream<UserModel> getContactUserModelStream(String uid) {
    return dataSource.getContactUserModelStream(uid);
  }

  @override
  Future<void> setChatMessageSeen(String contactUid, String messageId) async {
    return await dataSource.setChatMessageSeen(contactUid, messageId);
  }

  @override
  Future<void> sendMessage(
      {required String message,
      required String contactUid,
      required UserModel senderUserData,
      required MessageEnum messageEnum,
      required MessageReply? messageReply}) async {
    return await dataSource.sendMessage(
      message: message,
      contactUid: contactUid,
      senderUserData: senderUserData,
      messageEnum: messageEnum,
      messageReply: messageReply,
    );
  }

  @override
  Future<UserModel> getContactUserModel(String contactUid) async {
    return await dataSource.getContactUserModel(contactUid);
  }
}
