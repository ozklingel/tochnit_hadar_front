import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/ahrai_home_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/ahrai_home.dto.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/apprentices_status_screen.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/side_menu_drawer.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/doughnut_charts_widget.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/home_header.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/performance_widgets.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/upcoming_events_widget.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/upcoming_tasks_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // final apprentices =
    //     ref.watch(apprenticesControllerProvider).valueOrNull ?? [];

    final user = ref.watch(userServiceProvider).valueOrNull ?? const UserDto();

    // Logger().d(user);

    return Scaffold(
      drawer: const SideMenuDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Assets.images.logo.image(
          height: 48,
        ),
        actions: [
          IconButton(
            onPressed: () => const NotificationRouteData().go(context),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HomeHeader(),
            const SizedBox(height: 44),
            if (user.role == UserRole.melave)
              const _MelaveBody()
            else if (user.role == UserRole.ahraiTohnit)
              const _AhraiTohnitBody()
            else
              const Text('BAD USER ROLE'),
          ],
        ),
      ),
    );
  }
}

class _MelaveBody extends StatelessWidget {
  const _MelaveBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        UpcomingEventsWidget(),
        SizedBox(height: 24),
        UpcomingTasksWidget(),
        SizedBox(height: 14),
      ],
    );
  }
}

class _AhraiTohnitBody extends ConsumerWidget {
  const _AhraiTohnitBody({super.key});

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
        MelavimPerformanceWidget(
          data: ahraiTohnit.melaveScore.first.isEmpty
              ? [(0, 0)]
              : ahraiTohnit.melaveScore.map((e) => (e[0], e[1])).toList(),
        ),
        RakazimPerformanceWidget(
          data: ahraiTohnit.rakazimScore.first.isEmpty
              ? [(0, 0)]
              : ahraiTohnit.rakazimScore.map((e) => (e[0], e[1])).toList(),
        ),
        RakazeiEshkolPerformanceWidget(
          data: ahraiTohnit.eshkolScore.first.isEmpty
              ? [(0, 0)]
              : ahraiTohnit.eshkolScore.map((e) => (e[0], e[1])).toList(),
        ),
        const _ForgottenApprentices(),
      ],
    );
  }
}

class _ForgottenApprentices extends StatelessWidget {
  const _ForgottenApprentices({
    super.key,
  });

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
