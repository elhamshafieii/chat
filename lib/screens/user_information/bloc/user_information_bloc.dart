import 'dart:io';

import 'package:chat/data/repository/auth_repository.dart';
import 'package:chat/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_information_event.dart';
part 'user_information_state.dart';

class UserInformationBloc
    extends Bloc<UserInformationEvent, UserInformationState> {
  final IAuthRepository authRepository;
  UserInformationBloc({required this.authRepository})
      : super(UserInformationInitial()) {
    on<UserInformationEvent>((event, emit) async {
      if (event is UserInformationOkButtomClicked) {
        try {
          emit(UserInformationLoading());
          final userModel = await authRepository.saveUserDataToFirebase(
              event.userName, event.profilePic);
          emit(UserInformationSuccess(userModel: userModel));
        } on FirebaseAuthException catch (e) {
          emit(UserInformationError(error: e.message.toString()));
        }
      }
    });
  }
}
