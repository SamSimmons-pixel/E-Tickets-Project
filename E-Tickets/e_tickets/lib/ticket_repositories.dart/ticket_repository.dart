import 'package:e_tickets/models/ticket.dart';

class TicketRepository {
  // Future<List<Ticket>> getTickets() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   return [
  //     Ticket(
  //       id: 1,
  //       title: 'Ticket 1',
  //       description: 'Description 1',
  //       price: 100,
  //       date: DateTime.now(),
  //       imageUrl: 'https://example.com/ticket1.jpg',
  //     ),
  //     Ticket(
  //       id: 2,
  //       title: 'Ticket 2',
  //       description: 'Description 2',
  //       price: 200,
  //       date: DateTime.now(),
  //       imageUrl: 'https://example.com/ticket2.jpg',
  //     ),
  //   ];
  // }
  final List<Ticket> _mocktickets = [
    Ticket(
      id: 1,
      title: 'Kimi no nawa',
      description: '2 Separate Dimension Love, what is your name?',
      price: 100,
      date: DateTime.now(),
      imageUrl: 'https://example.com/ticket1.jpg',
    ),
    Ticket(
      id: 2,
      title: 'Ticket 2',
      description: 'Description 2',
      price: 200,
      date: DateTime.now(),
      imageUrl: 'https://example.com/ticket2.jpg',
    ),
  ];

  Future<List<Ticket>> getTickets() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mocktickets;
  }

  Future<Ticket> getTicketById(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      return _mocktickets.firstWhere((ticket) => ticket.id == id);
    } catch (e) {
      throw Exception('Ticket not found');
    }
  }
}