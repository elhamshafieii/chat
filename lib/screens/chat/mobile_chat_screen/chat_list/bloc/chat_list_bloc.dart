import 'package:chat/data/repository/chat_repository.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final IChatRepository chatRepository;
  final String contactUid;
  ChatListBloc({required this.contactUid, required this.chatRepository})
      : super(ChatListLoading()) {
    on<ChatListEvent>((event, emit) async {
      if (event is ChatListStarted) {
        emit(ChatListLoading());
        try {
          final contactUserModel =
              await chatRepository.getContactUserModel(contactUid);
          final messages = await chatRepository.getChatStream(contactUid);
          emit(ChatListSuccess(
            messages: messages,
            contactUserModel: contactUserModel,
          ));
        } on FirebaseException catch (e) {
          emit(ChatListError(error: e.message.toString()));
        }
      }
    });
  }
}
