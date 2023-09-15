import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/apprentice_screen.dart';
import 'package:hadar_program/src/views/primary/pages/homePage/home_screen.dart';
import 'package:hadar_program/src/views/primary/pages/messages/messages_screen.dart';
import 'package:hadar_program/src/views/primary/pages/report/report_screen.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/tasks_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardBodyView extends HookConsumerWidget {
  const DashboardBodyView({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context, ref) {
    useEffect(
      () {
        void listener() {
          // ref.read(goRouterProvider).go(
          //       tabController.index == 0
          //           ? Routes.tasks
          //           : tabController.index == 1
          //               ? Routes.reports
          //               : tabController.index == 2
          //                   ? Routes.home
          //                   : tabController.index == 3
          //                       ? Routes.messages
          //                       : Routes.apprentice,
          //     );
        }

        tabController.addListener(listener);
        return () => tabController.removeListener(listener);
      },
      [tabController],
    );

    return TabBarView(
      controller: tabController,
      children: const [
        TasksScreen(),
        ReportScreen(),
        HomeScreen(),
        MessagesScreen(),
        ApprenticeScreen(),
      ],
    );
  }
}
