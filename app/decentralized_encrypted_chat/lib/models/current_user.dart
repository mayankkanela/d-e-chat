class CurrentUser {
  final String email;
  final String userId;
  final String encSymAppKey;
  final String encAsymPvtKey;
  final String asymPubKey;

  CurrentUser({
    required this.email,
    required this.userId,
    required this.encSymAppKey,
    required this.encAsymPvtKey,
    required this.asymPubKey,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
        email: json["email"],
        userId: json["userId"],
        encSymAppKey: json["encSymAppKey"],
        encAsymPvtKey: json["encAsymPvtKey"],
        asymPubKey: json["asymPubKey"]);
  }
}
