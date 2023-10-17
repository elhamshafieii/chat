part of 'chat_contact_list_bloc.dart';

@immutable
sealed class ChatContactListState {}

class ChatContactListInitial extends ChatContactListState {}

class ChatContactListError extends ChatContactListState {
  final String error;

  ChatContactListError({required this.error});
}

class ChatContactListSuccess extends ChatContactListState {
  final Stream<List<ChatContact>> chatContactList;
  ChatContactListSuccess({
    required this.chatContactList,
  });
}
