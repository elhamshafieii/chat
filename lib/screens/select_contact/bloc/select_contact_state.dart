part of 'select_contact_bloc.dart';

@immutable
sealed class SelectContactState {}

final class SelectContactInitial extends SelectContactState {}

class SelectContactLoading extends SelectContactState {}

class SelectContactError extends SelectContactState {
  final String error;

  SelectContactError({required this.error});
}

class SelectContactSuccess extends SelectContactState {
  final String contactUid;

  SelectContactSuccess({required this.contactUid});
}
