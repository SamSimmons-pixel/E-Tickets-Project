import 'package:equatable/equatable.dart';

abstract class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object?> get props => [];
}

// Event to load all tickets
class LoadTickets extends TicketEvent {
  const LoadTickets();
}

// Event to load a specific ticket by ID
class LoadTicketById extends TicketEvent {
  final int ticketId;

  const LoadTicketById({required this.ticketId});

  @override
  List<Object?> get props => [ticketId];
}

// Event to refresh tickets (pull-to-refresh)
class RefreshTickets extends TicketEvent {
  const RefreshTickets();
}
