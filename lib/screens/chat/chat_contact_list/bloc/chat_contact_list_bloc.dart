import 'package:chat/data/repository/chat_repository.dart';
import 'package:chat/models/chat_contact.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_contact_list_event.dart';
part 'chat_contact_list_state.dart';

class ChatContactListBloc
    extends Bloc<ChatContactListEvent, ChatContactListState> {
  final IChatRepository chatRepository;
  ChatContactListBloc({required this.chatRepository})
      : super(ChatContactListInitial()) {
    on<ChatContactListEvent>((event, emit) async {
      if (event is ChatContactListStarted) {
        try {
          final chatContactList = chatRepository.getChatContacts();
          emit(ChatContactListSuccess(chatContactList: chatContactList));
        } on FirebaseException catch (e) {
          emit(ChatContactListError(error: e.message.toString()));
        }
      }
    });
  }
}
