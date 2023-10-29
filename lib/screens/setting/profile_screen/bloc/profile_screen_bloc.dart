import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat/data/repository/auth_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';

part 'profile_screen_event.dart';
part 'profile_screen_state.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  final IAuthRepository authRepository;
  ProfileScreenBloc({required this.authRepository})
      : super(ProfileScreenInitial()) {
    on<ProfileScreenEvent>((event, emit) async {
      if (event is ProfileScreenChangeProfilePicButtonClickes) {
        emit(ProfileScreenLoading());
        try {
          emit(ProfileScreenLoading());
          await authRepository.changeProfilePic(event.profilePic);
          emit(ProfileScreenSuccess());
        } on FirebaseException catch (e) {
          emit(ProfileScreenError(error: e.toString()));
        }
      }
    });
  }
}
