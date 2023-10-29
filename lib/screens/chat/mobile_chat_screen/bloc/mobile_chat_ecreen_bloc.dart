import 'package:chat/data/repository/chat_repository.dart';
import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'mobile_chat_ecreen_event.dart';
part 'mobile_chat_ecreen_state.dart';

class MobileChatScreenBloc
    extends Bloc<MobileChatScreenEvent, MobileChatScreenState> {
  final IChatRepository chatRepository;
  final String contactUid;
  MobileChatScreenBloc({
    required this.chatRepository,
    required this.contactUid,
  }) : super(MobileChatScreenLoading()) {
    on<MobileChatScreenEvent>((event, emit) async {
      if (event is MobileChatScreenStarted) {
        try {
          final contactUserModelStream =
              chatRepository.getContactUserModelStream(contactUid);
          emit(MobileChatScreenSuccess(
          contactUserModelStream: contactUserModelStream,
          ));
        } on FirebaseException catch (e) {
          emit(MobileChatScreenError(error: e.toString()));
        }
      }
    });
  }
}
