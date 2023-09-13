import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hadar_program/src/services/routing/named_route.dart';
import 'package:hadar_program/src/views/primary/bottome_bar/ui/dashboard_screen.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/apprentice_screen.dart';
import 'package:hadar_program/src/views/primary/pages/homePage/home_screen.dart';
import 'package:hadar_program/src/views/primary/pages/messages/messages_screen.dart';
import 'package:hadar_program/src/views/primary/pages/report/report_screen.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/tasks_screen.dart';
import 'package:hadar_program/src/views/secondary/error/route_error_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_provider.g.dart';

final _rootNavigator = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigator = GlobalKey<NavigatorState>(debugLabel: 'shell');

@Riverpod(dependencies: [])
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigator,
    initialLocation: Routes.home,
    debugLogDiagnostics: kDebugMode,
    errorBuilder: (context, state) => RouteErrorScreen(
      errorMsg: state.error.toString(),
      key: state.pageKey,
    ),
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigator,
        builder: (context, state, child) => DashboardScreen(
          key: state.pageKey,
          child: child,
        ),
        routes: [
          GoRoute(
            path: Routes.home,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: HomeScreen(
                  key: state.pageKey,
                ),
              );
            },
          ),
          GoRoute(
            path: Routes.apprentice,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: ApprenticeScreen(
                  key: state.pageKey,
                ),
              );
            },
          ),
          GoRoute(
            path: Routes.messages,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: MessagesScreen(
                  key: state.pageKey,
                ),
              );
            },
          ),
          GoRoute(
            path: Routes.reports,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: ReportScreen(
                  key: state.pageKey,
                ),
              );
            },
          ),
          GoRoute(
            path: Routes.tasks,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: TasksScreen(
                  key: state.pageKey,
                ),
              );
            },
          )
        ],
      ),
    ],
  );
}
