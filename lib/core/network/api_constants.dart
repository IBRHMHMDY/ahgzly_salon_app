import 'package:ahgzly_salon_app/core/config/env_config.dart';

class ApiConstants {
  static String get baseUrl => EnvConfig.ipDevice;
  // Endpoints
  static const String login = "/login";
  static const String register = "/register";
  static const String profile = "/profile";
  static const String editProfile = "/profile/edit";
  static const String logout = "/logout";
}
