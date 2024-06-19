import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/services/api/madadim/get_forgotten_apprentices.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/ahrai_home_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/ahrai_home.dto.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/side_menu_drawer.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/doughnut_charts_widget.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/home_header.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/performance_widget.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/upcoming_events_widget.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/upcoming_tasks_widget.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/controller/tasks_controller.dart';
import 'package:hadar_program/src/views/widgets/states/error_state.dart';
import 'package:hadar_program/src/views/widgets/states/loading_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);

    if (auth.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final user = auth.valueOrNull ?? const AuthDto();

    return Scaffold(
      drawer: const SideMenuDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Assets.images.logo.image(
          height: 42,
        ),
        actions: [
          ref.watch(tasksControllerProvider).when(
                loading: () => const CircularProgressIndicator.adaptive(),
                error: (error, stack) => IconButton(
                  onPressed: () => const NotificationRouteData().go(context),
                  icon: const Icon(Icons.ring_volume),
                ),
                data: (tasks) => IconButton(
                  onPressed: () => const NotificationRouteData().go(context),
                  icon: tasks.isEmpty
                      ? Assets.illustrations.alarmBell.svg()
                      : Assets.illustrations.alarmBellAlert.svg(),
                ),
              ),
        ],
      ),
      body: auth.when(
        loading: () => const LoadingState(),
        error: (error, stack) => ErrorState(error),
        data: (data) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const HomeHeader(),
              const SizedBox(height: 44),
              if (user.role == UserRole.melave)
                const _MelaveBody()
              else if ([
                UserRole.ahraiTohnit,
                UserRole.rakazEshkol,
                UserRole.rakazMosad,
              ].contains(user.role))
                const _AhraiTohnitBody()
              else
                const Center(child: Text('BAD USER ROLE')),
            ],
          ),
        ),
      ),
    );
  }
}

class _MelaveBody extends StatelessWidget {
  const _MelaveBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        UpcomingEventsWidget(),
        UpcomingTasksWidget(),
        SizedBox(height: 14),
      ],
    );
  }
}

class _AhraiTohnitBody extends ConsumerWidget {
  const _AhraiTohnitBody();

  @override
  Widget build(BuildContext context, ref) {
    final ahraiTohnit = ref.watch(ahraiHomeControllerProvider).valueOrNull ??
        const AhraiHomeDto();

    return Column(
      children: [
        DoughnutChartsWidget(
          callsGreen: ahraiTohnit.greenVisitCalls,
          callsOrange: ahraiTohnit.orangeVisitCalls,
          callsRed: ahraiTohnit.redVisitCalls,
          meeetingsGreen: ahraiTohnit.greenVisitMeetings,
          meeetingsOrange: ahraiTohnit.orangeVisitMeetings,
          meeetingsRed: ahraiTohnit.redVisitMeetings,
        ),
        PerformanceWidget(
          title: 'תפקוד מלווים',
          data: ahraiTohnit.melaveScore,
          onTap: () => const PersonaPerformanceRouteData(
            title: 'סטטוס חניכים',
            subtitle: 'מלווים מכלל המוסדות',
          ).push(context),
        ),
        PerformanceWidget(
          title: 'תפקוד רכזים',
          data: ahraiTohnit.rakazimScore,
          onTap: () => const PersonaPerformanceRouteData(
            title: 'תפקוד רכזים',
            subtitle: 'מלווים מכלל המוסדות',
          ).push(context),
        ),
        PerformanceWidget(
          title: 'תפקוד רכזי אשכול',
          data: ahraiTohnit.eshkolScore,
          onTap: () => const PersonaPerformanceRouteData(
            title: 'תפקוד רכזים',
            subtitle: 'מלווים מכלל המוסדות',
          ).push(context),
        ),
        const _ForgottenApprentices(),
      ],
    );
  }
}

class _ForgottenApprentices extends ConsumerWidget {
  const _ForgottenApprentices();

  @override
  Widget build(BuildContext context, ref) {
    final forgottenApprentices = ref.watch(getForgottenApprenticesProvider);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: DecoratedBox(
        decoration: Consts.defaultBoxDecorationWithShadow,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: Consts.defaultBorderRadius24,
            onTap: () => const ForgottenApprenticesRouteData().push(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'חניכים נשכחים',
                        style: TextStyles.s18w400cGray1,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'לא נוצר קשר מעל 100 יום',
                        style: TextStyles.s14w400cGrey4,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        (forgottenApprentices.valueOrNull?.total ?? 0)
                            .toString(),
                        style: TextStyles.s18w600cBlue2,
                      ),
                      const SizedBox(height: 4),
                      const Text('חניכים', style: TextStyles.s12w400cGrey6),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
