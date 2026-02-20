import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ticket_bloc.dart';
import '../bloc/ticket_event.dart';
import '../bloc/ticket_state.dart';

/// This screen demonstrates WHY Equatable is important
/// Run this and watch the console for rebuild messages!
class TicketListScreen extends StatelessWidget {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets (Equatable Demo)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // 🎯 TRY THIS:
              // Tap refresh multiple times quickly
              // WITHOUT Equatable: UI rebuilds every time
              // WITH Equatable: Only rebuilds if data actually changed!
              context.read<TicketBloc>().add(const RefreshTickets());
            },
          ),
        ],
      ),
      body: BlocBuilder<TicketBloc, TicketState>(
        // 🎯 buildWhen controls when to rebuild
        // Equatable makes this comparison possible!
        buildWhen: (previous, current) {
          print('🔍 Comparing states:');
          print('Previous: $previous');
          print('Current: $current');
          print('Are they equal? ${previous == current}');
          print('---');

          // If states are equal, don't rebuild!
          return previous != current;
        },
        builder: (context, state) {
          // This print shows WHEN the widget actually rebuilds
          print('🎨 REBUILDING UI FOR STATE: $state');

          if (state is TicketLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TicketLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TicketBloc>().add(const RefreshTickets());
                // Wait a bit for the refresh to complete
                await Future.delayed(const Duration(seconds: 2));
              },
              child: ListView.builder(
                itemCount: state.tickets.length,
                itemBuilder: (context, index) {
                  final ticket = state.tickets[index];

                  // 🎯 Each ticket card also benefits from Equatable!
                  return TicketCard(key: ValueKey(ticket.id), ticket: ticket);
                },
              ),
            );
          }

          if (state is TicketError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TicketBloc>().add(const LoadTickets());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Initial state
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<TicketBloc>().add(const LoadTickets());
              },
              child: const Text('Load Tickets'),
            ),
          );
        },
      ),
    );
  }
}

/// Individual ticket card widget
class TicketCard extends StatelessWidget {
  final dynamic ticket; // Using dynamic to show the comparison

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    // This print shows when individual cards rebuild
    print('🎴 Building card for ticket: ${ticket.title}');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(child: Text('${ticket.id}')),
        title: Text(ticket.title),
        subtitle: Text(ticket.description),
        trailing: Text(
          '\$${ticket.price.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          context.read<TicketBloc>().add(LoadTicketById(ticketId: ticket.id));

          // Navigate to detail screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<TicketBloc>(),
                child: const TicketDetailScreen(),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Detail screen for a single ticket
class TicketDetailScreen extends StatelessWidget {
  const TicketDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket Detail')),
      body: BlocBuilder<TicketBloc, TicketState>(
        builder: (context, state) {
          print('🎨 REBUILDING DETAIL SCREEN for: $state');

          if (state is TicketLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TicketDetailLoaded) {
            final ticket = state.ticket;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.image, size: 64),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    ticket.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Text(
                    '\$${ticket.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    ticket.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // Date
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${ticket.date.day}/${ticket.date.month}/${ticket.date.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Book button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Booked: ${ticket.title}')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Book Ticket',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is TicketError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('No ticket selected'));
        },
      ),
    );
  }
}
