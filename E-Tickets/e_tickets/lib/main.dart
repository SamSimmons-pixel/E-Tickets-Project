import 'package:e_tickets/app/modules/home/views/home_view.dart';
import 'package:e_tickets/bloc/auth_bloc.dart';
import 'package:e_tickets/bloc/auth_state.dart';
import 'package:e_tickets/screens/auth/login.dart';
import 'package:e_tickets/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_tickets/screens/dashboard/dashboard_screen.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => AuthBloc(),
      child: GetMaterialApp(
        title: "Application",
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
      ),
    ),
  );
}

class ETicketingApp extends StatelessWidget {
  const ETicketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(initialRoute: '/login');
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
