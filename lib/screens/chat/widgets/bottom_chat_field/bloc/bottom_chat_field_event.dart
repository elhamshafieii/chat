part of 'bottom_chat_field_bloc.dart';

@immutable
sealed class BottomChatFieldEvent {}

class BottomChatFieldStarted extends BottomChatFieldEvent {}

class BottomChatFieldSendMessageClicked extends BottomChatFieldEvent {
  final MessageEnum messageType;
  final String message;
  final MessageReply? messageReply;

  BottomChatFieldSendMessageClicked(
      {this.messageReply, required this.message, required this.messageType});
}
