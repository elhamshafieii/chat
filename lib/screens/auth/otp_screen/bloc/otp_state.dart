part of 'otp_bloc.dart';

@immutable
sealed class OtpState {}

final class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpError extends OtpState {
  final String error;

  OtpError({required this.error});
}

class OtpSuccess extends OtpState {
  final UserModel userModel;
  OtpSuccess(this.userModel);
}
