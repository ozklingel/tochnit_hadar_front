import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/controller/tasks_controller.dart';
import 'package:hadar_program/src/views/widgets/cards/task_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final apprentices =
        ref.watch(apprenticesControllerProvider).valueOrNull ?? [];

    return Scaffold(
      drawer: drawer(context),
      appBar: AppBar(
        centerTitle: true,
        title: Assets.images.logo.image(
          height: 48,
        ),
        actions: [
          IconButton(
            onPressed: () => const notificationRouteData().go(context),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Header(),
            const SizedBox(height: 44),
            _UpcomingEvents(
              apprentice: apprentices.firstOrNull ?? const ApprenticeDto(),
            ),
            const SizedBox(height: 24),
            const _UpcomingTasks(),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  drawer(context) {
    Size size = MediaQuery.of(context).size;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: size.height * 2 / 5,
            child: DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        AssetImage('assets/images/person.png') as ImageProvider,
                  ),
                  Text('John Doe'),
                  Text('John@Doe'),
                  TextButton(
                    child: Text(
                      "ערוך פרופיל",
                    ),
                    onPressed: () {
                      const userProfileRouteData().go(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
              height: size.height * 3 / 5,
              color: Colors.blue[50], //Color.fromRGBO(246, 249, 254, 1),
              child: ListView(children: [
                ListTile(
                  dense: true,

                  leading: CircleAvatar(
                    radius: 10,
                    backgroundImage:
                        AssetImage('assets/images/madad.png') as ImageProvider,
                  ),
                  title: Text('מדדי תוכנית'),
                  onTap: () => const supportRouteData()
                      .go(context), //context.go(Routes.SUPPORT),
                ),
                ListTile(
                  dense: true,

                  leading: CircleAvatar(
                    radius: 10,
                    backgroundImage:
                        AssetImage('assets/images/mapa.png') as ImageProvider,
                  ),
                  title: Text('מפת מיקומים'),
                  onTap: () => const supportRouteData()
                      .go(context), //context.go(Routes.SUPPORT),
                ),
                ListTile(
                  dense: true,

                  leading: CircleAvatar(
                    radius: 10,
                    backgroundImage: AssetImage('assets/images/envalop.png')
                        as ImageProvider,
                  ),
                  title: Text('הודעות מערכת'),
                  onTap: () => const supportRouteData()
                      .go(context), //context.go(Routes.SUPPORT),
                ),
                ListTile(
                  dense: true,

                  leading: CircleAvatar(
                    radius: 10,
                    backgroundImage:
                        AssetImage('assets/images/call.png') as ImageProvider,
                  ),
                  title: Text('פניות שירות'),
                  onTap: () => const supportRouteData()
                      .go(context), //context.go(Routes.SUPPORT),
                ),
                ListTile(
                  dense: true,

                  leading: CircleAvatar(
                    radius: 10,
                    backgroundImage: AssetImage('assets/images/setting.png')
                        as ImageProvider,
                  ),
                  title: Text('הגדרות והתראות'),
                  onTap: () => const supportRouteData()
                      .go(context), //context.go(Routes.SUPPORT),
                ),
                ListTile(
                  dense: true,

                  leading: CircleAvatar(
                    radius: 10,
                    backgroundImage: AssetImage('assets/images/person2.png')
                        as ImageProvider,
                  ),
                  title: Text('התנתקות'),
                  onTap: () => const supportRouteData()
                      .go(context), //context.go(Routes.SUPPORT),
                ),
              ])),
        ],
      ),
    );
  }
}

class _UpcomingTasks extends HookConsumerWidget {
  const _UpcomingTasks();

  @override
  Widget build(BuildContext context, ref) {
    final tasks = ref.watch(tasksControllerProvider).valueOrNull ?? [];
    final selectedCalls = useState(<TaskDto>[]);
    final selectedMeetings = useState(<TaskDto>[]);
    final selectedParents = useState(<TaskDto>[]);

    final calls = tasks
        .where(
          (element) => element.reportEventType == TaskType.call,
        )
        .take(3)
        .toList();

    final meetings = tasks
        .where(
          (element) => element.reportEventType == TaskType.meeting,
        )
        .take(3)
        .toList();

    final parents = tasks
        .where(
          (element) => element.reportEventType == TaskType.parents,
        )
        .take(3)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'משימות לביצוע',
                style: TextStyles.s20w500,
              ),
              const Spacer(),
              TextButton(
                onPressed: () => const TasksRouteData().go(context),
                child: const Text(
                  'הצג הכל',
                  style: TextStyles.s14w300cGray2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ActionsRow(
            label: 'שיחות',
            selectedTasks: selectedCalls.value,
          ),
          const SizedBox(height: 6),
          if (calls.isEmpty)
            const Text(
              'אין שיחות שמחכות לביצוע',
              style: TextStyles.s16w300cGray2,
            )
          else
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: calls
                  .map(
                    (e) => TaskCard(
                      selectedItems: selectedCalls,
                      task: e,
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: 24),
          _ActionsRow(
            label: 'מפגשים',
            selectedTasks: selectedMeetings.value,
          ),
          const SizedBox(height: 6),
          if (meetings.isEmpty)
            const Text(
              'אין מפגשים שמחכים לביצוע',
              style: TextStyles.s16w300cGray2,
            )
          else
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: meetings
                  .map(
                    (e) => TaskCard(
                      selectedItems: selectedMeetings,
                      task: e,
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: 24),
          _ActionsRow(
            label: 'שיחות להורים',
            selectedTasks: selectedParents.value,
          ),
          const SizedBox(height: 6),
          if (parents.isEmpty)
            const Text(
              'אין שיחות להורים שמחכות לביצוע',
              style: TextStyles.s16w300cGray2,
            )
          else
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: parents
                  .map(
                    (e) => TaskCard(
                      selectedItems: selectedParents,
                      task: e,
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  const _ActionsRow({
    required this.label,
    required this.selectedTasks,
  });

  final String label;
  final List<TaskDto> selectedTasks;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Text(
            label,
            style: TextStyles.s18w400cGray1,
          ),
          const Spacer(),
          if (selectedTasks.length == 1) ...[
            IconButton(
              onPressed: () => Toaster.unimplemented(),
              icon: const Icon(FluentIcons.call_24_regular),
            ),
            IconButton(
              onPressed: () => Toaster.unimplemented(),
              icon: Assets.icons.whatsapp.svg(
                height: 20,
              ),
            ),
            IconButton(
              onPressed: () => Toaster.unimplemented(),
              icon: const Icon(FluentIcons.clipboard_task_24_regular),
            ),
            PopupMenuButton(
              offset: const Offset(0, 32),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => Toaster.unimplemented(),
                  child: const Text('שליחת SMS'),
                ),
                PopupMenuItem(
                  onTap: () => Toaster.unimplemented(),
                  child: const Text('פרופיל אישי'),
                ),
              ],
              icon: const Icon(FluentIcons.more_vertical_24_regular),
            ),
          ] else if (selectedTasks.length > 1)
            IconButton(
              onPressed: () => Toaster.unimplemented(),
              icon: const Icon(FluentIcons.clipboard_task_24_regular),
            ),
        ],
      ),
    );
  }
}

class _UpcomingEvents extends StatelessWidget {
  const _UpcomingEvents({
    required this.apprentice,
  });

  final ApprenticeDto apprentice;

  @override
  Widget build(BuildContext context) {
    final children = [
      _EventCard(
        event: apprentice.events.firstOrNull ?? const EventDto(),
      ),
      _EventCard(
        event: apprentice.events.firstOrNull ?? const EventDto(),
      ),
      _EventCard(
        event: apprentice.events.firstOrNull ?? const EventDto(),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'אירועים קרובים',
            style: TextStyles.s20w500,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
          ),
        ),
      ],
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header();

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        child: Stack(
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF5083bb),
                    Color(0xFF34547c),
                  ],
                ),
              ),
              child: Assets.images.homePageHeader.svg(
                height: 140,
                width: 320,
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(
              height: 132,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'בוקר טוב',
                          style: TextStyles.s20w300cWhite,
                        ),
                        const TextSpan(text: '\n'),
                        TextSpan(
                          text: user.fullName,
                          style: TextStyles.s32w500cWhite,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends ConsumerWidget {
  const _EventCard({
    required this.event,
  });

  final EventDto event;

  @override
  Widget build(BuildContext context, ref) {
    return SizedBox(
      width: 232,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          gradient: LinearGradient(
            colors: [
              Color(0x33ECF2F5),
              Color(0x333D94D2),
            ],
          ),
        ),
        child: InkWell(
          onTap: () => GiftRouteData(id: event.id).go(context),
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        event.title,
                        style: TextStyles.s16w500cGrey2,
                      ),
                      Text(
                        event.description,
                        style: TextStyles.s14w300cGray2,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Align(
                  alignment: Alignment.topCenter,
                  child: Icon(FluentIcons.gift_24_regular),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
