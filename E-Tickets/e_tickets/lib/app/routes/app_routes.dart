part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const TICKET_DETAIL = _Paths.TICKET_DETAIL;
  static const TICKET_LIST = _Paths.TICKET_LIST;
  static const HISTORY = _Paths.HISTORY;
}

abstract class _Paths {
  _Paths._();
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const DASHBOARD = '/dashboard';
  static const TICKET_DETAIL = '/ticket-detail';
  static const TICKET_LIST = '/ticket-list';
  static const HISTORY = '/history';
}
