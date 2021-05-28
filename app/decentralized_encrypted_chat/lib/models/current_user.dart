class CurrentUser {
  static const EMAIL = "email";
  static const USER_ID = "userId";
  static const ENC_ASYM_PVT_KEY = "encAsymPvtKey";
  static const ENC_SYM_APP_KEY = "encSymAppKey";
  static const ASYM_PUB_KEY = "asymPubKey";

  final String email;
  final String userId;
  final String encAsymPvtKey;
  final String encSymAppKey;
  final String asymPubKey;

  const CurrentUser({
    required this.email,
    required this.encSymAppKey,
    required this.userId,
    required this.encAsymPvtKey,
    required this.asymPubKey,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      email: json[EMAIL],
      encSymAppKey: json[ENC_SYM_APP_KEY],
      userId: json[USER_ID],
      encAsymPvtKey: json[ENC_ASYM_PVT_KEY],
      asymPubKey: json[ASYM_PUB_KEY],
    );
  }
}
