import 'user_model.dart';
import 'tokens_model.dart';

/// Auth Response Model
///
/// Represents the combined response from login/register containing user and tokens.
class AuthResponseModel {
  final UserModel user;
  final TokensModel tokens;

  AuthResponseModel({required this.user, required this.tokens});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserModel.fromJson(json['user'] ?? {}),
      tokens: TokensModel.fromJson(json['tokens'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'tokens': tokens.toJson()};
  }
}
