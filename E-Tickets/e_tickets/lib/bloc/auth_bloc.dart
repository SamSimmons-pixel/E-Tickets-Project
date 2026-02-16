import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:e_tickets/core/validators.dart';
import 'package:e_tickets/models/user.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '';

import './auth_event.dart';
import './auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  final String _userKey = 'user';

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final emailError = Validators.validateEmail(event.email);
      final passwordError = Validators.validatePassword(event.password);

      if (emailError != null || passwordError != null) {
        emit(AuthError(message: emailError ?? passwordError!));
        return;
      }

      await Future.delayed(const Duration(seconds: 2));

      final user = User(
        id: DateTime.now().millisecondsSinceEpoch,
        email: event.email,
        name: 'User_Demo',
        password: event.password,
        role: 'user',
      );

      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: 'Login gagal, coba lagi'));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final emailError = Validators.validateEmail(event.email);
      final passwordError = Validators.validatePassword(event.password);

      if (emailError != null || passwordError != null) {
        emit(AuthError(message: emailError ?? passwordError!));
        return;
      }

      await Future.delayed(const Duration(seconds: 2));

      final user = User(
        id: 123,
        email: event.email,
        name: event.name,
        password: event.password,
        role: 'user',
      );

      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: 'Register gagal, coba lagi'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool('isLoggedIn', false);
    emit(const AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Logout gagal, coba lagi'));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(const AuthUnauthenticated());

      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        final userJson = prefs.getString(_userKey);
        if (userJson != null) {
          final user = User.fromJson(jsonDecode(userJson));
          emit(AuthAuthenticated(user: user));
        } else {
          emit(const AuthUnauthenticated());
        }
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to check auth status: ${e.toString()}'));
    }
  }
}
