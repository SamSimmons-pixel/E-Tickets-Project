import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_tickets/models/booking.dart';
import 'package:e_tickets/bloc/booking/booking_event.dart';
import 'package:e_tickets/bloc/booking/booking_state.dart';
import 'package:e_tickets/repositories/booking_repository.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _bookingRepository;

  BookingBloc(this._bookingRepository) : super(const BookingInitial()) {
    on<CreateBookingEvent>(_onCreateBooking);
    on<DeleteBookingEvent>(_onDeleteBooking);
    on<LoadBookingEvent>(_onLoadBooking);
  }

  Future<void> _onCreateBooking(
    CreateBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final booking = Booking(
        id: 0, // auto-incremented by SQLite
        ticketId: event.ticket.id,
        userId: event.ticket.userId,
        title: event.ticket.title,
        description: event.ticket.description,
        price: event.ticket.price.toInt(),
        date: event.ticket.date.toIso8601String(),
        imageUrl: event.ticket.imageUrl ?? '',
        bookingDate: DateTime.now().toIso8601String(),
        status: 'CONFIRMED',
      );
      await _bookingRepository.insertBooking(booking);
      emit(const BookingSuccess(message: 'Booking berhasil dibuat!'));
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }

  Future<void> _onLoadBooking(
    LoadBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final bookings = await _bookingRepository.getBookings();
      emit(BookingLoaded(bookings: bookings));
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }

  Future<void> _onDeleteBooking(
    DeleteBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      await _bookingRepository.deleteBooking(event.id);
      // Reload the bookings list after deletion
      final bookings = await _bookingRepository.getBookings();
      emit(BookingLoaded(bookings: bookings));
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }
}
