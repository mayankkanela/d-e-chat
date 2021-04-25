class CurrentUser {
  final String email;
  final String userId;
  final String appKey;
  final String privateKey;
  final String publicKey;

  CurrentUser({
    required this.email,
    required this.userId,
    required this.appKey,
    required this.privateKey,
    required this.publicKey,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
        email: json["email"],
        userId: json["userId"],
        appKey: json["encAppKey"],
        privateKey: json["encPrivateKey"],
        publicKey: json["encPublicKey"]);
  }
}
