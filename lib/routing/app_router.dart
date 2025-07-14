import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jellyjelly/routing/router_constants.dart';
import '../main.dart';
import '../views/screens/rootPage.dart';
class AppRouter {
  GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
          name : RouteConstants.rootPage,
          path: '/',
          // path: '/rootPage',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: Rootpage(),
              transitionDuration: Duration(milliseconds: 300),
              transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
            );
          }
      ),

    ],
    errorPageBuilder: (context, state){
      return const MaterialPage(
          child: Scaffold(
            body: Center(
              child: Text('data'),
            )
          )
      );
    }
  );
}
