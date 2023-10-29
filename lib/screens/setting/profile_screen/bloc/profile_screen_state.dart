part of 'profile_screen_bloc.dart';

@immutable
sealed class ProfileScreenState {}

final class ProfileScreenInitial extends ProfileScreenState {}

final class ProfileScreenLoading extends ProfileScreenState {}

class ProfileScreenextends extends ProfileScreenState {}

class ProfileScreenError extends ProfileScreenState {
  final String error;

  ProfileScreenError({required this.error});
}

class ProfileScreenSuccess extends ProfileScreenState {
}
