import 'package:flutter/material.dart';
import '../screens/main_screen_tabs/mainTabs_screen.dart';


enum AppRoute {
  tabs,
  postDetail
}

class RouteManager extends StatelessWidget {
  const RouteManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rotas',
      theme: ThemeData(),
      initialRoute: AppRoutes.getRoute(AppRoute.tabs),
      routes: AppRoutes.routes,
    );
  }
}

class AppRoutes {
  static const Map<AppRoute, String> _routeNames = {
    AppRoute.tabs: '/tabs',
    AppRoute.postDetail: '/postDetail',
  };

  static String getRoute(AppRoute route) => _routeNames[route]!;

  static final Map<String, WidgetBuilder> routes = {
    getRoute(AppRoute.tabs): (context) => MainTabsScreen(),
  };
}
