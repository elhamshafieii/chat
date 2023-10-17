part of 'user_information_bloc.dart';

@immutable
sealed class UserInformationState {}

final class UserInformationInitial extends UserInformationState {}

class UserInformationLoading extends UserInformationState {}

class UserInformationError extends UserInformationState {
  final String error;

  UserInformationError({required this.error});
}

class UserInformationSuccess extends UserInformationState {
  final UserModel userModel;

  UserInformationSuccess({required this.userModel});
}
