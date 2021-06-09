class Constants {
  /// ROUTE: /sign-up
  static const ROUTE_SIGN_UP = "/sign-up";

  /// ROUTE: /sign-in
  static const ROUTE_SIGN_IN = "/sign-in";

  /// ROUTE: /home
  static const ROUTE_HOME = "/home";

  /// ROUTE: /chatScreen
  static const ROUTE_CHAT_SCREEN = "/chatScreen";

  /// Collection id: users, contains all user related data.
  static const USERS = "users";

  /// Collection id: chats, contains all chat related data.
  static const CHATS = "chats";

  /// Collection id: sessions, sub-collection to document inside chats.
  static const SESSIONS = "sessions";

  /// Collection id: messages, sub-collection to document inside sessions.
  static const MESSAGES = "messages";

  /// Used for generating random characters
  static const VECTORS = [
    r"`~!@#$%^&&*()_+{}:|<>?|-=[];'\,./\",
    "1234567890",
    "QWQERTYUIOPASDFGHJKLZXCVBNM",
    "qwertyuiopasdfghjkklzxcvbnm"
  ];
}
