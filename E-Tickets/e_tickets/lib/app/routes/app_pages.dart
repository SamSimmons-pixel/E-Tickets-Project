import 'package:e_tickets/screens/auth/login.dart';
import 'package:e_tickets/screens/auth/register_screen.dart';
import 'package:e_tickets/screens/booking/history_screen.dart';
import 'package:e_tickets/screens/dashboard/dashboard_screen.dart';
import 'package:e_tickets/screens/dashboard/ticket_detail.screen.dart';
import 'package:e_tickets/screens/ticket_list_screen.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.LOGIN;

  static final routes = [
    GetPage(name: _Paths.LOGIN, page: () => const LoginScreen()),
    GetPage(name: _Paths.REGISTER, page: () => const RegisterScreen()),
    GetPage(name: _Paths.DASHBOARD, page: () => const DashboardScreen()),
    GetPage(name: _Paths.TICKET_DETAIL, page: () => const TicketDetailScreen()),
    GetPage(name: _Paths.TICKET_LIST, page: () => const TicketListScreen()),
    GetPage(name: _Paths.HISTORY, page: () => const HistoryScreen()),
  ];
}
