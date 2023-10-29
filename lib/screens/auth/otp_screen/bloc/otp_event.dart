part of 'otp_bloc.dart';

@immutable
sealed class OtpEvent {}

class OtpCodeFilled extends OtpEvent {
  final String verificationCode;
  final String userOtp;

  OtpCodeFilled({required this.userOtp, required this.verificationCode});
}
