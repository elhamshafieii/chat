part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final FirebaseAuthException error;

  AuthError({required this.error});
}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess({required this.user});
}

class AuthGetVerificationId extends AuthState {
  final String verificationId;
  AuthGetVerificationId({required this.verificationId});
}
