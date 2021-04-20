import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case Constants.ROUTE_SIGN_UP:
      //   return MaterialPageRoute(builder: (_) => SignUp());
      // case Constants.ROUTE_SIGN_IN:
      //   return MaterialPageRoute(builder: (_) => SignIn());
      // case Constants.ROUTE_HOME:
      //   return MaterialPageRoute(builder: (_) => Home());
    }
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              body:
                  Center(child: Text('No route defined for ${settings.name}')),
            ));
  }
}
