class Constants {
  /// ROUTE: /sign-up
  static const ROUTE_SIGN_UP = "/sign-up";

  /// ROUTE: /sign-in
  static const ROUTE_SIGN_IN = "/sign-in";

  /// ROUTE: /home
  static const ROUTE_HOME = "/home";

  /// ROUTE: /chatScreen
  static const ROUTE_CHAT_SCREEN = "/chatScreen";

  /// ROUT: /groupChatScreen
  static const ROUTE_GROUP_CHAT_SCREEN = "/groupChatScreen";

  /// Collection id: users, contains all user related data.
  static const USERS = "users";

  /// Collection id: chats, contains all chat related data.
  @Deprecated("Reworked and moved")
  static const CHATS = "chats";

  /// Collection id: sessions, sub-collection to document inside chats.
  static const SESSIONS = "sessions";

  /// Collection id: messages, sub-collection to document inside sessions.
  static const MESSAGES = "messages";

  /// Collection id: chats2
  static const CHATS2 = "chats2";

  /// Used for generating random characters
  static const VECTORS = [
    r"`~!@#$%^&&*()_+{}:|<>?|-=[];'\,./\",
    "1234567890",
    "QWQERTYUIOPASDFGHJKLZXCVBNM",
    "qwertyuiopasdfghjkklzxcvbnm"
  ];
}
