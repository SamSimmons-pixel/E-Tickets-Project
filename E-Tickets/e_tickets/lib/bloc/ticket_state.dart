import 'package:equatable/equatable.dart';
import '../models/ticket.dart';

abstract class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object?> get props => [];
}

// Initial state when BLoC is created
class TicketInitial extends TicketState {
  const TicketInitial();
}

// Loading state
class TicketLoading extends TicketState {
  const TicketLoading();
}

// Successfully loaded tickets
class TicketLoaded extends TicketState {
  final List<Ticket> tickets;

  const TicketLoaded({required this.tickets});

  // 🎯 THIS IS WHERE EQUATABLE SHINES!
  // When you emit TicketLoaded with the same tickets,
  // Flutter knows NOT to rebuild the UI
  @override
  List<Object?> get props => [tickets];
}

// Successfully loaded a single ticket
class TicketDetailLoaded extends TicketState {
  final Ticket ticket;

  const TicketDetailLoaded({required this.ticket});

  // 🎯 Equatable compares the ticket object
  // If it's the same ticket, no rebuild!
  @override
  List<Object?> get props => [ticket];
}

// Error state
class TicketError extends TicketState {
  final String message;

  const TicketError({required this.message});

  @override
  List<Object?> get props => [message];
}
