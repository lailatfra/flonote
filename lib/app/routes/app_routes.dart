part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const SPLASH = _Paths.SPLASH;
  static const WELCOME = _Paths.WELCOME;
  static const WELCOME2 = _Paths.WELCOME2;
  static const WELCOME3 = _Paths.WELCOME3;
  static const WELCOME4 = _Paths.WELCOME4;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const SETTING = _Paths.SETTING;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const NOTE = _Paths.NOTE;
  static const MAIN = _Paths.MAIN;
  static const NEW = _Paths.NEW;
  static const APPPREFERENCES = _Paths.APPPREFERENCES;
  static const PASSWORDSECURITY = _Paths.PASSWORDSECURITY;
  static const PRIVATENOTES = _Paths.PRIVATENOTES;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const SPLASH = '/splash';
  static const WELCOME = '/welcome';
  static const WELCOME2 = '/welcome2';
  static const WELCOME3 = '/welcome3';
  static const WELCOME4 = '/welcome4';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const SETTING = '/setting';
  static const EDIT_PROFILE = '/edit-profile';
  static const NOTE = '/note';
  static const MAIN = '/main';
  static const NEW = '/new';
  static const APPPREFERENCES = '/apppreferences';
  static const PASSWORDSECURITY = '/passwordsecurity';
  static const PRIVATENOTES = '/privatenotes';
}