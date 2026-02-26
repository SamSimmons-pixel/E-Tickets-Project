import 'package:equatable/equatable.dart';
import 'package:e_tickets/models/ticket.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class CreateBookingEvent extends BookingEvent {
  final Ticket ticket;

  const CreateBookingEvent({required this.ticket});

  @override
  List<Object?> get props => [ticket];
}

class DeleteBookingEvent extends BookingEvent {
  final int id;

  const DeleteBookingEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class LoadBookingEvent extends BookingEvent {
  const LoadBookingEvent();

  @override
  List<Object?> get props => [];
}
