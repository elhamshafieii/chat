import 'package:chat/data/repository/auth_repository.dart';
import 'package:chat/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final IAuthRepository authRepository;

  OtpBloc({required this.authRepository}) : super(OtpInitial()) {
    on<OtpEvent>((event, emit) async {
      if (event is OtpCodeFilled) {
        try {
          emit(OtpLoading());
          final UserModel userData = await authRepository.verifyOtp(
            event.verificationCode,
            event.userOtp,
          );
          emit(OtpSuccess(userData));
        } catch (e) {
          emit(OtpError(error: e.toString()));
        }
      }
    });
  }
}
