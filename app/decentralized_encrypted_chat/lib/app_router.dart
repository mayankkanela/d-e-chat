import 'package:decentralized_encrypted_chat/screens/auth/sign_in.dart';
import 'package:decentralized_encrypted_chat/screens/auth/sign_up.dart';
import 'package:decentralized_encrypted_chat/screens/chat/group/group_chat_screen.dart';
import 'package:decentralized_encrypted_chat/screens/chat/onetoone/chat_screen.dart';
import 'package:decentralized_encrypted_chat/screens/chat/screen_args_messages.dart';
import 'package:decentralized_encrypted_chat/screens/home/home.dart';
import 'package:decentralized_encrypted_chat/screens/splash.dart';
import 'package:decentralized_encrypted_chat/utils/constants.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Splash());

      case Constants.ROUTE_SIGN_UP:
        return MaterialPageRoute(builder: (_) => SignUp());

      case Constants.ROUTE_SIGN_IN:
        return MaterialPageRoute(builder: (_) => SignIn());

      case Constants.ROUTE_HOME:
        return MaterialPageRoute(builder: (_) => Home());

      case Constants.ROUTE_CHAT_SCREEN:
        {
          final ScreenArgsMessages screenArgsMessages =
              settings.arguments as ScreenArgsMessages;

          return MaterialPageRoute(
              builder: (_) => ChatScreen(
                    currentUser: screenArgsMessages.currentUser,
                    chat: screenArgsMessages.chatData,
                    chatKey: screenArgsMessages.chatKey,
                  ));
        }
      case Constants.ROUTE_GROUP_CHAT_SCREEN:
        {
          final ScreenArgsMessages screenArgsMessages =
              settings.arguments as ScreenArgsMessages;

          return MaterialPageRoute(
              builder: (_) => GroupChatScreen(
                    currentUser: screenArgsMessages.currentUser,
                    chat: screenArgsMessages.chatData,
                    chatKey: screenArgsMessages.chatKey,
                  ));
        }
    }
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              body:
                  Center(child: Text('No route defined for ${settings.name}')),
            ));
  }
}
