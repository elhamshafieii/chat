import 'dart:async';

import 'package:chat/common/utils/utils.dart';
import 'package:chat/data/repository/select_contact_repository.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/screens/chat/mobile_chat_screen/mobile_chat_screen.dart';
import 'package:chat/screens/select_contact/bloc/select_contact_bloc.dart';
import 'package:chat/screens/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class SelectContactsScreen extends StatefulWidget {
  final UserModel user;
  const SelectContactsScreen({super.key, required this.user});

  @override
  State<SelectContactsScreen> createState() => _SelectContactsScreenState();
}

class _SelectContactsScreenState extends State<SelectContactsScreen> {
  late StreamSubscription<SelectContactState>? stateSubscription;
  Future<List<Contact>> getContact() async {
    List<Contact> contacts = [];
    List<Contact> contactList = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
        );
      }
      for (var contact in contacts) {
        if (contact.phones.isNotEmpty) {
          contactList.add(contact);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contactList;
  }

  @override
  void dispose() {
    stateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: BlocProvider<SelectContactBloc>(
        create: (context) {
          final bloc = SelectContactBloc(
              selectContactRepository: selectContactRepository);
          stateSubscription = bloc.stream.listen((state) {
            if (state is SelectContactSuccess) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return MobileChatScreen(
                  contactUid: state.contactUid,
                  user: widget.user,
                );
              }));
            } else if (state is SelectContactError) {
              showSnackBar(context: context, content: state.error);
            }
          });
          return bloc;
        },
        child: FutureBuilder(
          future: getContact(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return ListView.builder(
              itemCount: (snapshot.data as List<Contact>).length,
              itemBuilder: (context, index) {
                final contact = snapshot.data[index] as Contact;
                return InkWell(
                  onTap: () {
                    BlocProvider.of<SelectContactBloc>(context)
                        .add(SelectContactStarted(selectedContact: contact));
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      )),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
