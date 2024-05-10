import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  static const path = '/tasks';

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);

    if (auth.isLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    if (auth.valueOrNull?.role == UserRole.melave) {
      return const _MelaveTasksBody();
    }

    if (auth.valueOrNull?.role == UserRole.ahraiTohnit) {
      return const _AhraiTohnitTasksBody();
    }

    return const Center(
      child: Text('BAD ROLE'),
    );
  }
}

class _AhraiTohnitTasksBody extends HookConsumerWidget {
  const _AhraiTohnitTasksBody();

  @override
  Widget build(BuildContext context, ref) {
    final tasks = ref.watch(tasksControllerProvider).valueOrNull ?? [];
    final tabController = useTabController(initialLength: 2);
    useListenable(tabController);
    final isSearchOpen = useState(false);
    final searchController = useTextEditingController();
    final incompleteTasks =
        tasks.where((element) => element.status == TaskStatus.todo);
    final completeTasks =
        tasks.where((element) => element.status == TaskStatus.done);

    return Scaffold(
      appBar: SearchAppBar(
        controller: searchController,
        isSearchOpen: isSearchOpen,
        title: const Text('משימות לביצוע'),
        actions: [
          IconButton(
            onPressed: () => isSearchOpen.value = true,
            icon: const Icon(FluentIcons.search_24_regular),
          ),
          const SizedBox(width: 6),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'לביצוע',
                    style: TextStyles.s14w400cGrey2,
                  ),
                  if (incompleteTasks.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    const CircleAvatar(
                      radius: 3,
                      backgroundColor: AppColors.blue03,
                    ),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'הושלמו',
                    style: TextStyles.s14w400cGrey2,
                  ),
                  if (completeTasks.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    const CircleAvatar(
                      radius: 3,
                      backgroundColor: AppColors.blue03,
                    ),
                  ],
                ],
              ),
            ),
          ],
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
        children: [
          ListView(
            children: incompleteTasks
                .map(
                  (e) => ListTile(
                    onTap: () => TaskDetailsRouteData(id: e.id).push(context),
                    leading: Checkbox(
                      value: false,
                      onChanged: (value) =>
                          ref.read(tasksControllerProvider.notifier).edit(
                                e.copyWith(
                                  status: TaskStatus.done,
                                ),
                              ),
                    ),
                    title: Text(
                      e.title,
                      style: TextStyles.s18w500cGray1,
                    ),
                    subtitle: Text(
                      e.details,
                      style: TextStyles.s16w400cGrey2,
                    ),
                    trailing: const DefaultTextStyle(
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
                      child: ListTile(
                        onTap: () =>
                            TaskDetailsRouteData(id: e.id).push(context),
                        leading: Checkbox(
                          value: true,
                          onChanged: (value) {
                            ref.read(tasksControllerProvider.notifier).edit(
                                  e.copyWith(
                                    status: TaskStatus.todo,
                                  ),
                                );
                          },
                        ),
                        title: Text(
                          e.title,
                          style: TextStyles.s18w500cGray1,
                        ),
                        subtitle: Text(
                          e.details,
                          style: TextStyles.s16w400cGrey2,
                        ),
                        trailing: const DefaultTextStyle(
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
  const _MelaveTasksBody();

  @override
  Widget build(BuildContext context, ref) {
    final tasks = ref.watch(tasksControllerProvider).valueOrNull ?? [];
    final apprentices = ref.watch(personasControllerProvider).valueOrNull ?? [];
    final tabController = useTabController(initialLength: 3);
    final isSearchOpen = useState(false);
    final searchController = useTextEditingController();
    final selectedCalls = useState(<TaskDto>[]);
    final selectedMeetings = useState(<TaskDto>[]);
    final selectedParents = useState(<TaskDto>[]);
    useListenable(searchController);
    useListenable(tabController);

    final goRouter = ref.watch(goRouterServiceProvider);
    if (goRouter.routeInformationProvider.value.uri.path != TasksScreen.path) {
      selectedCalls.value = [];
      selectedMeetings.value = [];
      selectedParents.value = [];
    }

    List<TaskDto> viewedSelectedTasks(int tabIndex) => switch (tabIndex) {
          0 => selectedCalls.value,
          1 => selectedMeetings.value,
          2 => selectedParents.value,
          _ => throw ArgumentError('bad index'),
        };

    ReportNewRouteData routeToReport(int tabIndex, List<String> recipients) {
      final eventType = switch (tabIndex) {
        0 => Event.call.enumName,
        2 => Event.callParents.enumName,
        _ => Event.other.enumName,
      };
      return ReportNewRouteData(
        initRecipients: recipients,
        eventType: eventType,
        taskIds: viewedSelectedTasks(tabIndex).map((e) => e.id).toList(),
      );
    }

    final filteredList = tasks.where(
      (element) => apprentices
          .singleWhere(
            (e) => element.subject.contains(e.id),
            orElse: () => const PersonaDto(),
          )
          .fullName
          .toLowerCase()
          .contains(
            searchController.text.toLowerCase().trim(),
          ),
    );

    final calls = filteredList
        .where((element) => element.event == TaskType.call)
        .map<Widget>(
          (e) => TaskCard(
            task: e,
            isSelected: selectedCalls.value.contains(e),
            onTap: selectedCalls.value.isEmpty
                ? e.subject.isEmpty
                    ? null
                    : () => PersonaDetailsRouteData(id: e.subject.first)
                        .push(context)
                : () => _selectTask(
                      selectedTasks: selectedCalls,
                      e: e,
                    ),
            onLongPress: () => _selectTask(
              selectedTasks: selectedCalls,
              e: e,
            ),
          ),
        )
        .toList();

    final meetings = filteredList
        .where(
          (element) => [
            TaskType.meeting,
            TaskType.meetingGroup,
          ].contains(element.event),
        )
        .map<Widget>(
          (e) => TaskCard(
            task: e,
            isSelected: selectedMeetings.value.contains(e),
            onTap: selectedMeetings.value.isEmpty
                ? e.subject.isEmpty
                    ? null
                    : () => PersonaDetailsRouteData(id: e.subject.first)
                        .push(context)
                : () => _selectTask(
                      selectedTasks: selectedMeetings,
                      e: e,
                    ),
            onLongPress: () => _selectTask(
              selectedTasks: selectedMeetings,
              e: e,
            ),
          ),
        )
        .toList();

    final parents = filteredList
        .where(
          (element) => [TaskType.meetingParents, TaskType.callParents]
              .contains(element.event),
        )
        .map<Widget>(
          (e) => TaskCard(
            task: e,
            isSelected: selectedParents.value.contains(e),
            onTap: selectedParents.value.isEmpty
                ? e.subject.isEmpty
                    ? null
                    : () => PersonaDetailsRouteData(id: e.subject.first)
                        .push(context)
                : () => _selectTask(
                      selectedTasks: selectedParents,
                      e: e,
                    ),
            onLongPress: () => _selectTask(
              selectedTasks: selectedParents,
              e: e,
            ),
          ),
        )
        .toList();

    return Scaffold(
      appBar: SearchAppBar(
        title: const Text('משימות לביצוע'),
        isSearchOpen: isSearchOpen,
        controller: searchController,
        actions: [
          if (viewedSelectedTasks(tabController.index).length < 2)
            IconButton(
              onPressed: () => isSearchOpen.value = true,
              icon: const Icon(FluentIcons.search_24_regular),
            ),
          if (tabController.index == 2 && selectedParents.value.length == 1)
            Builder(
              builder: (context) {
                final selectedApprentice = apprentices.singleWhere(
                  (element) =>
                      selectedParents.value.first.subject.contains(element.id),
                );

                final isEnabledMother = [
                  selectedApprentice.contact1Relationship,
                  selectedApprentice.contact2Relationship,
                  selectedApprentice.contact3Relationship,
                ].contains(Relationship.mother);

                final isEnabledFather = [
                  selectedApprentice.contact1Relationship,
                  selectedApprentice.contact2Relationship,
                  selectedApprentice.contact3Relationship,
                ].contains(Relationship.father);

                return PopupMenuButton(
                  icon: const Icon(FluentIcons.more_vertical_24_regular),
                  itemBuilder: (context) => [
                    if (isEnabledMother)
                      PopupMenuItem(
                        onTap: () {
                          if (selectedApprentice.contact1Relationship ==
                              Relationship.mother) {
                            launchCall(
                              phone: selectedApprentice.contact1Phone,
                            );
                          } else if (selectedApprentice.contact2Relationship ==
                              Relationship.mother) {
                            launchCall(
                              phone: selectedApprentice.contact2Phone,
                            );
                          } else if (selectedApprentice.contact3Relationship ==
                              Relationship.mother) {
                            launchCall(
                              phone: selectedApprentice.contact3Phone,
                            );
                          } else {
                            throw ArgumentError(
                              'none of the contacts fit mother',
                            );
                          }
                        },
                        enabled: isEnabledMother,
                        child: const Text('להתקשר לאמא'),
                      ),
                    if (isEnabledFather)
                      PopupMenuItem(
                        onTap: () {
                          if (selectedApprentice.contact1Relationship ==
                              Relationship.father) {
                            launchCall(
                              phone: selectedApprentice.contact1Phone,
                            );
                          } else if (selectedApprentice.contact2Relationship ==
                              Relationship.father) {
                            launchCall(
                              phone: selectedApprentice.contact2Phone,
                            );
                          } else if (selectedApprentice.contact3Relationship ==
                              Relationship.father) {
                            launchCall(
                              phone: selectedApprentice.contact3Phone,
                            );
                          } else {
                            throw ArgumentError(
                              'none of the contacts fit father',
                            );
                          }
                        },
                        enabled: isEnabledFather,
                        child: const Text('להתקשר לאבא'),
                      ),
                    PopupMenuItem(
                      child: const Text('דיווח'),
                      onTap: () => routeToReport(
                        tabController.index,
                        [selectedApprentice.id],
                      ).push(context),
                    ),
                    PopupMenuItem(
                      child: const Text('פרופיל אישי'),
                      onTap: () => PersonaDetailsRouteData(
                        id: selectedApprentice.id,
                      ).push(context),
                    ),
                  ],
                );
              },
            ),
          if (tabController.index == 0 && selectedCalls.value.length == 1)
            Builder(
              builder: (context) {
                final selectedPersona = apprentices.singleWhere(
                  (element) =>
                      selectedCalls.value.first.subject.contains(element.id),
                  orElse: () => const PersonaDto(),
                );

                return PopupMenuButton(
                  icon: const Icon(FluentIcons.more_vertical_24_regular),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('להתקשר'),
                      onTap: () => launchCall(phone: selectedPersona.phone),
                    ),
                    PopupMenuItem(
                      child: const Text('שליחת וואטסאפ'),
                      onTap: () => launchWhatsapp(phone: selectedPersona.phone),
                    ),
                    PopupMenuItem(
                      child: const Text('שליחת SMS'),
                      onTap: () => launchSms(phone: [selectedPersona.phone]),
                    ),
                    PopupMenuItem(
                      child: const Text('דיווח'),
                      onTap: () => routeToReport(
                        tabController.index,
                        [selectedPersona.id],
                      ).push(context),
                    ),
                    PopupMenuItem(
                      child: const Text('פרופיל אישי'),
                      onTap: () => PersonaDetailsRouteData(
                        id: selectedPersona.id,
                      ).push(context),
                    ),
                  ],
                );
              },
            )
          else if (viewedSelectedTasks(tabController.index).length > 1)
            Builder(
              builder: (context) {
                final selectedApprentices = apprentices.where(
                  (element) => viewedSelectedTasks(tabController.index)
                      .map((e) => e.subject)
                      .expand((element) => element)
                      .contains(element.id),
                );

                return IconButton(
                  onPressed: () => routeToReport(
                    tabController.index,
                    selectedApprentices.map((e) => e.id).toList(),
                  ).push(context),
                  icon: const Icon(
                    FluentIcons.clipboard_task_24_regular,
                  ),
                );
              },
            ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: tabController,
          labelColor: AppColors.grey2,
          unselectedLabelColor: AppColors.grey2,
          labelStyle: TextStyles.s14w400cGrey2,
          unselectedLabelStyle: TextStyles.s14w500cGrey2,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('שיחות'),
                  if (calls.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(right: 2),
                      child: CircleAvatar(
                        radius: 3,
                        backgroundColor: AppColors.blue03,
                      ),
                    ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('מפגשים'),
                  if (meetings.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(right: 2),
                      child: CircleAvatar(
                        radius: 3,
                        backgroundColor: AppColors.blue03,
                      ),
                    ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('הורים'),
                  if (parents.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(right: 2),
                      child: CircleAvatar(
                        radius: 3,
                        backgroundColor: AppColors.blue03,
                      ),
                    ),
                ],
              ),
            ),
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
                image: Assets.illustrations.clap.svg(),
                topText: 'איזה יופי!',
                bottomText: 'אין שיחות לבצע',
              )
            else
              ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: calls.length,
                itemBuilder: (context, index) => calls[index],
              ),
            if (tabController.index == 1 &&
                searchController.text.isNotEmpty &&
                meetings.isEmpty)
              Text('לא נמצאו תוצאות עבור ${searchController.text}')
            else if (meetings.isEmpty)
              EmptyState(
                image: Assets.illustrations.clap.svg(),
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
            if (tabController.index == 2 &&
                searchController.text.isNotEmpty &&
                parents.isEmpty)
              Text('לא נמצאו תוצאות עבור ${searchController.text}')
            else if (parents.isEmpty)
              EmptyState(
                image: Assets.illustrations.clap.svg(),
                topText: 'איזה יופי!',
                bottomText: 'אין שיחות הורים לבצע',
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
