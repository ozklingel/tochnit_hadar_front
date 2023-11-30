import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hadar_program/src/views/primary/bottom_bar/ui/dashboard_screen.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/apprentice_details.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/apprentices_or_users_screen.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_user/new_user_screen.dart';
import 'package:hadar_program/src/views/primary/pages/homePage/views/gift_screen.dart';
import 'package:hadar_program/src/views/primary/pages/homePage/views/home_screen.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/message_details_screen.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/messages_screen.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/new_message_screen/new_message_screen.dart';
import 'package:hadar_program/src/views/primary/pages/report/view/report_details_screen.dart';
import 'package:hadar_program/src/views/primary/pages/report/view/reports_screen.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/views/tasks_screen.dart';
import 'package:hadar_program/src/views/secondary/error/route_error_screen.dart';
import 'package:hadar_program/src/views/secondary/onboarding/onboarding_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_provider.g.dart';

final _rootNavKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _messagesNavKey = GlobalKey<NavigatorState>(debugLabel: 'messages');
final _tasksNavKey = GlobalKey<NavigatorState>(debugLabel: 'tasks');
final _homeNavKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _reportsNavKey = GlobalKey<NavigatorState>(debugLabel: 'reports');
final _apprenticesNavKey = GlobalKey<NavigatorState>(debugLabel: 'apprentices');

@Riverpod(dependencies: [])
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: const HomeRouteData().location,
    debugLogDiagnostics: kDebugMode,
    observers: [
      BotToastNavigatorObserver(),
    ],
    errorBuilder: (context, state) => RouteErrorScreen(
      errorMsg: state.error.toString(),
      key: state.pageKey,
    ),
    routes: $appRoutes,
    redirect: (context, state) {
      return null;
    },
  );
}

@TypedStatefulShellRoute<DashboardShellRouteData>(
  branches: [
    TypedStatefulShellBranch<TasksBranchData>(
      routes: [
        TypedGoRoute<TasksRouteData>(path: '/tasks'),
      ],
    ),
    TypedStatefulShellBranch<ReportsBranchData>(
      routes: [
        TypedGoRoute<ReportsRouteData>(
          path: '/reports',
          routes: [
            TypedGoRoute<ReportNewRouteData>(
              path: 'new',
            ),
            TypedGoRoute<ReportEditRouteData>(
              path: 'edit/:id',
            ),
            TypedGoRoute<ReportDetailsRouteData>(
              path: 'details/:id',
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<HomeBranchData>(
      routes: [
        TypedGoRoute<HomeRouteData>(
          path: '/home',
          routes: [
            TypedGoRoute<GiftRouteData>(
              path: 'gift/:id',
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<MessagesBranchData>(
      routes: [
        TypedGoRoute<MessagesRouteData>(
          path: '/messages',
          routes: [
            TypedGoRoute<MessageDetailsRouteData>(path: 'id/:id'),
            TypedGoRoute<NewMessageRouteData>(path: 'new'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ApprenticesBranchData>(
      routes: [
        TypedGoRoute<ApprenticesOrUsersRouteData>(
          path: '/apprentices-or-users',
          routes: [
            TypedGoRoute<ApprenticeDetailsRouteData>(
              path: 'details/:id',
            ),
            TypedGoRoute<NewUserRouteData>(
              path: 'new-user',
            ),
          ],
        ),
      ],
    ),
  ],
)
class DashboardShellRouteData extends StatefulShellRouteData {
  const DashboardShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return navigationShell;
  }

  static const String $restorationScopeId = 'restorationScopeId';

  static Widget $navigatorContainerBuilder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) {
    return DashboardScreen(
      navShell: navigationShell,
      children: children,
    );
  }
}

class TasksBranchData extends StatefulShellBranchData {
  const TasksBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey = _tasksNavKey;
  static const String $restorationScopeId = 'restorationScopeId';
}

class MessagesBranchData extends StatefulShellBranchData {
  const MessagesBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey = _messagesNavKey;
  static const String $restorationScopeId = 'restorationScopeId';
}

class HomeBranchData extends StatefulShellBranchData {
  const HomeBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey = _homeNavKey;
  static const String $restorationScopeId = 'restorationScopeId';
}

class ReportsBranchData extends StatefulShellBranchData {
  const ReportsBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey = _reportsNavKey;
  static const String $restorationScopeId = 'restorationScopeId';
}

class ApprenticesBranchData extends StatefulShellBranchData {
  const ApprenticesBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey = _apprenticesNavKey;
  static const String $restorationScopeId = 'restorationScopeId';
}

class TasksRouteData extends GoRouteData {
  const TasksRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TasksScreen();
  }
}

class MessagesRouteData extends GoRouteData {
  const MessagesRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MessagesScreen();
  }
}

class MessageDetailsRouteData extends GoRouteData {
  const MessageDetailsRouteData({
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MessageDetailsScreen(
      messageId: id,
    );
  }
}

class NewMessageRouteData extends GoRouteData {
  const NewMessageRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NewMessageScreen();
  }
}

class HomeRouteData extends GoRouteData {
  const HomeRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

class ReportsRouteData extends GoRouteData {
  const ReportsRouteData({
    this.apprenticeId = '',
  });

  final String apprenticeId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ReportsScreen(
      apprenticeId: apprenticeId,
    );
  }
}

class ReportNewRouteData extends GoRouteData {
  const ReportNewRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ReportDetailsScreen(
      reportId: '',
      isReadOnly: false,
    );
  }
}

class ReportEditRouteData extends GoRouteData {
  const ReportEditRouteData({
    required this.id,
  });

  final String id;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ReportDetailsScreen(
      reportId: id,
      isReadOnly: false,
    );
  }
}

class ReportDetailsRouteData extends GoRouteData {
  const ReportDetailsRouteData({
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ReportDetailsScreen(
      reportId: id,
      isReadOnly: true,
    );
  }
}

class ApprenticesOrUsersRouteData extends GoRouteData {
  const ApprenticesOrUsersRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ApprenticesOrUsersScreen();
  }
}

class ApprenticeDetailsRouteData extends GoRouteData {
  const ApprenticeDetailsRouteData({
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ApprenticeDetailsScreen(
      apprenticeId: id,
    );
  }
}

class NewUserRouteData extends GoRouteData {
  const NewUserRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NewUserScreen();
  }
}

@TypedGoRoute<OnboardingRouteData>(
  path: '/onboarding',
)
class OnboardingRouteData extends GoRouteData {
  const OnboardingRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OnboardingScreen();
  }
}

class GiftRouteData extends GoRouteData {
  const GiftRouteData({
    required this.id,
  });

  final String id;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return GiftScreen(
      eventId: id,
    );
  }
}
