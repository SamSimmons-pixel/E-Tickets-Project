import 'package:e_tickets/bloc/auth_bloc.dart';
import 'package:e_tickets/bloc/auth_event.dart';
import 'package:e_tickets/bloc/auth_state.dart';
import 'package:e_tickets/bloc/booking/booking_bloc.dart';
import 'package:e_tickets/bloc/ticket_bloc.dart';
import 'package:e_tickets/repositories/booking_repository.dart';
import 'package:e_tickets/repositories/ticket_repository.dart';
import 'package:e_tickets/screens/auth/login.dart';
import 'package:e_tickets/screens/auth/register_screen.dart';
import 'package:e_tickets/screens/booking/history_screen.dart';
import 'package:e_tickets/screens/dashboard/dashboard_screen.dart';
import 'package:e_tickets/screens/dashboard/ticket_detail.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

void main() {
  runApp(const ETicketingApp());
}

class ETicketingApp extends StatelessWidget {
  const ETicketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(const CheckAuthStatus()),
        ),
        BlocProvider<TicketBloc>(
          create: (context) => TicketBloc(ticketRepository: TicketRepository()),
        ),
        BlocProvider<BookingBloc>(
          create: (context) => BookingBloc(BookingRepository()),
        ),
      ],
      child: GetMaterialApp(
        title: 'E-Ticketing',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C63FF),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        initialRoute: '/splash',
        getPages: [
          GetPage(name: '/splash', page: () => const AuthWrapper()),
          GetPage(name: '/login', page: () => const LoginScreen()),
          GetPage(name: '/register', page: () => const RegisterScreen()),
          GetPage(name: '/dashboard', page: () => const DashboardScreen()),
          GetPage(
            name: '/ticket-detail',
            page: () => const TicketDetailScreen(),
          ),
          GetPage(name: '/history', page: () => const HistoryScreen()),
        ],
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const DashboardScreen();
        } else if (state is AuthUnauthenticated) {
          return const LoginScreen();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
