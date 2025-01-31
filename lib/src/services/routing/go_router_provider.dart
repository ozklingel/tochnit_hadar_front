import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:hadar_program/src/views/primary/bottom_bar/ui/dashboard_screen.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_persona_screen.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/persona_details_screen.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/personas_screen.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/gift_screen.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/home_screen.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/forgotten_persona_screen.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/melave_performance_screen.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/persona_status_screen.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/rakazim_performance_screen.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/persona_performance_screen_institution.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/message_details_screen.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/messages_screen.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/new_message_screen/new_or_edit_message_screen.dart';
import 'package:hadar_program/src/views/primary/pages/report/view/report_details_screen.dart';
import 'package:hadar_program/src/views/primary/pages/report/view/reports_screen.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/views/new_or_edit_task_screen.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/views/task_details_screen.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/views/tasks_screen.dart';
import 'package:hadar_program/src/views/secondary/charts/charts_screen.dart';
import 'package:hadar_program/src/views/secondary/charts/charts_settings_screen.dart';
import 'package:hadar_program/src/views/secondary/error/route_error_screen.dart';
import 'package:hadar_program/src/views/secondary/institutions/views/add_institutions_from_excel_screen.dart';
import 'package:hadar_program/src/views/secondary/institutions/views/institution_details_screen.dart';
import 'package:hadar_program/src/views/secondary/institutions/views/institution_type_picker_screen.dart';
import 'package:hadar_program/src/views/secondary/institutions/views/institutions_screen.dart';
import 'package:hadar_program/src/views/secondary/institutions/views/new_or_edit_institution_screen.dart';
import 'package:hadar_program/src/views/secondary/onboarding/onboarding_screen.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../views/primary/pages/chat_box/support_screen.dart';
import '../../views/primary/pages/notifications/views/notifications_screen.dart';
import '../../views/primary/pages/notifications/views/notifications_setting_page.dart';
import '../../views/primary/pages/profile/views/user_profile_screen.dart';

part 'go_router_provider.g.dart';

final _rootNavKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _messagesNavKey = GlobalKey<NavigatorState>(debugLabel: 'messages');
final _tasksNavKey = GlobalKey<NavigatorState>(debugLabel: 'tasks');
final _homeNavKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _reportsNavKey = GlobalKey<NavigatorState>(debugLabel: 'reports');
final _apprenticesNavKey = GlobalKey<NavigatorState>(debugLabel: 'apprentices');

@Riverpod(
  dependencies: [
    StorageService,
  ],
)
class GoRouterService extends _$GoRouterService {
  @override
  GoRouter build() {
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
        final userPhone =
            ref.read(storageServiceProvider.notifier).getUserPhone();

        final accessToken =
            ref.read(storageServiceProvider.notifier).getAuthToken();

        if (userPhone.isEmpty || accessToken.isEmpty) {
          Logger().w('empty userPhone');

          return const OnboardingRouteData().location;
        }

        final firstOnboarding =
            ref.read(storageServiceProvider).requireValue.getBool(
                      Consts.isFirstOnboardingKey,
                    ) ??
                false;

        if (firstOnboarding) {
          Logger().w('empty firstOnboarding');

          return OnboardingRouteData(isOnboarding: firstOnboarding).location;
        }

        return null;
      },
    );
  }
}

@TypedStatefulShellRoute<DashboardShellRouteData>(
  branches: [
    TypedStatefulShellBranch<TasksBranchData>(
      routes: [
        TypedGoRoute<TasksRouteData>(
          path: TasksScreen.path,
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
              routes: [
                TypedGoRoute<ReportDupeRouteData>(
                  path: ':id',
                ),
              ],
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
            TypedGoRoute<PersonaStatusRouteData>(
              path: 'status',
            ),
            TypedGoRoute<MelavePerformanceRouteData>(
              path: 'performance',
              routes: [
                TypedGoRoute<MelavePerformanceByInstitutionRouteData>(
                  path: 'institution/:id',
                ),
                TypedGoRoute<RakazimMosadPerformanceRouteData>(
                  path: 'rakazim-mosad',
                ),
                TypedGoRoute<RakazimEshkolPerformanceRouteData>(
                  path: 'rakazim-eshkol',
                ),
              ],
            ),
            TypedGoRoute<ForgottenApprenticesRouteData>(
              path: 'forgotten',
            ),
            TypedGoRoute<ChartsRouteData>(
              path: 'charts',
              routes: [
                TypedGoRoute<ChartsSettingsRouteData>(
                  path: 'settings',
                ),
                TypedGoRoute<ChartsInstitutionRouteData>(
                  path: 'institution/:id',
                ),
              ],
            ),
            TypedGoRoute<InstitutionsRouteData>(
              path: 'institutions',
              routes: [
                TypedGoRoute<EshkolInstitutionsRouteData>(
                  path: 'eshkol/:eshkol',
                ),
                TypedGoRoute<InstitutionTypePickerRouteData>(
                  path: 'type-picker',
                ),
                TypedGoRoute<InstitutionFromExcelRouteData>(
                  path: 'excel',
                ),
                TypedGoRoute<NewInstitutionRouteData>(
                  path: 'new',
                ),
                TypedGoRoute<InstitutionDetailsRouteData>(
                  path: 'details/:id',
                ),
                TypedGoRoute<EditInstitutionRouteData>(
                  path: 'edit/:id',
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
            TypedGoRoute<MessageDetailsRouteData>(
              path: 'id/:id',
            ),
            TypedGoRoute<EditMessageRouteData>(
              path: 'edit/:id',
            ),
            TypedGoRoute<NewMessageRouteData>(
              path: 'new',
              routes: [
                TypedGoRoute<DupeMessageRouteData>(
                  path: ':id',
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ApprenticesBranchData>(
      routes: [
        TypedGoRoute<PersonasRouteData>(
          path: '/personas',
          routes: [
            TypedGoRoute<PersonaDetailsRouteData>(
              path: 'details/:id',
            ),
            TypedGoRoute<NewPersonaRouteData>(
              path: 'new',
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
  const NewTaskRouteData([this.subjectId]);
  final String? subjectId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NewOrEditTaskScreen(
      id: '',
      subjectId: subjectId,
    );
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
      id: id,
    );
  }
}

class NotificationDetailsRouteData extends GoRouteData {
  const NotificationDetailsRouteData({
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    // Temporarily disable this, due to a build bug
    return const Text('NotificationDetailsRouteData');
    // return NotificationDetailsScreen(
    //   id: id,
    // );
  }
}

class NewMessageRouteData extends GoRouteData {
  const NewMessageRouteData({
    this.initRecpients = const [],
  });

  final List<String> initRecpients;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NewOrEditMessageScreen(
      initRecipients: initRecpients,
    );
  }
}

class EditMessageRouteData extends GoRouteData {
  const EditMessageRouteData({
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NewOrEditMessageScreen(
      id: id,
    );
  }
}

class DupeMessageRouteData extends GoRouteData {
  const DupeMessageRouteData({
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NewOrEditMessageScreen(
      id: id,
      isDupe: true,
    );
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
      personaId: apprenticeId,
    );
  }
}

class ReportNewRouteData extends GoRouteData {
  const ReportNewRouteData({
    this.initRecipients = const [],
    this.taskIds,
  });

  final List<String> initRecipients;
  final List<String>? taskIds;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ReportDetailsScreen(
      reportId: '',
      isReadOnly: false,
      initRecipients: initRecipients,
      isDupe: false,
      taskIds: taskIds,
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
      initRecipients: const [],
      isDupe: false,
    );
  }
}

class ReportDupeRouteData extends GoRouteData {
  const ReportDupeRouteData({
    required this.id,
  });

  final String id;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ReportDetailsScreen(
      reportId: id,
      isReadOnly: false,
      initRecipients: const [],
      isDupe: true,
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
      initRecipients: const [],
      isDupe: false,
    );
  }
}

class PersonasRouteData extends GoRouteData {
  const PersonasRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PersonasScreen();
  }
}

class PersonaDetailsRouteData extends GoRouteData {
  const PersonaDetailsRouteData({
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PersonaDetailsScreen(
      apprenticeId: id,
    );
  }
}

class NewPersonaRouteData extends GoRouteData {
  const NewPersonaRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NewPersonaScreen();
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

@TypedGoRoute<NotificationRouteData>(
  path: '/notifications',
  routes: [
    TypedGoRoute<NotificationDetailsRouteData>(path: 'id/:id'),
  ],
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
    return const NotificationsSettingsScreen();
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

class PersonaStatusRouteData extends GoRouteData {
  const PersonaStatusRouteData({
    required this.initIndex,
    required this.title,
    required this.subtitle,
  });

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  final String title;
  final String subtitle;
  final int initIndex;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PersonaStatusScreen(
      title: title,
      initIndex: initIndex,
      subtitle: subtitle,
    );
  }
}

class MelavePerformanceRouteData extends GoRouteData {
  const MelavePerformanceRouteData({
    this.title = '',
    this.subtitle = '',
  });

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MelavePerformanceScreen(
      title: title,
      subtitle: subtitle,
    );
  }
}

class MelavePerformanceByInstitutionRouteData extends GoRouteData {
  const MelavePerformanceByInstitutionRouteData({
    required this.id,
  });

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PersonaPerformanceByInstitutionScreen(
      title: 'תפקוד מלווים',
      institutionId: id,
    );
  }
}

class RakazimMosadPerformanceRouteData extends GoRouteData {
  const RakazimMosadPerformanceRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RakazimPerformanceScreen(
      title: 'תפקוד רכזים',
      type: UserRole.rakazMosad,
    );
  }
}

class RakazimEshkolPerformanceRouteData extends GoRouteData {
  const RakazimEshkolPerformanceRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RakazimPerformanceScreen(
      title: 'תפקוד רכזים',
      type: UserRole.rakazEshkol,
    );
  }
}

class ForgottenApprenticesRouteData extends GoRouteData {
  const ForgottenApprenticesRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ForgottenApprenticesScreen();
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

class EshkolInstitutionsRouteData extends GoRouteData {
  const EshkolInstitutionsRouteData({
    this.eshkol = '',
  });

  final String eshkol;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return InstitutionsScreen(eshkol: eshkol);
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

class InstitutionTypePickerRouteData extends GoRouteData {
  const InstitutionTypePickerRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InstitutionTypePickerScreen();
  }
}

class InstitutionFromExcelRouteData extends GoRouteData {
  const InstitutionFromExcelRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AddInstitutionFromExcel();
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

class EditInstitutionRouteData extends GoRouteData {
  const EditInstitutionRouteData({
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

class ChartsRouteData extends GoRouteData {
  const ChartsRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChartsScreen();
  }
}

class ChartsSettingsRouteData extends GoRouteData {
  const ChartsSettingsRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChartsSettingsScreen();
  }
}

class ChartsInstitutionRouteData extends GoRouteData {
  const ChartsInstitutionRouteData({
    required this.id,
  });

  final String id;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    Toaster.unimplemented();

    return const Placeholder();
  }
}
