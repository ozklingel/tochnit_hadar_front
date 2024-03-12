import 'package:collection/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/controllers/subordinate_scroll_controller.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/core/utils/functions/launch_url.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/events_controller.dart';
import 'package:hadar_program/src/views/primary/pages/report/controller/reports_controller.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/cards/details_card.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hadar_program/src/views/widgets/headers/details_page_header.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ApprenticeDetailsScreen extends StatefulHookConsumerWidget {
  const ApprenticeDetailsScreen({
    super.key,
    required this.apprenticeId,
  });

  final String apprenticeId;

  @override
  ConsumerState<ApprenticeDetailsScreen> createState() =>
      _ApprenticeDetailsScreenState();
}

class _ApprenticeDetailsScreenState
    extends ConsumerState<ApprenticeDetailsScreen> {
  final scrollControllers = <SubordinateScrollController?>[
    null,
    null,
    null,
  ];

  @override
  void dispose() {
    super.dispose();
    for (final scrollController in scrollControllers) {
      scrollController?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userServiceProvider);

    final apprentice = ref.watch(
          apprenticesControllerProvider.select(
            (value) => value.value?.singleWhere(
              (element) => element.id == widget.apprenticeId,
              orElse: () => const ApprenticeDto(),
            ),
          ),
        ) ??
        const ApprenticeDto();

    final tabController = useTabController(
      initialLength: 3,
    );

    final views = [
      _TohnitHadarTabView(apprentice: apprentice),
      _PersonalInfoTabView(apprentice: apprentice),
      _MilitaryServiceTabView(apprentice: apprentice),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('כרטיס חניך'),
        actions: [
          if (user.valueOrNull?.role == UserRole.ahraiTohnit)
            PopupMenuButton(
              offset: const Offset(0, 32),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return _DeleteApprenticeDialog(
                        apprenticeId: apprentice.id,
                      );
                    },
                  ),
                  child: const Text('מחיקה מהמערכת'),
                ),
              ],
              icon: const Icon(FluentIcons.more_vertical_24_regular),
            ),
          const SizedBox(width: 6),
        ],
      ),
      // https://api.flutter.dev/flutter/widgets/NestedScrollView-class.html
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 380,
                  collapsedHeight: 60,
                  forceElevated: false,
                  floating: false,
                  snap: false,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: DetailsPageHeader(
                      avatar: apprentice.avatar,
                      name: '${apprentice.firstName} ${apprentice.lastName}',
                      phone: apprentice.phone,
                      onTapEditAvatar: () => Toaster.unimplemented(),
                      bottom: Column(
                        children: [
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _ActionButton(
                                text: 'שיחה',
                                icon: const Icon(FluentIcons.call_24_regular),
                                onPressed: () async {
                                  if (apprentice.phone.isEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (_) =>
                                          const _MissingInformationDialog(),
                                    );

                                    return;
                                  }

                                  final url =
                                      Uri.tryParse('tel:${apprentice.phone}') ??
                                          Uri.parse('');

                                  if (!await launchUrl(url)) {
                                    throw Exception('לא ניתן להתקשר למספר זה');
                                  }
                                },
                              ),
                              _ActionButton(
                                text: 'וואטסאפ',
                                icon: Assets.icons.whatsapp.svg(height: 20),
                                onPressed: () =>
                                    launchWhatsapp(phone: apprentice.phone),
                              ),
                              _ActionButton(
                                text: 'SMS',
                                icon: const Icon(FluentIcons.chat_24_regular),
                                onPressed: () =>
                                    launchSms(phone: apprentice.phone),
                              ),
                              _ActionButton(
                                text: 'דיווח',
                                icon: const Icon(
                                  FluentIcons.clipboard_task_24_regular,
                                ),
                                onPressed: () => Toaster.unimplemented(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    controller: tabController,
                    tabs: const [
                      Tab(text: 'תוכנית הדר'),
                      Tab(text: 'פרטים אישיים'),
                      Tab(text: 'שירות צבאי'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: List.generate(
            views.length,
            (index) => Builder(
              builder: (context) {
                final parentController = PrimaryScrollController.of(context);
                if (scrollControllers[index]?.parent != parentController) {
                  scrollControllers[index]?.dispose();
                  scrollControllers[index] =
                      SubordinateScrollController(parentController);
                }

                return CustomScrollView(
                  key: PageStorageKey<String>(
                    'apprentice-${views[index].key}${views[index].toString()}',
                  ),
                  controller: scrollControllers[index],
                  slivers: [
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: views[index],
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.only(bottom: 20),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteApprenticeDialog extends ConsumerWidget {
  const _DeleteApprenticeDialog({
    required this.apprenticeId,
  });

  final String apprenticeId;

  @override
  Widget build(BuildContext context, ref) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: SizedBox(
        height: 432,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CloseButton(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('מחיקת חניך', style: TextStyles.s24w400),
                    const SizedBox(height: 16),
                    const Text(
                      'פעולה זו תסיר את החניך מהמערכת.'
                      '\n\n'
                      'האם אתה בטוח שברצונך למחוק את החניך?',
                      style: TextStyles.s16w400cGrey3,
                    ),
                    const SizedBox(height: 48),
                    LargeFilledRoundedButton(
                      label: 'לא, השאר',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 16),
                    LargeFilledRoundedButton.cancel(
                      label: 'מחק',
                      onPressed: () => ref
                          .read(apprenticesControllerProvider.notifier)
                          .deleteApprentice(apprenticeId),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MilitaryServiceTabView extends HookConsumerWidget {
  const _MilitaryServiceTabView({
    required this.apprentice,
  });

  final ApprenticeDto apprentice;

  @override
  Widget build(BuildContext context, ref) {
    final compound =
        ref.watch(compoundControllerProvider).valueOrNull?.singleWhere(
                  (element) => element.id == apprentice.militaryCompoundId,
                  orElse: () => const CompoundDto(),
                ) ??
            const CompoundDto();
    final isEditMode = useState(false);
    final baseController = useTextEditingController(
      text: compound.name,
      keys: [apprentice],
    );
    final unitController = useTextEditingController(
      text: apprentice.militaryUnit,
      keys: [apprentice],
    );
    final positionNewController = useTextEditingController(
      text: apprentice.militaryPositionNew,
      keys: [apprentice],
    );
    final positionOldController = useTextEditingController(
      text: apprentice.militaryPositionOld,
      keys: [apprentice],
    );

    return AnimatedSwitcher(
      duration: Consts.defaultDurationM,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          axis: Axis.horizontal,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        ),
      ),
      child: isEditMode.value
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(36)),
                        borderSide: BorderSide(
                          color: AppColors.gray5,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'צבא',
                        style: TextStyles.s20w400.copyWith(
                          color: AppColors.gray1,
                        ),
                      ),
                      const SizedBox(height: 32),
                      InputFieldContainer(
                        label: 'שם הבסיס',
                        isRequired: true,
                        child: TextField(
                          controller: baseController,
                        ),
                      ),
                      const SizedBox(height: 32),
                      InputFieldContainer(
                        label: 'שיוך יחידתי',
                        isRequired: true,
                        child: TextField(
                          controller: unitController,
                        ),
                      ),
                      const SizedBox(height: 32),
                      InputFieldContainer(
                        label: 'תפקיד נוכחי',
                        isRequired: true,
                        child: TextField(
                          controller: positionNewController,
                        ),
                      ),
                      const SizedBox(height: 32),
                      InputFieldContainer(
                        label: 'תפקיד קודם',
                        isRequired: true,
                        child: TextField(
                          controller: positionOldController,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: LargeFilledRoundedButton(
                              label: 'שמירה',
                              onPressed: () async {
                                final result = await ref
                                    .read(
                                      apprenticesControllerProvider.notifier,
                                    )
                                    .editApprentice(
                                      apprentice: apprentice.copyWith(
                                        militaryCompoundId:
                                            apprentice.militaryCompoundId,
                                        militaryUnit: unitController.text,
                                        militaryPositionNew:
                                            positionNewController.text,
                                        militaryPositionOld:
                                            positionOldController.text,
                                      ),
                                    );

                                if (result) {
                                  isEditMode.value = false;
                                } else {
                                  Toaster.show(
                                    'שגיאה בעת שמירת השינויים',
                                  );
                                }
                              },
                              textStyle: TextStyles.s14w500,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: LargeFilledRoundedButton(
                              label: 'ביטול',
                              onPressed: () => isEditMode.value = false,
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.blue02,
                              textStyle: TextStyles.s14w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Column(
              children: [
                DetailsCard(
                  title: 'צבא',
                  trailing: IconButton(
                    onPressed: () => isEditMode.value = true,
                    icon: const Icon(FluentIcons.edit_24_regular),
                  ),
                  child: Column(
                    children: [
                      DetailsRowItem(
                        label: 'בסיס',
                        data: compound.name,
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: 'שיוך יחידתי',
                        data: apprentice.militaryUnit,
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: 'תפקיד קודם',
                        data: apprentice.militaryPositionOld,
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: 'תפקיד נוכחי',
                        data: apprentice.militaryPositionNew,
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: 'תאריך גיוס',
                        data: apprentice.militaryDateOfEnlistment.asDateTime
                            .asDayMonthYearShortDot,
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: 'תאריך שחרור',
                        data: apprentice.militaryDateOfDischarge.asDateTime
                            .asDayMonthYearShortDot,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _TohnitHadarTabView extends ConsumerWidget {
  const _TohnitHadarTabView({
    required this.apprentice,
  });

  final ApprenticeDto apprentice;

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);
    final reports = ref.watch(reportsControllerProvider).valueOrNull?.where(
              (element) => element.recipients.contains(apprentice.id),
            ) ??
        [];
    final institution =
        ref.watch(institutionsControllerProvider).valueOrNull?.singleWhere(
                  (element) => element.id == apprentice.institutionId,
                  orElse: () => const InstitutionDto(),
                ) ??
            const InstitutionDto();

    final events = ref
            .watch(eventsControllerProvider)
            .valueOrNull
            ?.where(
              (element) => apprentice.events
                  .where((e2) => e2.id == element.id)
                  .isNotEmpty,
            )
            .toList() ??
        const [];

    return Column(
      children: [
        DetailsCard(
          title: 'דיווחים אחרונים',
          trailing: TextButton(
            onPressed: () =>
                ReportsRouteData(apprenticeId: apprentice.id).push(context),
            child: const Text(
              'הצג הכל',
              style: TextStyles.s12w300cGray2,
            ),
          ),
          child: Consumer(
            builder: (context, ref, child) {
              final reports =
                  ref.watch(reportsControllerProvider).valueOrNull?.where(
                            (element) => apprentice.reportsIds
                                .take(3)
                                .contains(element.id),
                          ) ??
                      [];

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => reports
                    .map(
                      (e) => _AnnouncementItem(
                        text: TextSpan(
                          children: [
                            TextSpan(text: e.dateTime.asDateTime.he),
                            const TextSpan(text: ', '),
                            TextSpan(text: e.dateTime.asDateTime.asDayMonth),
                            const TextSpan(text: '. '),
                            TextSpan(text: e.dateTime.asDateTime.asTimeAgo),
                          ],
                        ),
                      ),
                    )
                    .toList()[index],
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: reports.length,
              );
            },
          ),
        ),
        DetailsCard(
          title: 'תוכנית הדר',
          trailing: TextButton.icon(
            onPressed: null,
            style: TextButton.styleFrom(
              disabledForegroundColor: AppColors.success600,
            ),
            icon: const Icon(Icons.check),
            label: const Text('משלם'),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DetailsRowItem(
                label: 'מקום לימודים',
                data: institution.name,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'מחזור',
                data: apprentice.thPeriod,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'ר”מ שנה א',
                data: '',
                contactName: apprentice.thRavMelamedYearAName,
                contactPhone: apprentice.thRavMelamedYearAPhone,
                onTapPhone: () async {
                  final phoneCallAction =
                      Uri.parse('tel:${apprentice.thRavMelamedYearAPhone}');
                  if (await canLaunchUrl(phoneCallAction)) {
                    await launchUrl(phoneCallAction);
                  }
                },
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'ר”מ שנה ב',
                data: '',
                contactName: apprentice.thRavMelamedYearBName,
                contactPhone: apprentice.thRavMelamedYearBPhone,
                onTapPhone: () async {
                  final phoneCallAction =
                      Uri.parse('tel:${apprentice.thRavMelamedYearBPhone}');
                  if (await canLaunchUrl(phoneCallAction)) {
                    await launchUrl(phoneCallAction);
                  }
                },
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'מלווה',
                data: apprentice.thMentor,
              ),
            ],
          ),
        ),
        if (user.valueOrNull?.role == UserRole.ahraiTohnit) ...[
          DetailsCard(
            title: 'מצב”ר',
            trailing: Row(
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: apprentice.matsber == 'אדוק'
                      ? AppColors.green1
                      : apprentice.matsber == 'מחובר'
                          ? AppColors.green1
                          : apprentice.matsber == 'מחובר חלקית'
                              ? AppColors.yellow1
                              : apprentice.matsber == 'בשלבי ניתוק'
                                  ? AppColors.yellow1
                                  : apprentice.matsber == 'מנותק'
                                      ? AppColors.red1
                                      : AppColors.grey1,
                ),
                const SizedBox(width: 6),
                Text(
                  apprentice.matsber,
                  style: TextStyles.s12w400cGrey2,
                ),
              ],
            ),
            child: const SizedBox.shrink(),
          ),
          DetailsCard(
            title: 'דיווחים אחרונים',
            trailing: TextButton(
              onPressed: () =>
                  ReportsRouteData(apprenticeId: apprentice.id).push(context),
              child: const Text(
                'הצג הכל',
                style: TextStyles.s12w300cBlue2,
              ),
            ),
            child: Column(
              children: reports
                  .sortedBy<num>(
                    (element) =>
                        DateTime.parse(element.dateTime).millisecondsSinceEpoch,
                  )
                  .reversed
                  .take(3)
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          if (e.reportEventType == ReportEventType.phoneCall)
                            const Icon(FluentIcons.people_24_regular)
                          else if (e.reportEventType ==
                              ReportEventType.phoneCall)
                            const Icon(FluentIcons.phone_24_regular)
                          else if (e.reportEventType ==
                              ReportEventType.fiveMessages)
                            const Icon(FluentIcons.textbox_24_regular)
                          else
                            const Icon(FluentIcons.question_24_regular),
                          const SizedBox(width: 6),
                          Text(
                            e.dateTime.asDateTime.he,
                            style: TextStyles.s14w400cGrey5,
                          ),
                          const Text('.'),
                          const SizedBox(width: 6),
                          Text(
                            e.dateTime.asDateTime.asTimeAgo,
                            style: TextStyles.s14w400cGrey5,
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
        DetailsCard(
          title: 'אירועים',
          trailing: IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                enableDrag: false,
                builder: (context) {
                  return _EventBottomSheet(
                    apprentice: apprentice,
                    event: events.firstOrNull ?? const EventDto(),
                  );
                },
              );
            },
            icon: const Icon(FluentIcons.add_circle_24_regular),
          ),
          child: apprentice.events.isEmpty
              ? const Text(
                  'אין אירועים מוזנים. לחץ כדי להוסיף אירוע',
                  textAlign: TextAlign.start,
                )
              : Builder(
                  builder: (context) {
                    // TODO(noga-dev) bring back
                    final children = apprentice.events
                        .take(3)
                        .map(
                          (e) => Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  'e.title',
                                  style: TextStyles.s14w400.copyWith(
                                    color: AppColors.gray5,
                                  ),
                                ),
                              ),
                              Text(
                                'e.dateTime.asDateTime.asDayMonthYearShortDot',
                                style: TextStyles.s14w400.copyWith(
                                  color: AppColors.gray2,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  // _RowIconButton(
                                  //   onPressed: () => showModalBottomSheet(
                                  //     context: context,
                                  //     builder: (context) => _EventBottomSheet(
                                  //       apprentice: apprentice,
                                  //       event: e,
                                  //     ),
                                  //   ),
                                  //   icon:
                                  //       const Icon(FluentIcons.edit_24_regular),
                                  // ),
                                  const SizedBox(width: 4),
                                  _RowIconButton(
                                    onPressed: () async {
                                      final result = await ref
                                          .read(
                                            apprenticesControllerProvider
                                                .notifier,
                                          )
                                          .deleteEvent(
                                            apprenticeId: apprentice.id,
                                            eventId: e.id,
                                          );

                                      if (!result) {
                                        Toaster.error(
                                          'שגיאה בעת מחיקת האירוע',
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      FluentIcons.delete_24_regular,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        .toList();

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => children[index],
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 4),
                      itemCount: children.length,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _EventBottomSheet extends HookConsumerWidget {
  const _EventBottomSheet({
    required this.apprentice,
    required this.event,
  });

  final ApprenticeDto apprentice;
  final EventDto event;

  @override
  Widget build(BuildContext context, ref) {
    final selectedDatetime = useState<DateTime?>(event.datetime.asDateTime);
    final titleController = useTextEditingController(
      text: event.title,
      keys: [event],
    );
    final descriptionController = useTextEditingController(
      text: event.description,
      keys: [event],
    );

    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (context) => SizedBox(
        height: 400,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          child: ColoredBox(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            event.id.isEmpty ? 'הוספת אירוע' : 'עריכת אירוע',
                            style: TextStyles.s20w400.copyWith(
                              color: AppColors.gray2,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'כברירת מחדל, התראה תשלח 3 ימים לפני מועד האירוע.'
                                '\n'
                                'ניתן לשנות בהגדרות.',
                                style: TextStyles.s14w400.copyWith(
                                  color: AppColors.blue04,
                                ),
                              ),
                              const SizedBox(height: 26),
                              InputFieldContainer(
                                label: 'שם האירוע',
                                child: TextField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    hintText: 'שם האירוע',
                                    hintStyle:
                                        TextStyles.s16w400cGrey2.copyWith(
                                      color: AppColors.grey5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 26),
                              const Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: 'תאריך האירוע'),
                                    TextSpan(text: ' '),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(color: AppColors.red2),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: () async {
                                  final newDate = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDatetime.value ??
                                        DateTime.now(),
                                    firstDate:
                                        DateTime.fromMillisecondsSinceEpoch(0),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365 * 99000)),
                                  );

                                  if (newDate == null) {
                                    return;
                                  }

                                  selectedDatetime.value = newDate;
                                },
                                borderRadius: BorderRadius.circular(36),
                                child: IgnorePointer(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: selectedDatetime.value == null
                                          ? 'MM/DD/YY'
                                          : DateFormat('dd/MM/yy')
                                              .format(selectedDatetime.value!),
                                      hintStyle:
                                          TextStyles.s16w400cGrey2.copyWith(
                                        color: AppColors.grey5,
                                      ),
                                      suffixIcon: const Padding(
                                        padding: EdgeInsets.only(left: 16),
                                        child: Icon(
                                          Icons.calendar_month,
                                          color: AppColors.grey5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 26),
                              const Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: 'תיאור האירוע'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: descriptionController,
                                minLines: 6,
                                maxLines: 6,
                                decoration: InputDecoration(
                                  hintText: 'כתוב את תיאור האירוע',
                                  hintStyle: TextStyles.s16w400cGrey2.copyWith(
                                    color: AppColors.grey5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ColoredBox(
                      color: Colors.white,
                      child: SizedBox(
                        height: 60,
                        child: LargeFilledRoundedButton(
                          label: 'שמירה',
                          // TODO (noga-dev): bring back
                          // onPressed: () async {
                          //   final navContext = Navigator.of(context);
                          //   final notifier = ref.read(
                          //     apprenticesControllerProvider.notifier,
                          //   );

                          //   if (event.id.isEmpty) {
                          //     final result = await notifier.addEvent(
                          //       apprenticeId: apprentice.id,
                          //       event: EventDto(
                          //         title: titleController.text,
                          //         description: descriptionController.text,
                          //         dateTime: selectedDatetime.value
                          //                 ?.toIso8601String() ??
                          //             DateTime.now().toIso8601String(),
                          //       ),
                          //     );
                          //     if (result) {
                          //       navContext.maybePop();
                          //     } else {
                          //       Toaster.show('שגיאה בעת שמירת האירוע');
                          //       return;
                          //     }
                          //   } else {
                          //     final edited = apprentice.eventIds.firstWhere(
                          //       (element) => element == event.id,
                          //     );
                          //     final result = await notifier.editEvent(
                          //       apprenticeId: apprentice.id,
                          //       event: edited.copyWith(
                          //         title: titleController.text,
                          //         description: descriptionController.text,
                          //         dateTime: selectedDatetime.value
                          //                 ?.toIso8601String() ??
                          //             DateTime.now().toIso8601String(),
                          //       ),
                          //     );

                          //     if (result) {
                          //       navContext.maybePop();
                          //     } else {
                          //       Toaster.show('שגיאה בעת שמירת האירוע');
                          //       return;
                          //     }
                          //   }
                          // },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnnouncementItem extends StatelessWidget {
  const _AnnouncementItem({
    required this.text,
  });

  final TextSpan text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(FluentIcons.person_24_regular),
        const SizedBox(width: 18),
        Text.rich(
          text,
          style: TextStyles.s14w400.copyWith(
            color: AppColors.gray5,
          ),
        ),
      ],
    );
  }
}

class _PersonalInfoTabView extends ConsumerWidget {
  const _PersonalInfoTabView({
    required this.apprentice,
  });

  final ApprenticeDto apprentice;

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);

    return Column(
      children: [
        DetailsCard(
          title: 'כללי',
          child: Column(
            children: [
              DetailsRowItem(
                label: 'תעודת זהות',
                data: apprentice.teudatZehut,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'אימייל',
                data: apprentice.email,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'כתובת',
                data: apprentice.address.fullAddress,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'אזור',
                data: apprentice.address.region,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'מצב משפחתי',
                data: apprentice.maritalStatus,
              ),
            ],
          ),
        ),
        const DetailsCard(
          title: 'תאריכים',
          child: Column(
            children: [
              DetailsRowItem(
                label: 'יום הולדת',
                data: 'כ”א ניסן',
              ),
              DetailsRowItem(
                label: 'יום נישואים',
                data: 'ט”ו אב',
              ),
            ],
          ),
        ),
        DetailsCard(
          title: 'משפחה',
          trailing: user.valueOrNull?.role == UserRole.ahraiTohnit
              ? IconButton(
                  icon: const Icon(
                    FluentIcons.add_circle_24_regular,
                    color: AppColors.blue02,
                  ),
                  onPressed: () => Toaster.unimplemented(),
                )
              : null,
          child: Column(
            children: [
              if (apprentice.contact1FirstName.isNotEmpty)
                _ContactRow(
                  email: apprentice.contact1Email,
                  fullName: apprentice.contact1FirstName +
                      apprentice.contact1LastName,
                  phone: apprentice.contact1Phone,
                  relationship: apprentice.contact1Relationship,
                ),
              if (apprentice.contact2FirstName.isNotEmpty)
                _ContactRow(
                  email: apprentice.contact2Email,
                  fullName: apprentice.contact2FirstName +
                      apprentice.contact2LastName,
                  phone: apprentice.contact2Phone,
                  relationship: apprentice.contact2Relationship,
                ),
              if (apprentice.contact3FirstName.isNotEmpty)
                _ContactRow(
                  email: apprentice.contact3Email,
                  fullName: apprentice.contact3FirstName +
                      apprentice.contact3LastName,
                  phone: apprentice.contact3Phone,
                  relationship: apprentice.contact3Relationship,
                ),
            ],
          ),
        ),
        DetailsCard(
          title: 'לימודי תיכון',
          child: Column(
            children: [
              DetailsRowItem(
                label: 'מוסד לימודים',
                data: apprentice.highSchoolInstitution,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'ר”מ בתיכון',
                data: apprentice.highSchoolRavMelamedName,
              ),
            ],
          ),
        ),
        DetailsCard(
          title: 'עיסוק',
          child: Column(
            children: [
              DetailsRowItem(
                label: 'סטטוס',
                data: apprentice.workStatus,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'עיסוק',
                data: apprentice.workOccupation,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'מקום לימודים',
                data: apprentice.educationalInstitution,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'פקולטה',
                data: apprentice.educationFaculty,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'סוג עבודה',
                data: apprentice.workType,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'מקום עבודה',
                data: apprentice.workPlace,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.relationship,
    required this.phone,
    required this.fullName,
    required this.email,
  });

  final Relationship relationship;
  final String phone;
  final String fullName;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            style: TextStyles.s14w400,
            children: [
              TextSpan(
                text: relationship.name,
                style: const TextStyle(
                  color: AppColors.gray5,
                ),
              ),
              const TextSpan(text: '\t'),
              TextSpan(text: fullName),
            ],
          ),
        ),
        _ContactButtons(
          phone: phone,
          email: email,
        ),
      ],
    );
  }
}

class _ContactButtons extends ConsumerWidget {
  const _ContactButtons({
    required this.phone,
    required this.email,
  });

  final String phone;
  final String email;

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);

    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            phone,
            style: TextStyles.s14w400.copyWith(
              color: AppColors.gray2,
            ),
          ),
        ),
        const Spacer(),
        if (user.valueOrNull?.role == UserRole.ahraiTohnit) ...[
          _RowIconButton(
            onPressed: () => Toaster.unimplemented(),
            icon: const Icon(FluentIcons.edit_24_regular),
          ),
          _RowIconButton(
            onPressed: () => Toaster.unimplemented(),
            icon: const Icon(FluentIcons.delete_24_regular),
          ),
        ] else ...[
          _RowIconButton(
            onPressed: () => launchSms(phone: phone),
            icon: const Icon(FluentIcons.chat_24_regular),
          ),
          const SizedBox(width: 4),
          _RowIconButton(
            icon: Assets.icons.whatsapp.svg(
              height: 20,
            ),
            onPressed: () => launchWhatsapp(phone: phone),
          ),
          const SizedBox(width: 4),
          _RowIconButton(
            onPressed: () => launchCall(phone: phone),
            icon: const Icon(FluentIcons.call_24_regular),
          ),
          const SizedBox(width: 4),
          _RowIconButton(
            onPressed: () => launchEmail(email: email),
            icon: const Icon(FluentIcons.mail_24_regular),
          ),
        ],
      ],
    );
  }
}

class _RowIconButton extends StatelessWidget {
  const _RowIconButton({
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(36),
      child: InkWell(
        borderRadius: BorderRadius.circular(36),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: icon,
        ),
      ),
    );
  }
}

class _MissingInformationDialog extends StatelessWidget {
  const _MissingInformationDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 320,
        child: ColoredBox(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close),
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'חסרים פרטים',
                        style: TextStyles.s24w400,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'מספר הטלפון לא מוזן במערכת,'
                        '\n'
                        'ולכן אין אפשרות להתקשר.',
                        style: TextStyles.s16w400cGrey2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                LargeFilledRoundedButton(
                  label: 'אישור',
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final Widget icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          style: IconButton.styleFrom(
            side: const BorderSide(
              color: AppColors.gray7,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          icon: icon,
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyles.s12w300cGray2,
        ),
      ],
    );
  }
}
