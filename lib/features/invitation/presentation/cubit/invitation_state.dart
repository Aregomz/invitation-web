part of 'invitation_cubit.dart';

abstract class InvitationState extends Equatable {
  const InvitationState();

  @override
  List<Object> get props => [];
}

class InvitationInitial extends InvitationState {}

class InvitationLoading extends InvitationState {}

class InvitationLoaded extends InvitationState {
  final DateTime targetDate;
  final Duration timeLeft;
  final String eventTitle;
  final String eventDate;
  final String eventTime;
  final String eventLocation;
  final String eventDescription;
  final bool isConfirmed;

  const InvitationLoaded({
    required this.targetDate,
    required this.timeLeft,
    required this.eventTitle,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.eventDescription,
    this.isConfirmed = false,
  });

  InvitationLoaded copyWith({
    DateTime? targetDate,
    Duration? timeLeft,
    String? eventTitle,
    String? eventDate,
    String? eventTime,
    String? eventLocation,
    String? eventDescription,
    bool? isConfirmed,
  }) {
    return InvitationLoaded(
      targetDate: targetDate ?? this.targetDate,
      timeLeft: timeLeft ?? this.timeLeft,
      eventTitle: eventTitle ?? this.eventTitle,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      eventLocation: eventLocation ?? this.eventLocation,
      eventDescription: eventDescription ?? this.eventDescription,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }

  @override
  List<Object> get props => [
        targetDate,
        timeLeft,
        eventTitle,
        eventDate,
        eventTime,
        eventLocation,
        eventDescription,
        isConfirmed,
      ];
}

class RsvpSubmitting extends InvitationState {}

class RsvpSuccess extends InvitationState {
  final String message;

  const RsvpSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class RsvpError extends InvitationState {
  final String message;

  const RsvpError({required this.message});

  @override
  List<Object> get props => [message];
}
