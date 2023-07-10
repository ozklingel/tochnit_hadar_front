import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/routes/named_route.dart';
import '../screens/apprentices/apprenticeScreen.dart';
import '../screens/bottomeBar/ui/dashboard_screen.dart';
import '../screens/error/route_error_screen.dart';
import '../screens/homePage/home_screen.dart';
import '../screens/messages/messagesScreen.dart';
import '../screens/report/report_screen.dart';
import '../screens/tasks/TasksScreen.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigator =
    GlobalKey(debugLabel: 'shell');

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigator,
    initialLocation: Routes.HOME,
    routes: [
      ShellRoute(
          navigatorKey: _shellNavigator,
          builder: (context, state, child) =>
              DashboardScreen(key: state.pageKey, child: child),
          routes: [
            GoRoute(
              path: Routes.HOME,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: HomeScreen(
                  key: state.pageKey,
                ));
              },
            ),
            GoRoute(
              path: Routes.APPRENTICE,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: ApprenticeScreen(
                  key: state.pageKey,
                ));
              },
            ),
            GoRoute(
              path: Routes.MESSAGES,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: MessagesScreen(
                  key: state.pageKey,
                ));
              },
            ),
            GoRoute(
              path: Routes.REPORTS,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: ReportScreen(
                  key: state.pageKey,
                ));
              },
            ),
            GoRoute(
              path: Routes.TASKS,
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
