import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rocnikovy/views/home_page.dart';
import 'package:flutter_rocnikovy/views/login_page.dart';
import 'package:flutter_rocnikovy/views/main_page.dart';
import 'package:flutter_rocnikovy/views/my_team_page.dart';
import 'package:flutter_rocnikovy/views/user_details_page.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings routeSettings) {
    switch(routeSettings.name) {
      case '/login':
        return platformPageRoute(builder: (_) => const LoginPage());
      case '/homePage':
        return platformPageRoute(builder:(_) => HomePage());
      case '/mainPage':
        return platformPageRoute(builder:(_) => const MainScreen());
      case '/homePage/users':
        return platformPageRoute(builder:(_) =>  MyTeamPage(teamId: 2, scannedFlag: false,));  
      case '/homePage/userDetails':
        return platformPageRoute(builder: (_) => UserDetailsPage(id: routeSettings.arguments as int));
    }
    return platformPageRoute(builder: (_) => const LoginPage());
  }

  static PageRoute platformPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    String? iosTitle,
  }) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(
        builder: builder,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        title: iosTitle,
      );
    } else {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      );

    }
  }
}