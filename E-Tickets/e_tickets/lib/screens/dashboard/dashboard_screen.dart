import 'package:e_tickets/bloc/ticket_bloc.dart';
import 'package:e_tickets/bloc/ticket_event.dart';
import 'package:e_tickets/bloc/ticket_state.dart';
import 'package:e_tickets/screens/dashboard/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_tickets/bloc/auth_bloc.dart';
import 'package:e_tickets/bloc/auth_event.dart';
import 'package:e_tickets/bloc/auth_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TicketBloc>().add(LoadTickets());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            '/login',
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested()); // Hapus 'const'
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: BlocBuilder<TicketBloc, TicketState>(
          builder: (context, state) {
            if (state is TicketLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TicketLoaded) {
              return ListView.builder(
                itemCount: state.tickets.length,
                itemBuilder: (context, index) {
                  final ticket = state.tickets[index];
                  return EventCard(ticket: ticket);
                },
              );
            } else if (state is TicketError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No tickets found'));
            }
          },
        ),
      ),
    );
  }
}