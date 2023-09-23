import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/controller/tasks_controller.dart';
import 'package:hadar_program/src/views/widgets/cards/task_card.dart';
import 'package:hadar_program/src/views/widgets/states/empty_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TasksScreen extends HookConsumerWidget {
  const TasksScreen({super.key});

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
            selectedItems: selectedCalls,
          ),
        )
        .toList();

    final meetings = filteredList
        .where((element) => element.reportEventType == TaskType.meeting)
        .map<Widget>(
          (e) => TaskCard(
            task: e,
            selectedItems: selectedMeetings,
          ),
        )
        .toList();

    final parents = filteredList
        .where((element) => element.reportEventType == TaskType.parents)
        .map<Widget>(
          (e) => TaskCard(
            task: e,
            selectedItems: selectedParents,
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AnimatedSwitcher(
          duration: Consts.kDefaultDurationM,
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
