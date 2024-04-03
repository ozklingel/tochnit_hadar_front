import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/functions/launch_url.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/services/api/user_profile_form/get_personas.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/controller/tasks_controller.dart';
import 'package:hadar_program/src/views/widgets/appbars/search_appbar.dart';
import 'package:hadar_program/src/views/widgets/cards/task_card.dart';
import 'package:hadar_program/src/views/widgets/states/empty_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

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
          tabs: const [
            Tab(text: 'לביצוע'),
            Tab(text: 'הושלמו'),
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
                  (e) => CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: false,
                    onChanged: (value) =>
                        TaskDetailsRouteData(id: e.id).push(context),
                    title: Text(
                      e.reportEventType.name,
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
                        onChanged: (value) =>
                            TaskDetailsRouteData(id: e.id).push(context),
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
  const _MelaveTasksBody();

  @override
  Widget build(BuildContext context, ref) {
    final tasks = ref.watch(tasksControllerProvider).valueOrNull ?? [];
    final apprentices = ref.watch(getPersonasProvider).valueOrNull ?? [];
    final tabController = useTabController(initialLength: 3);
    final isSearchOpen = useState(false);
    final searchController = useTextEditingController();
    final selectedCalls = useState(<TaskDto>[]);
    final selectedMeetings = useState(<TaskDto>[]);
    final selectedParents = useState(<TaskDto>[]);
    useListenable(searchController);
    useListenable(tabController);

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
        .where((element) => element.reportEventType == TaskType.call)
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
          ].contains(element.reportEventType),
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
              .contains(element.reportEventType),
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
          if ((tabController.index == 0 && selectedCalls.value.length < 2) ||
              (tabController.index == 1 && selectedMeetings.value.length < 2) ||
              (tabController.index == 2 && selectedParents.value.length < 2))
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
                      onTap: () => ReportNewRouteData(
                        initRecipients: [selectedApprentice.id],
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
                final selectedApprentice = apprentices.singleWhere(
                  (element) =>
                      selectedCalls.value.first.subject.contains(element.id),
                  orElse: () => const PersonaDto(),
                );

                return PopupMenuButton(
                  icon: const Icon(FluentIcons.more_vertical_24_regular),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('להתקשר'),
                      onTap: () => launchCall(phone: selectedApprentice.phone),
                    ),
                    PopupMenuItem(
                      child: const Text('שליחת וואטסאפ'),
                      onTap: () =>
                          launchWhatsapp(phone: selectedApprentice.phone),
                    ),
                    PopupMenuItem(
                      child: const Text('שליחת SMS'),
                      onTap: () => launchSms(phone: selectedApprentice.phone),
                    ),
                    PopupMenuItem(
                      child: const Text('דיווח'),
                      onTap: () => ReportNewRouteData(
                        initRecipients: [selectedApprentice.id],
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
            )
          else if ((tabController.index == 0 &&
                  selectedCalls.value.length > 1) ||
              (tabController.index == 1 && selectedMeetings.value.length > 1) ||
              (tabController.index == 2 && selectedParents.value.length > 1))
            Builder(
              builder: (context) {
                final selectedApprentices = apprentices.where(
                  (element) {
                    return tabController.index == 0
                        ? selectedCalls.value
                            .map((e) => e.subject)
                            .expand((element) => element)
                            .contains(element.id)
                        : tabController.index == 1
                            ? selectedMeetings.value
                                .map((e) => e.subject)
                                .expand((element) => element)
                                .contains(element.id)
                            : selectedParents.value
                                .map((e) => e.subject)
                                .expand((element) => element)
                                .contains(element.id);
                  },
                );

                // Logger().d(
                //   selectedMeetings.value
                //       .map((e) => e.apprenticeIds)
                //       .expand((element) => element),
                //   error: apprentices.length,
                // );

                return IconButton(
                  onPressed: () => ReportNewRouteData(
                    initRecipients:
                        selectedApprentices.map((e) => e.id).toList(),
                  ).push(context),
                  icon: const Icon(
                    FluentIcons.clipboard_24_regular,
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
            if (tabController.index == 0 &&
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
            if (tabController.index == 0 &&
                searchController.text.isNotEmpty &&
                parents.isEmpty)
              Text('לא נמצאו תוצאות עבור ${searchController.text}')
            else if (parents.isEmpty)
              EmptyState(
                image: Assets.illustrations.clap.svg(),
                topText: 'איזה יופי!',
                bottomText: 'אין שיחות לבצע',
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
