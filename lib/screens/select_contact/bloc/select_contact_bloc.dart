import 'package:chat/data/repository/select_contact_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';

part 'select_contact_event.dart';
part 'select_contact_state.dart';

class SelectContactBloc extends Bloc<SelectContactEvent, SelectContactState> {
  final ISelectContactRepository selectContactRepository;

  SelectContactBloc({required this.selectContactRepository})
      : super(SelectContactInitial()) {
    on<SelectContactEvent>((event, emit) async {
      if (event is SelectContactStarted) {
        emit(SelectContactLoading());
        try {
          final contact = await selectContactRepository
              .selectContact(event.selectedContact);
          if (contact != null) {
            emit(SelectContactSuccess(contactUid: contact.uid));
          } else {
            emit(SelectContactError(
                error: 'This number does not exist on this app.'));
          }
        } on FirebaseAuthException catch (e) {
          emit(SelectContactError(error: e.toString()));
        }
      }
    });
  }
}
