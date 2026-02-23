import 'user_model.dart';

class AuthModel {
  final UserModel user;
  final String token;

  AuthModel({required this.user, required this.token});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      user: UserModel.fromJson(json['user']),
      token: json['token'] ?? json['access_token'] ?? '',
    );
  }
}
