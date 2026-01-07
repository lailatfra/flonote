import 'package:get/get.dart';
import '../modules/apppreferences/bindings/apppreferences_binding.dart';
import '../modules/apppreferences/views/apppreferences_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/controllers/edit_profile_controller.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/new/bindings/new_binding.dart';
import '../modules/new/views/new_view.dart';
import '../modules/note/bindings/note_binding.dart';
import '../modules/note/views/note_view.dart';
import '../modules/passwordsecurity/bindings/passwordsecurity_binding.dart';
import '../modules/passwordsecurity/views/passwordsecurity_view.dart';
import '../modules/privatenotes/bindings/privatenotes_binding.dart';
import '../modules/privatenotes/views/privatenotes_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/welcome_view.dart';
import '../modules/welcome2/bindings/welcome2_binding.dart';
import '../modules/welcome2/views/welcome2_view.dart';
import '../modules/welcome3/bindings/welcome3_binding.dart';
import '../modules/welcome3/views/welcome3_view.dart';
import '../modules/welcome4/bindings/welcome4_binding.dart';
import '../modules/welcome4/views/welcome4_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => WelcomeView(),
      binding: WelcomeBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.WELCOME2,
      page: () => Welcome2View(),
      binding: Welcome2Binding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.WELCOME3,
      page: () => Welcome3View(),
      binding: Welcome3Binding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.WELCOME4,
      page: () => const Welcome4View(),
      binding: Welcome4Binding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.NOTE,
      page: () => const NoteView(),
      binding: NoteBinding(),
    ),
    GetPage(
      name: _Paths.NEW,
      page: () => const NewView(),
      binding: NewBinding(),
    ),
    GetPage(
      name: _Paths.APPPREFERENCES,
      page: () => const ApppreferencesView(),
      binding: ApppreferencesBinding(),
    ),
    GetPage(
      name: _Paths.PASSWORDSECURITY,
      page: () => const PasswordsecurityView(),
      binding: PasswordsecurityBinding(),
    ),
    GetPage(
      name: _Paths.PRIVATENOTES,
      page: () => const PrivatenotesView(),
      binding: PrivatenotesBinding(),
    ),
  ];
}