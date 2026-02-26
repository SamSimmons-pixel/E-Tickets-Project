import 'package:e_tickets/models/booking.dart';
import 'package:equatable/equatable.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();

  @override
  List<Object?> get props => [];
}

class BookingLoaded extends BookingState {
  final List<Booking> bookings;
  const BookingLoaded({required this.bookings});

  @override
  List<Object?> get props => [bookings];
}

class BookingError extends BookingState {
  final String message;
  const BookingError({required this.message});

  @override
  List<Object?> get props => [message];
}

class BookingSuccess extends BookingState {
  final String message;
  const BookingSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
