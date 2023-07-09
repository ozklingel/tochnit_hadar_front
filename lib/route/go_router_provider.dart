import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/route/named_route.dart';
import '/screen/apprentices/apprenticeScreen.dart';
import '/screen/bottomeBar//ui/dashboard_screen.dart';
import '/screen/error/route_error_screen.dart';
import '/screen/homePage/home_screen.dart';
import '/screen/messages/messagesScreen.dart';
import '../screen/report/report_screen.dart';
import '../screen/tasks/TasksScreen.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigator =
    GlobalKey(debugLabel: 'shell');

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigator,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/home',
        name: root,
        builder: (context, state) => HomeScreen(key: state.pageKey),
      ),
      ShellRoute(
          navigatorKey: _shellNavigator,
          builder: (context, state, child) =>
              DashboardScreen(key: state.pageKey, child: child),
          routes: [
            GoRoute(
              path: '/',
              name: home,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: HomeScreen(
                  key: state.pageKey,
                ));
              },
            ),
            GoRoute(
              path: '/apprentice',
              name: cart,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: ApprenticeScreen(
                  key: state.pageKey,
                ));
              },
            ),
            GoRoute(
              path: '/messages',
              name: setting,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: MessagesScreen(
                  key: state.pageKey,
                ));
              },
            ),
            GoRoute(
              path: '/report',
              name: report,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: ReportScreen(
                  key: state.pageKey,
                ));
              },
            ),
            GoRoute(
              path: '/tasks',
              name: tasks,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: TasksScreen(
                  key: state.pageKey,
                ));
              },
            )
          ])
    ],
    errorBuilder: (context, state) => RouteErrorScreen(
      errorMsg: state.error.toString(),
      key: state.pageKey,
    ),
  );
});
