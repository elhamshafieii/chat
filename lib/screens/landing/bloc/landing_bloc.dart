import 'package:chat/data/repository/auth_repository.dart';
import 'package:chat/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'landing_event.dart';
part 'landing_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  final IAuthRepository authRepository;
  LandingBloc({required this.authRepository}) : super(LandingLoading()) {
    on<LandingEvent>((event, emit) async {
      if (event is LandingStarted) {
        emit(LandingLoading());
        try {
          final isConnect = await authRepository.isConnectToFirebase();
          if (isConnect) {
            final currentUser = await authRepository.getCurrentUserData();
            if (currentUser != null) {
              if (currentUser.name.isEmpty) {
                emit(
                    LandingSuccessWithRegisteredPhoneNumber(user: currentUser));
              } else {
                emit(LandingSuccessWithRegisteredPhoneNumberAndName(
                    user: currentUser));
              }
            } else {
              emit(LandingSuccessWithoutRegistered());
            }
          }
        } on FirebaseException {
          emit(LandingError(error: 'There is no internet connection'));
        }
      }
    });
  }
}
