part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthNextButtomClicked extends AuthEvent {
  final String phoneNumber;

  AuthNextButtomClicked({required this.phoneNumber});
}
