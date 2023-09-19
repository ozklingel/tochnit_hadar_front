import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hadar_program/src/services/routing/named_route.dart';
import 'package:hadar_program/src/views/primary/bottome_bar/ui/dashboard_screen.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/apprentice_screen.dart';
import 'package:hadar_program/src/views/primary/pages/homePage/home_screen.dart';
import 'package:hadar_program/src/views/primary/pages/messages/message_details_screen.dart';
import 'package:hadar_program/src/views/primary/pages/messages/messages_screen.dart';
import 'package:hadar_program/src/views/primary/pages/report/view/report_details_screen.dart';
import 'package:hadar_program/src/views/primary/pages/report/view/reports_screen.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/tasks_screen.dart';
import 'package:hadar_program/src/views/secondary/error/route_error_screen.dart';
import 'package:hadar_program/src/views/secondary/onboarding/onboarding_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_provider.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@Riverpod(dependencies: [])
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.home,
    debugLogDiagnostics: kDebugMode,
    observers: [
      BotToastNavigatorObserver(),
    ],
    errorBuilder: (context, state) => RouteErrorScreen(
      errorMsg: state.error.toString(),
      key: state.pageKey,
    ),
    routes: [
      GoRoute(
        path: OnboardingScreen.routeName,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) =>
            DashboardScreen(navShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.tasks,
                builder: (context, state) {
                  return const TasksScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.reports,
                builder: (context, state) {
                  return const ReportsScreen();
                },
                routes: [
                  GoRoute(
                    path: Routes.reportsNew,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      return const ReportDetailsScreen(
                        reportId: '',
                        isDetailsOnly: false,
                      );
                    },
                  ),
                  GoRoute(
                    path: '${Routes.reportsEdit}/:id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      return ReportDetailsScreen(
                        reportId: state.pathParameters['id'] ?? '',
                        isDetailsOnly: false,
                      );
                    },
                  ),
                  GoRoute(
                    path: '${Routes.reportsDetails}/:id',
                    builder: (context, state) {
                      return ReportDetailsScreen(
                        reportId: state.pathParameters['id'] ?? '',
                        isDetailsOnly: true,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) {
                  return const HomeScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.messages,
                builder: (context, state) {
                  return const MessagesScreen();
                },
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;

                      return MessageDetailsScreen(
                        messageId: id,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.apprentice,
                builder: (context, state) {
                  return const ApprenticeScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
