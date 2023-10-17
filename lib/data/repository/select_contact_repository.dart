import 'package:chat/data/data_source/select_contact_data_source.dart';
import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/contact.dart';

final selectContactRepository = SelectContactRepository(
    dataSource:
        SelectContactFirebaseDataSource(firestore: FirebaseFirestore.instance));

abstract class ISelectContactRepository {
  Future<UserModel?> selectContact(Contact selectedContact);
}

class SelectContactRepository implements ISelectContactRepository {
  final ISelectContactDataSource dataSource;

  SelectContactRepository({required this.dataSource});
  @override
  Future<UserModel?> selectContact(Contact selectedContact) {
    return dataSource.selectContact(selectedContact);
  }
}
