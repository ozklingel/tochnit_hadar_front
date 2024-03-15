import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_controller.g.dart';

@Riverpod(dependencies: [])
class DashboardController extends _$DashboardController {
  @override
  int build(String? currentRoute) {
    if (currentRoute == const ReportsRouteData().location) {
      return 0;
    }

    if (currentRoute == const ApprenticesOrUsersRouteData().location) {
      return 1;
    }

    if (currentRoute == const HomeRouteData().location) {
      return 2;
    }

    if (currentRoute == const TasksRouteData().location) {
      return 3;
    }

    if (currentRoute == const MessagesRouteData().location) {
      return 4;
    }

    return 2;
  }

  // void setPosition({
  //   required BuildContext context,
  //   required int value,
  // }) {
  //   switch (value) {
  //     case 0:
  //       const ReportsRouteData().go(context);
  //       break;
  //     case 1:
  //       const ApprenticesRouteData().go(context);
  //       break;
  //     case 2:
  //       const HomeRouteData().go(context);
  //       break;
  //     case 3:
  //       const TasksRouteData().go(context);
  //       break;
  //     case 4:
  //       const MessagesRouteData().go(context);
  //       break;
  //     default:
  //       const HomeRouteData().go(context);
  //       break;
  //   }
  // }
}
