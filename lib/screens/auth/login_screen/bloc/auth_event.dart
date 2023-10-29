part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthNextButtomClicked extends AuthEvent {
  final String phoneNumber;

  AuthNextButtomClicked({required this.phoneNumber});
}
