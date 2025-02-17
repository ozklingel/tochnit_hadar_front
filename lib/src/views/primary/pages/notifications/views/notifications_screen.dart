import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/notifications/views/widgets/notification_widget.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/controller/tasks_controller.dart';
import 'package:hadar_program/src/views/widgets/states/empty_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationScreen extends HookConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);
    final msgsController = ref.watch(tasksControllerProvider);
    // final isSearchOpen = useState(false);
    final searchController = useTextEditingController();

    useListenable(searchController);

    // Logger().d(msgsController.valueOrNull?.length);

    if (auth.isLoading) {
      return const CircularProgressIndicator.adaptive();
    }

    switch (auth.valueOrNull?.role) {
      case UserRole.melave:
      default:
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () =>
                    const NotificationSettingRouteData().push(context),
                icon: const Icon(
                  FluentIcons.more_vertical_24_regular,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
            ],
            leading: GestureDetector(
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onTap: () => const HomeRouteData().go(context),
            ),
            title: const Text(" התראות"),
          ),
          body: RefreshIndicator.adaptive(
            onRefresh: () => ref.refresh(tasksControllerProvider.future),
            child: msgsController.unwrapPrevious().when(
                  error: (error, s) => CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        child: Center(
                          child: Text(error.toString()),
                        ),
                      ),
                    ],
                  ),
                  loading: () => _SearchResultsBody(
                    isLoading: true,
                    messages: List.generate(
                      10,
                      (index) => TaskDto(
                        title: 'titletitletitletitle',
                        dateTime: DateTime.now().toIso8601String(),
                      ),
                    ),
                  ),
                  data: (messages) => _SearchResultsBody(
                    isLoading: false,
                    messages: messages
                        .where(
                          (element) =>
                              element.event.name
                                  .toLowerCase()
                                  .contains(searchController.text) ||
                              element.details
                                  .toLowerCase()
                                  .contains(searchController.text),
                        )
                        .toList(),
                  ),
                ),
          ),
        );
    }
  }
}

class _SearchResultsBody extends StatelessWidget {
  const _SearchResultsBody({
    required this.messages,
    required this.isLoading,
  });

  final List<TaskDto> messages;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return EmptyState(
        image: Assets.illustrations.pointDown.svg(),
        topText: 'אין  התראות',
        bottomText: 'התראות  שיוצרו, יופיעו כאן',
      );
    }

    return ListView(
      children: messages
          .map(
            (e) => Skeletonizer(
              enabled: isLoading,
              child: NotificationWidget(task: e),
            ),
          )
          .toList(),
    );
  }
}
