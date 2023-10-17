part of 'user_information_bloc.dart';

@immutable
sealed class UserInformationEvent {}

class UserInformationStarted extends UserInformationEvent {}

class UserInformationOkButtomClicked extends UserInformationEvent {
  final String userName;
  final File? profilePic;

  UserInformationOkButtomClicked({required this.userName, required this.profilePic});
}
