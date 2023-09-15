import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/services/routing/named_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_controller.g.dart';

@Riverpod(dependencies: [goRouter])
class DashboardController extends _$DashboardController {
  @override
  int build(String? currentRoute) {
    switch (currentRoute) {
      case Routes.reports:
        return 0;
      case Routes.apprentice:
        return 1;
      case Routes.home:
        return 2;
      case Routes.tasks:
        return 3;
      case Routes.messages:
        return 4;
      default:
        return 2;
    }
  }

  void setPosition(int value) {
    final goRouter = ref.read(goRouterProvider);
    switch (value) {
      case 0:
        goRouter.go(Routes.reports);
        break;
      case 1:
        goRouter.go(Routes.apprentice);
        break;
      case 2:
        goRouter.go(Routes.home);
        break;
      case 3:
        goRouter.go(Routes.tasks);
        break;
      case 4:
        goRouter.go(Routes.messages);
        break;
      default:
        goRouter.go(Routes.home);
        break;
    }
  }
}
