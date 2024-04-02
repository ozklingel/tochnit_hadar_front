import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/ahrai_home_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/notifications_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/ahrai_home.dto.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/apprentices_status_screen.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/performance_status_screen.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/side_menu_drawer.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/doughnut_charts_widget.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/home_header.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/performance_widget.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/upcoming_events_widget.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/upcoming_tasks_widget.dart';
import 'package:hadar_program/src/views/widgets/badges/unread_count_badge_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // final apprentices =
    //     ref.watch(apprenticesControllerProvider).valueOrNull ?? [];

    final auth = ref.watch(authServiceProvider);
    final user = auth.valueOrNull ?? const AuthDto();

    // Logger().d(user);

    if (auth.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return Scaffold(
      drawer: const SideMenuDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Assets.images.logo.image(
          height: 42,
        ),
        actions: [
          ref.watch(notificationsControllerProvider).when(
                loading: () => UnreadCounterBadgeWidget(
                  isLoading: true,
                  child: IconButton(
                    onPressed: () =>
                        {const NotificationRouteData().go(context)},
                    icon: const Icon(Icons.notifications_none),
                  ),
                ),
                error: (error, stack) => IconButton(
                  onPressed: () => const NotificationRouteData().go(context),
                  icon: const Icon(Icons.notifications_none),
                ),
                data: (notifications) => UnreadCounterBadgeWidget(
                  count: notifications.length,
                  child: IconButton(
                    onPressed: () => const NotificationRouteData().go(context),
                    icon: const Icon(Icons.notifications_none),
                  ),
                ),
              ),
        ],
      ),
      body: SingleChildScrollView(
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
          callsGreen: ahraiTohnit.greenvisitcalls,
          callsOrange: ahraiTohnit.orangevisitcalls,
          callsRed: ahraiTohnit.redvisitcalls,
          meeetingsGreen: ahraiTohnit.greenvisitmeetings,
          meeetingsOrange: ahraiTohnit.orangevisitmeetings,
          meeetingsRed: ahraiTohnit.redvisitmeetings,
        ),
        PerformanceWidget(
          title: 'תפקוד מלווים',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PerformanceStatusScreen(
                title: 'תפקוד מלווים',
              ),
            ),
          ),
          data: ahraiTohnit.melaveScore,
        ),
        PerformanceWidget(
          title: 'תפקוד רכזים',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PerformanceStatusScreen(
                title: 'תפקוד רכזים',
              ),
            ),
          ),
          data: ahraiTohnit.rakazimScore,
        ),
        PerformanceWidget(
          title: 'תפקוד רכזי אשכול',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PerformanceStatusScreen(
                title: 'תפקוד רכזים',
              ),
            ),
          ),
          data: ahraiTohnit.eshkolScore,
        ),
        const _ForgottenApprentices(),
      ],
    );
  }
}

class _ForgottenApprentices extends StatelessWidget {
  const _ForgottenApprentices();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: DecoratedBox(
        decoration: Consts.defaultBoxDecorationWithShadow,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: Consts.borderRadius24,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ApprenticesStatusScreen(
                  isExtended: false,
                  title: 'חניכים נשכחים',
                  initIndex: 0,
                ),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                children: [
                  Column(
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
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        '12',
                        style: TextStyles.s18w600cBlue2,
                      ),
                      SizedBox(height: 4),
                      Text('חניכים', style: TextStyles.s12w400cGrey6),
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
