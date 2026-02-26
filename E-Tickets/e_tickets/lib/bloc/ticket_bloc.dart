import 'package:bloc/bloc.dart';
import '../repositories/ticket_repository.dart';
import './ticket_event.dart';
import './ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository ticketRepository;

  TicketBloc({required this.ticketRepository}) : super(const TicketInitial()) {
    on<LoadTickets>(_onLoadTickets);
    on<LoadTicketById>(_onLoadTicketById);
    on<RefreshTickets>(_onRefreshTickets);
    on<SearchTicket>(_onSearchTicket);
  }

  Future<void> _onLoadTickets(
    LoadTickets event,
    Emitter<TicketState> emit,
  ) async {
    emit(const TicketLoading());

    try {
      final tickets = await ticketRepository.getTickets();
      emit(TicketLoaded(tickets: tickets));

      // 🎯 EQUATABLE IN ACTION:
      // If you call this again and get the same tickets,
      // Equatable will compare:
      // - Old state: TicketLoaded(tickets: [ticket1, ticket2])
      // - New state: TicketLoaded(tickets: [ticket1, ticket2])
      // Result: They're equal! → No UI rebuild 🚀
    } catch (e) {
      emit(TicketError(message: 'Failed to load tickets: ${e.toString()}'));
    }
  }

  Future<void> _onLoadTicketById(
    LoadTicketById event,
    Emitter<TicketState> emit,
  ) async {
    emit(const TicketLoading());

    try {
      final ticket = await ticketRepository.getTicketById(event.ticketId);
      emit(TicketDetailLoaded(ticket: ticket));
    } catch (e) {
      emit(TicketError(message: 'Ticket not found'));
    }
  }

  Future<void> _onRefreshTickets(
    RefreshTickets event,
    Emitter<TicketState> emit,
  ) async {
    // Don't show loading for refresh (better UX)
    try {
      final tickets = await ticketRepository.getTickets();
      emit(TicketLoaded(tickets: tickets));

      // 🎯 REAL-WORLD SCENARIO:
      // User pulls to refresh but data hasn't changed
      // WITHOUT Equatable: UI flickers/rebuilds anyway
      // WITH Equatable: Smooth, no unnecessary rebuild!
    } catch (e) {
      emit(TicketError(message: 'Failed to refresh tickets'));
    }
  }

  Future<void> _onSearchTicket(
    SearchTicket event,
    Emitter<TicketState> emit,
  ) async {
    emit(const TicketLoading());

    try {
      final tickets = await ticketRepository.SearchTicket(event.query);
      emit(TicketLoaded(tickets: tickets));
    } catch (e) {
      emit(TicketError(message: 'Failed to search tickets'));
    }
  }

//   on<SearchTicket>((event, emit) async {
//   emit(const TicketLoading());

//   try {
//     final tickets = await ticketRepository.SearchTicket(event.query);
//     emit(TicketLoaded(tickets: tickets));
//   } catch (e) {
//     emit(TicketError(message: e.toString()));
//   }
// });
}

