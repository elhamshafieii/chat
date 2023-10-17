import 'package:chat/data/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthNextButtomClicked) {
        emit(AuthLoading());
        try {
          final output =
              await authRepository.signInWithPhone(event.phoneNumber);
          if (output is User) {
            emit(AuthSuccess(user: output));
          } else if (output is FirebaseAuthException) {
            emit(AuthError(error: output));
          } else {
            emit(AuthGetVerificationId(verificationId: output));
          }
        } on FirebaseAuthException catch (e) {
          emit(AuthError(error: e));
        }
      }
    });
  }
}
