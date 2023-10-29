part of 'profile_screen_bloc.dart';

@immutable
sealed class ProfileScreenEvent {}

class ProfileScreenChangeProfilePicButtonClickes extends ProfileScreenEvent {
  final File? profilePic;

  ProfileScreenChangeProfilePicButtonClickes({required this.profilePic});
}
