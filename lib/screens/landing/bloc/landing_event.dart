part of 'landing_bloc.dart';

@immutable
sealed class LandingEvent {}
class LandingStarted extends LandingEvent {}

class LandingAgreeButtomClicked extends LandingEvent{}

