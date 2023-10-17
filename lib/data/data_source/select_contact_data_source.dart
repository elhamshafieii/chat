import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/contact.dart';

abstract class ISelectContactDataSource {
  Future<UserModel?> selectContact(Contact selectedContact);
}

class SelectContactFirebaseDataSource implements ISelectContactDataSource {
  final FirebaseFirestore firestore;

  SelectContactFirebaseDataSource({required this.firestore});

  @override
  Future<UserModel?> selectContact(Contact selectedContact) async {
    UserModel? userData;
    var userCollection = await firestore.collection('users').get();
    for (var document in userCollection.docs) {
      var user = UserModel.fromMap(document.data());
      String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(
        ' ',
        '',
      );
      if (selectedPhoneNum == user.phoneNumber) {
        userData = user;
      }
    }
    return userData;
  }
}
