part of 'chat_list_bloc.dart';

@immutable
sealed class ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListError extends ChatListState {
  final String error;

  ChatListError({required this.error});
}

class ChatListSuccess extends ChatListState {
  final Stream<List<Message>> messages;
  final UserModel contactUserModel;

  ChatListSuccess({required this.contactUserModel,
    required this.messages,
  });
}
