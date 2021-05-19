class CurrentUser {
  final String email;
  final String userId;
  final String encAsymPvtKey;
  final String asymPubKey;
  final String encSymAppKey;

  const CurrentUser({
    required this.email,
    required this.encSymAppKey,
    required this.userId,
    required this.encAsymPvtKey,
    required this.asymPubKey,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      email: json["email"],
      encSymAppKey: json["encSymAppKey"],
      userId: json["userId"],
      encAsymPvtKey: json["encAsymPvtKey"],
      asymPubKey: json["asymPubKey"],
    );
  }
}
