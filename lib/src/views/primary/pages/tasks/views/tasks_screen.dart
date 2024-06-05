import 'package:collection/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/functions/launch_url.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/controller/tasks_controller.dart';
import 'package:hadar_program/src/views/widgets/appbars/search_appbar.dart';
import 'package:hadar_program/src/views/widgets/cards/task_card.dart';
import 'package:hadar_program/src/views/widgets/states/empty_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TasksScreen extends HookConsumerWidget {
  const TasksScreen({super.key});

  static const path = '/tasks';

  void _selectTask({
    required ValueNotifier<List<TaskDto>> selectedTasks,
    required TaskDto e,
  }) {
    if (selectedTasks.value.contains(e)) {
      selectedTasks.value = [
        ...selectedTasks.value.where((element) => element != e),
      ];
    } else {
      selectedTasks.value = [...selectedTasks.value, e];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authServiceProvider);

    if (auth.isLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    final tabs = switch (auth.value?.role) {
      UserRole.ahraiTohnit => _programDirectorTabs,
      _ => _mentorTabs,
    };
    final tabController = useTabController(initialLength: tabs.length);
    useListenable(tabController);

    final isSearchOpen = useState(false);
    final searchController = useTextEditingController();
    useListenable(searchController);

    final tasks = ref.watch(tasksControllerProvider).valueOrNull ?? [];
    final apprentices = ref.watch(personasControllerProvider).valueOrNull ?? [];
    final filteredTasks = tasks.where(
      (element) => apprentices
          .firstWhere(
            (e) => element.subject.contains(e.id),
            orElse: () => const PersonaDto(),
          )
          .fullName
          .toLowerCase()
          .contains(
            searchController.text.toLowerCase().trim(),
          ),
    );

    final taskLists = tabs
        .map((tab) => filteredTasks.where((task) => tab.filter(task)))
        .toList();

    final selectedTasks = useState(<TaskDto>[]);
    // Reset selection, on tab or page change:
    tabController.addListener(() => selectedTasks.value = []);
    final goRouter = ref.watch(goRouterServiceProvider);
    if (goRouter.routeInformationProvider.value.uri.path != TasksScreen.path) {
      selectedTasks.value = [];
    }

    final selectedApprentices = apprentices
        .where(
          (element) => selectedTasks.value
              .map((e) => e.subject)
              .expand((element) => element)
              .contains(element.id),
        )
        .toList();

    ReportNewRouteData routeToReport() {
      final eventType = switch (selectedTasks.value.firstOrNull?.event) {
        Event.call => Event.call.enumName,
        Event.callParents || Event.meetingParents => Event.callParents.enumName,
        _ => Event.other.enumName,
      };
      return ReportNewRouteData(
        initRecipients: selectedApprentices.map((e) => e.id).toList(),
        eventType: eventType,
        taskIds: selectedTasks.value.map((e) => e.id).toList(),
      );
    }

    return Scaffold(
      appBar: SearchAppBar(
        controller: searchController,
        isSearchOpen: isSearchOpen,
        title: const Text('משימות לביצוע'),
        actions: [
          if (selectedTasks.value.isEmpty)
            IconButton(
              onPressed: () => isSearchOpen.value = true,
              icon: const Icon(FluentIcons.search_24_regular),
            ),
          if (selectedApprentices.length == 1)
            Builder(
              builder: (context) {
                final selectedTask = selectedTasks.value.first;
                final apprentice = selectedApprentices.first;
                return PopupMenuButton(
                  icon: const Icon(FluentIcons.more_vertical_24_regular),
                  itemBuilder: (context) => [
                    if (selectedTask.event.isCall) ...[
                      PopupMenuItem(
                        child: const Text('להתקשר'),
                        onTap: () => launchCall(phone: apprentice.phone),
                      ),
                      PopupMenuItem(
                        child: const Text('שליחת וואטסאפ'),
                        onTap: () => launchWhatsapp(
                          phone: apprentice.phone,
                        ),
                      ),
                      PopupMenuItem(
                        child: const Text('שליחת SMS'),
                        onTap: () => launchSms(phone: [apprentice.phone]),
                      ),
                    ],
                    if (selectedTask.event.isParents) ...[
                      if (apprentice.motherPhone != null)
                        PopupMenuItem(
                          onTap: () =>
                              launchCall(phone: apprentice.motherPhone),
                          child: const Text('להתקשר לאמא'),
                        ),
                      if (apprentice.fatherPhone != null)
                        PopupMenuItem(
                          onTap: () =>
                              launchCall(phone: apprentice.fatherPhone),
                          child: const Text('להתקשר לאבא'),
                        ),
                    ],
                    PopupMenuItem(
                      child: const Text('דיווח'),
                      onTap: () => routeToReport().push(context),
                    ),
                    PopupMenuItem(
                      child: const Text('פרופיל אישי'),
                      onTap: () => PersonaDetailsRouteData(
                        id: apprentice.id,
                      ).push(context),
                    ),
                  ],
                );
              },
            )
          else if (selectedTasks.value.length > 1)
            IconButton(
              onPressed: () => routeToReport().push(context),
              icon: const Icon(
                FluentIcons.clipboard_task_24_regular,
              ),
            ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: tabs
              .mapIndexed(
                (index, tab) => Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tab.title,
                        style: TextStyles.s14w400cGrey2,
                      ),
                      if (taskLists[index].isNotEmpty) ...[
                        const SizedBox(width: 4),
                        const CircleAvatar(
                          radius: 3,
                          backgroundColor: AppColors.blue03,
                        ),
                      ],
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
      floatingActionButton: tabController.index == 0
          ? FloatingActionButton(
              onPressed: () => const NewTaskRouteData().push(context),
              heroTag: UniqueKey(),
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
        children: tabs
            .mapIndexed(
              (tabIndex, tab) => RefreshIndicator.adaptive(
                onRefresh: () => ref.refresh(tasksControllerProvider.future),
                child: taskLists[tabIndex].isEmpty
                    ? searchController.text.isNotEmpty
                        ? Text(
                            'לא נמצאו תוצאות עבור ${searchController.text}',
                          )
                        : EmptyState(
                            image: tab.emptyStateImage,
                            topText: tab.emptyStateText == null
                                ? 'איזה יופי!'
                                : null,
                            bottomText:
                                tab.emptyStateText ?? 'אין ${tab.title} לבצע',
                          )
                    : Opacity(
                        opacity:
                            (auth.value?.role.isProgramDirector ?? false) &&
                                    tabIndex == tabs.length
                                ? .6
                                : 1,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: taskLists[tabIndex].length,
                          itemBuilder: (context, index) {
                            final task = taskLists[tabIndex].elementAt(index);
                            return TaskCard(
                              task: task,
                              isSelected: selectedTasks.value.contains(task),
                              onTap: selectedTasks.value.isEmpty
                                  ? task.subject.isEmpty
                                      ? () => TaskDetailsRouteData(id: task.id)
                                          .push(context)
                                      : () => PersonaDetailsRouteData(
                                            id: task.subject.first,
                                          ).push(context)
                                  : () => _selectTask(
                                        selectedTasks: selectedTasks,
                                        e: task,
                                      ),
                              onLongPress: () => _selectTask(
                                selectedTasks: selectedTasks,
                                e: task,
                              ),
                              onCheckboxTap: tab.checkboxTasks
                                  ? (_) => ref
                                      .read(tasksControllerProvider.notifier)
                                      .edit(
                                        task.copyWith(
                                          status: task.status == TaskStatus.done
                                              ? TaskStatus.todo
                                              : TaskStatus.done,
                                        ),
                                      )
                                  : null,
                            );
                          },
                        ),
                      ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TaskTab {
  final String title;
  final bool Function(TaskDto) filter;
  final SvgPicture emptyStateImage;
  final String? emptyStateText;
  final bool checkboxTasks;

  _TaskTab({
    required this.title,
    required this.filter,
    emptyStateImage,
    this.emptyStateText,
    this.checkboxTasks = false,
  }) : emptyStateImage = emptyStateImage ?? Assets.illustrations.clap.svg();
}

final _programDirectorTabs = [
  _TaskTab(
    title: 'לביצוע',
    filter: (task) => task.status == TaskStatus.todo,
    emptyStateImage: Assets.illustrations.thumbsUpFullBody.svg(height: 400),
    emptyStateText: 'אין משימות לביצוע',
    checkboxTasks: true,
  ),
  _TaskTab(
    title: 'הושלמו',
    filter: (task) => task.status == TaskStatus.done,
    emptyStateImage: Assets.illustrations.thinking.svg(height: 400),
    emptyStateText: 'אין משימות שהושלמו',
    checkboxTasks: true,
  ),
];

final _mentorTabs = [
  _TaskTab(
    title: 'שיחות',
    filter: (task) => task.event.isCall,
  ),
  _TaskTab(
    title: 'מפגשים',
    filter: (task) => task.event.isMeeting,
  ),
  _TaskTab(
    title: 'שיחות להורים',
    filter: (task) => task.event.isParents,
  ),
];
