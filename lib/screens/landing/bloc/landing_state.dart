part of 'landing_bloc.dart';

@immutable
sealed class LandingState {}

class LandingLoading extends LandingState {}

class LandingError extends LandingState {
  final String error;

  LandingError({required this.error});
}

class LandingSuccessWithRegisteredPhoneNumber extends LandingState {
  final UserModel user;

  LandingSuccessWithRegisteredPhoneNumber({required this.user});
}

class LandingSuccessWithRegisteredPhoneNumberAndName extends LandingState { final UserModel user;

  LandingSuccessWithRegisteredPhoneNumberAndName({required this.user});}

class LandingSuccessWithoutRegistered extends LandingState {}
