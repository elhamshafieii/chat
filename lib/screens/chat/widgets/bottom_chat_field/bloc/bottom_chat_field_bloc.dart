import 'package:chat/common/enums/message_enum.dart';
import 'package:chat/data/repository/auth_repository.dart';
import 'package:chat/data/repository/chat_repository.dart';
import 'package:chat/models/message_reply.dart';
import 'package:chat/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_chat_field_event.dart';
part 'bottom_chat_field_state.dart';

class BottomChatFieldBloc
    extends Bloc<BottomChatFieldEvent, BottomChatFieldState> {
  final IChatRepository chatRepository;
  final IAuthRepository authRepository;
  final String contactUid;

  BottomChatFieldBloc(
      {required this.authRepository,
      required this.contactUid,
      required this.chatRepository})
      : super(BottomChatFieldInitial()) {
    on<BottomChatFieldEvent>((event, emit) async {
      if (event is BottomChatFieldSendMessageClicked) {
        emit(BottomChatFieldLoading(
          message: event.message,
          messageType: event.messageType,
        ));
        try {
          final UserModel? senderUserData =
              await authRepository.getCurrentUserData();
          await chatRepository.sendMessage(
            message: event.message,
            contactUid: contactUid,
            senderUserData: senderUserData!,
            messageEnum: event.messageType,
            messageReply: event.messageReply,
          );
          emit(BottomChatFieldSuccess());
        } on FirebaseException catch (e) {
          emit(BottomChatFieldError(error: e.message.toString()));
        }
      }
    });
  }
}
