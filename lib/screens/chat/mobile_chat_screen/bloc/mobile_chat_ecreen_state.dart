part of 'mobile_chat_ecreen_bloc.dart';

@immutable
sealed class MobileChatScreenState {}

class MobileChatScreenLoading extends MobileChatScreenState {}

class MobileChatScreenError extends MobileChatScreenState {
  final String error;

  MobileChatScreenError({required this.error});
}

class MobileChatScreenSuccess extends MobileChatScreenState {
  final Stream<UserModel> contactUserModelStream;
    // final UserModel contactUserModel;
  MobileChatScreenSuccess({
    required this.contactUserModelStream,
  });
}
