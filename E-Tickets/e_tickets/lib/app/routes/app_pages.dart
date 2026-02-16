import 'package:e_tickets/screens/auth/login.dart';
import 'package:e_tickets/screens/auth/register_screen.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.HOME;

  static final routes = [
    GetPage(name: _Paths.LOGIN, page: () => const LoginScreen()),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(name: _Paths.REGISTER, page: () => const RegisterScreen()),
  ];
}
