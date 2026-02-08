/// JWT Tokens Model
///
/// Represents the access and refresh tokens from authentication responses.
class TokensModel {
  final String access;
  final String refresh;

  TokensModel({required this.access, required this.refresh});

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(
      access: json['access'] ?? '',
      refresh: json['refresh'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'access': access, 'refresh': refresh};
  }

  /// Check if tokens are valid (non-empty)
  bool get isValid => access.isNotEmpty && refresh.isNotEmpty;
}
