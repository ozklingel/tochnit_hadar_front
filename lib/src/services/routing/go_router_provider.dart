import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:hadar_program/src/views/primary/bottom_bar/ui/dashboard_screen.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/apprentice_details.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/apprentices_or_users_screen.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_user/new_user_screen.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/gift_screen.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/home_screen.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/message_details_screen.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/messages_screen.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/new_message_screen/new_message_screen.dart';
import 'package:hadar_program/src/views/primary/pages/report/view/report_details_screen.dart';
import 'package:hadar_program/src/views/primary/pages/report/view/reports_screen.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/views/new_or_edit_task_screen.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/views/task_details_screen.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/views/tasks_screen.dart';
import 'package:hadar_program/src/views/secondary/error/route_error_screen.dart';
import 'package:hadar_program/src/views/secondary/institutions/views/institution_details_screen.dart';
import 'package:hadar_program/src/views/secondary/institutions/views/institutions_screen.dart';
import 'package:hadar_program/src/views/secondary/institutions/views/new_or_edit_institution_screen.dart';
import 'package:hadar_program/src/views/secondary/onboarding/onboarding_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../views/primary/pages/chat_box/support_screen.dart';
import '../../views/primary/pages/notifications/views/notification_screen.dart';
import '../../views/primary/pages/notifications/views/setting_page.dart';
import '../../views/primary/pages/profile/edit_profile.dart';
import '../../views/primary/pages/profile/user_profile_screen.dart';

part 'go_router_provider.g.dart';

final _rootNavKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _messagesNavKey = GlobalKey<NavigatorState>(debugLabel: 'messages');
final _tasksNavKey = GlobalKey<NavigatorState>(debugLabel: 'tasks');
final _homeNavKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _reportsNavKey = GlobalKey<NavigatorState>(debugLabel: 'reports');
final _apprenticesNavKey = GlobalKey<NavigatorState>(debugLabel: 'apprentices');

@Riverpod(
  dependencies: [
    storage,
  ],
)
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
      final userPhone = ref
              .watch(
                storageProvider,
              )
              .requireValue
              .getString(
                Consts.userPhoneKey,
              ) ??
          '';

      // if (userPhone.isEmpty) {
      //   return const OnboardingRouteData().location;
      // }
      //
      // final firstOnboarding = ref.read(storageProvider).requireValue.getBool(
      //           Consts.firstOnboardingKey,
      //         ) ??
      //     false;
      //
      // if (firstOnboarding) {
      //   return OnboardingRouteData(isOnboarding: firstOnboarding).location;
      // }

      return null;
    },
  );
}

@TypedStatefulShellRoute<DashboardShellRouteData>(
  branches: [
    TypedStatefulShellBranch<TasksBranchData>(
      routes: [
        TypedGoRoute<TasksRouteData>(
          path: '/tasks',
          routes: [
            TypedGoRoute<NewTaskRouteData>(
              path: 'new',
            ),
            TypedGoRoute<EditTaskRouteData>(
              path: 'edit/:id',
            ),
            TypedGoRoute<TaskDetailsRouteData>(
              path: 'details/:id',
            ),
          ],
        ),
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
            TypedGoRoute<InstitutionsRouteData>(
              path: 'institutions',
              routes: [
                TypedGoRoute<InstitutionDetailsRouteData>(
                  path: 'details/:id',
                ),
                TypedGoRoute<NewInstitutionRouteData>(
                  path: 'new',
                ),
              ],
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

class NewTaskRouteData extends GoRouteData {
  const NewTaskRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NewOrEditTaskScreen(id: '');
  }
}

class EditTaskRouteData extends GoRouteData {
  const EditTaskRouteData({
    this.id = '',
  });

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NewOrEditTaskScreen(id: id);
  }
}

class TaskDetailsRouteData extends GoRouteData {
  const TaskDetailsRouteData({
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TaskDetailsScreen(id: id);
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
  const OnboardingRouteData({
    this.isOnboarding = false,
  });

  final bool isOnboarding;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return OnboardingScreen(isOnboarding: isOnboarding);
  }
}

@TypedGoRoute<SupportRouteData>(
  path: '/support',
)
class SupportRouteData extends GoRouteData {
  const SupportRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SupportScreen();
  }
}

@TypedGoRoute<UserProfileRouteData>(
  path: '/userProfile',
)
class UserProfileRouteData extends GoRouteData {
  const UserProfileRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UserProfileScreen();
  }
}

@TypedGoRoute<EditUserProfileRouteData>(
  path: '/editUserProfile',
)
class EditUserProfileRouteData extends GoRouteData {
  const EditUserProfileRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfileEditPage();
  }
}

@TypedGoRoute<NotificationRouteData>(
  path: '/notifications',
)
class NotificationRouteData extends GoRouteData {
  const NotificationRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NotificationScreen();
  }
}

@TypedGoRoute<NotificationSettingRouteData>(
  path: '/NotificationSettings',
)
class NotificationSettingRouteData extends GoRouteData {
  const NotificationSettingRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingPage();
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

class InstitutionsRouteData extends GoRouteData {
  const InstitutionsRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _homeNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InstitutionsScreen();
  }
}

class InstitutionDetailsRouteData extends GoRouteData {
  const InstitutionDetailsRouteData({
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return InstitutionDetailsScreen(
      id: id,
    );
  }
}

class NewInstitutionRouteData extends GoRouteData {
  const NewInstitutionRouteData({
    this.id = '',
  });

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NewOrEditInstitutionScreen(
      id: id,
    );
  }
}
