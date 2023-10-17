part of 'bottom_chat_field_bloc.dart';

@immutable
sealed class BottomChatFieldState {}

final class BottomChatFieldInitial extends BottomChatFieldState {}

class BottomChatFieldLoading extends BottomChatFieldState {
  final String message;
  final MessageEnum messageType;

  BottomChatFieldLoading({required this.message, required this.messageType});
}

class BottomChatFieldError extends BottomChatFieldState {
  final String error;

  BottomChatFieldError({required this.error});
}

class BottomChatFieldSuccess extends BottomChatFieldState {}

