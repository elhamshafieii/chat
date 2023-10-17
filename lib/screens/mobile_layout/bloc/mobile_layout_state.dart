part of 'mobile_layout_bloc.dart';

@immutable
sealed class MobileLayoutState {}

final class MobileLayoutInitial extends MobileLayoutState {}

class MobileLayoutChangeUserOnlineStatusError extends MobileLayoutState {
  final String error;

  MobileLayoutChangeUserOnlineStatusError({required this.error});
}

class MobileLayoutChangeUserOnlineStatusSuccess extends MobileLayoutState {}

class MobileLayoutChangeUserOnlineStatusLoading extends MobileLayoutState {}
