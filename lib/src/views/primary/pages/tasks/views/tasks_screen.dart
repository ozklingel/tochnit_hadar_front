import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/controller/tasks_controller.dart';
import 'package:hadar_program/src/views/widgets/cards/task_card.dart';
import 'package:hadar_program/src/views/widgets/states/empty_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);

    if (user.valueOrNull?.role == UserRole.melave) {
      return const _MelaveTasksBody();
    }

    if (user.valueOrNull?.role == UserRole.ahraiTohnit) {
      return const _AhraiTohnitTasksBody();
    }

    return const Center(
      child: Text('BAD ROLE'),
    );
  }
}

class _AhraiTohnitTasksBody extends HookConsumerWidget {
  const _AhraiTohnitTasksBody({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final tasks = ref.watch(tasksControllerProvider).valueOrNull ?? [];
    final tabController = useTabController(initialLength: 2);
    useListenable(tabController);
    final incompleteTasks = tasks.where((element) => !element.isComplete);
    final completeTasks = tasks.where((element) => element.isComplete);

    return Scaffold(
      appBar: AppBar(
        title: const Text('משימות לביצוע'),
        actions: [
          IconButton(
            onPressed: () => Toaster.unimplemented(),
            icon: const Icon(FluentIcons.search_24_regular),
          ),
          const SizedBox(width: 6),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'לביצוע'),
            Tab(text: 'הושלמו'),
          ],
        ),
      ),
      floatingActionButton: tabController.index == 0
          ? FloatingActionButton(
              onPressed: () => const NewTaskRouteData().push(context),
              shape: const CircleBorder(),
              backgroundColor: AppColors.blue02,
              child: const Icon(
                FluentIcons.add_24_regular,
                color: Colors.white,
              ),
            )
          : null,
      body: TabBarView(
        controller: tabController,
        children: [
          ListView(
            children: incompleteTasks
                .map(
                  (e) => CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: false,
                    onChanged: (value) =>
                        TaskDetailsRouteData(id: e.id).push(context),
                    title: Text(
                      e.title,
                      style: TextStyles.s18w500cGray1,
                    ),
                    subtitle: Text(
                      e.details,
                      style: TextStyles.s16w400cGrey2,
                    ),
                    secondary: const DefaultTextStyle(
                      style: TextStyles.s12w400cGrey5fRoboto,
                      child: Column(
                        children: [
                          Text('20/09/23'),
                          Text('18:30'),
                          Icon(
                            FluentIcons.arrow_rotate_clockwise_24_regular,
                            size: 16,
                            color: AppColors.gray5,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          if (completeTasks.isEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.vectors.noCompleteTasks.svg(
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
                const Text('אין משימות שהושלמו'),
              ],
            )
          else
            ListView(
              children: completeTasks
                  .map(
                    (e) => Opacity(
                      opacity: .6,
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        value: true,
                        onChanged: (value) => TaskDetailsRouteData(
                          id: Consts.mockTasksGuids.first,
                        ).push(context),
                        title: const Text(
                          'סבב מוסד',
                          style: TextStyles.s18w500cGray1,
                        ),
                        subtitle: const Text(
                          'בני דוד מכינת עלי',
                          style: TextStyles.s16w400cGrey2,
                        ),
                        secondary: const DefaultTextStyle(
                          style: TextStyles.s12w400cGrey5fRoboto,
                          child: Column(
                            children: [
                              Text('20/09/23'),
                              Text('18:30'),
                              Icon(
                                FluentIcons.arrow_rotate_clockwise_24_regular,
                                size: 16,
                                color: AppColors.gray5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _MelaveTasksBody extends HookConsumerWidget {
  const _MelaveTasksBody({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(tasksControllerProvider).valueOrNull ?? [];
    final tabController = useTabController(initialLength: 3);
    final isSearchOpen = useState(false);
    final searchController = useTextEditingController();
    final selectedCalls = useState(<TaskDto>[]);
    final selectedMeetings = useState(<TaskDto>[]);
    final selectedParents = useState(<TaskDto>[]);
    useListenable(searchController);
    useListenable(tabController);

    final filteredList = controller.where(
      (element) => element.apprentice.fullName.toLowerCase().contains(
            searchController.text.toLowerCase().trim(),
          ),
    );

    final calls = filteredList
        .where((element) => element.reportEventType == TaskType.call)
        .map<Widget>(
          (e) => TaskCard(
            task: e,
            isSelected: selectedCalls.value.contains(e),
            onTap: () => ApprenticeDetailsRouteData(id: e.apprentice.id),
            onLongPress: () {
              if (selectedCalls.value.contains(e)) {
                final newList = selectedCalls.value;
                newList.remove(e);
                selectedCalls.value = [...newList];
              } else {
                selectedCalls.value = [...selectedCalls.value, e];
              }
            },
          ),
        )
        .toList();

    final meetings = filteredList
        .where((element) => element.reportEventType == TaskType.meeting)
        .map<Widget>(
          (e) => TaskCard(
            task: e,
            isSelected: selectedMeetings.value.contains(e),
            onTap: () => ApprenticeDetailsRouteData(id: e.apprentice.id),
            onLongPress: () {
              if (selectedMeetings.value.contains(e)) {
                final newList = selectedMeetings.value;
                newList.remove(e);
                selectedMeetings.value = [...newList];
              } else {
                selectedMeetings.value = [
                  ...selectedMeetings.value,
                  e,
                ];
              }
            },
          ),
        )
        .toList();

    final parents = filteredList
        .where((element) => element.reportEventType == TaskType.parents)
        .map<Widget>(
          (e) => TaskCard(
            task: e,
            isSelected: selectedParents.value.contains(e),
            onTap: () => ApprenticeDetailsRouteData(id: e.apprentice.id),
            onLongPress: () {
              if (selectedParents.value.contains(e)) {
                final newList = selectedParents.value;
                newList.remove(e);
                selectedParents.value = [...newList];
              } else {
                selectedParents.value = [...selectedParents.value, e];
              }
            },
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AnimatedSwitcher(
          duration: Consts.defaultDurationM,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              child: child,
            ),
          ),
          child: isSearchOpen.value
              ? SearchBar(
                  controller: searchController,
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(AppColors.blue07),
                  hintText: 'חיפוש...',
                  leading: IconButton(
                    onPressed: () => isSearchOpen.value = false,
                    icon: const Icon(
                      FluentIcons.arrow_left_24_regular,
                      color: AppColors.gray2,
                    ),
                  ),
                )
              : const Text('משימות לביצוע'),
        ),
        actions: isSearchOpen.value
            ? []
            : [
                if ((tabController.index == 0 &&
                        selectedCalls.value.length < 2) ||
                    (tabController.index == 1 &&
                        selectedMeetings.value.length < 2) ||
                    (tabController.index == 2 &&
                        selectedParents.value.length < 2))
                  IconButton(
                    onPressed: () => isSearchOpen.value = true,
                    icon: const Icon(FluentIcons.search_24_regular),
                  ),
                if (tabController.index == 2 &&
                    selectedParents.value.length == 1)
                  PopupMenuButton(
                    icon: const Icon(FluentIcons.more_vertical_24_regular),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('להתקשר לאמא'),
                        onTap: () => Toaster.unimplemented(),
                      ),
                      PopupMenuItem(
                        child: const Text('להתקשר לאבא'),
                        onTap: () => Toaster.unimplemented(),
                      ),
                      PopupMenuItem(
                        child: const Text('דיווח'),
                        onTap: () => Toaster.unimplemented(),
                      ),
                      PopupMenuItem(
                        child: const Text('פרופיל אישי'),
                        onTap: () => Toaster.unimplemented(),
                      ),
                    ],
                  ),
                if (tabController.index == 0 && selectedCalls.value.length == 1)
                  PopupMenuButton(
                    icon: const Icon(FluentIcons.more_vertical_24_regular),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('להתקשר'),
                        onTap: () => Toaster.unimplemented(),
                      ),
                      PopupMenuItem(
                        child: const Text('שליחת וואטסאפ'),
                        onTap: () => Toaster.unimplemented(),
                      ),
                      PopupMenuItem(
                        child: const Text('שליחת SMS'),
                        onTap: () => Toaster.unimplemented(),
                      ),
                      PopupMenuItem(
                        child: const Text('דיווח'),
                        onTap: () => Toaster.unimplemented(),
                      ),
                      PopupMenuItem(
                        child: const Text('פרופיל אישי'),
                        onTap: () => Toaster.unimplemented(),
                      ),
                    ],
                  )
                else if ((tabController.index == 0 &&
                        selectedCalls.value.length > 1) ||
                    (tabController.index == 1 &&
                        selectedMeetings.value.length > 1) ||
                    (tabController.index == 2 &&
                        selectedParents.value.length > 1))
                  IconButton(
                    onPressed: () => Toaster.unimplemented(),
                    icon: const Icon(
                      FluentIcons.clipboard_24_regular,
                    ),
                  ),
                const SizedBox(width: 8),
              ],
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'שיחות'),
            Tab(text: 'מפגשים'),
            Tab(text: 'הורים'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TabBarView(
          controller: tabController,
          children: [
            if (tabController.index == 0 &&
                searchController.text.isNotEmpty &&
                calls.isEmpty)
              Text('לא נמצאו תוצאות עבור ${searchController.text}')
            else if (calls.isEmpty)
              EmptyState(
                image: Assets.images.noTasks.svg(),
                topText: 'איזה יופי!',
                bottomText: 'אין שיחות לבצע',
              )
            else
              ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: calls.length,
                itemBuilder: (context, index) => calls[index],
              ),
            if (tabController.index == 0 &&
                searchController.text.isNotEmpty &&
                meetings.isEmpty)
              Text('לא נמצאו תוצאות עבור ${searchController.text}')
            else if (meetings.isEmpty)
              EmptyState(
                image: Assets.images.noTasks.svg(),
                topText: 'איזה יופי!',
                bottomText: 'אין מפגשים לבצע',
              )
            else
              ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: meetings.length,
                itemBuilder: (context, index) => meetings[index],
              ),
            if (tabController.index == 0 &&
                searchController.text.isNotEmpty &&
                parents.isEmpty)
              Text('לא נמצאו תוצאות עבור ${searchController.text}')
            else if (parents.isEmpty)
              EmptyState(
                image: Assets.images.noTasks.svg(),
                topText: 'איזה יופי!',
                bottomText: 'אין הורים לבצע',
              )
            else
              ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: parents.length,
                itemBuilder: (context, index) => parents[index],
              ),
          ]
              .map(
                (e) => RefreshIndicator.adaptive(
                  onRefresh: () => ref.refresh(tasksControllerProvider.future),
                  child: e,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
