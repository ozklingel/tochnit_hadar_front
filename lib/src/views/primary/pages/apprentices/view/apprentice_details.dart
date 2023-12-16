import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/primary/pages/report/controller/reports_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ApprenticeDetailsScreen extends HookConsumerWidget {
  const ApprenticeDetailsScreen({
    super.key,
    required this.apprenticeId,
  });

  final String apprenticeId;

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);

    final apprentice = ref.watch(
          apprenticesControllerProvider.select(
            (value) => value.value?.singleWhere(
              (element) => element.id == apprenticeId,
              orElse: () => const ApprenticeDto(),
            ),
          ),
        ) ??
        const ApprenticeDto();

    final tabController = useTabController(
      initialLength: 3,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('כרטיס חניך'),
        actions: [
          if (user.role == Role.ahraiTohnit)
            PopupMenuButton(
              offset: const Offset(0, 32),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return const _DeleteApprenticeDialog();
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
                    background: _Header(apprentice: apprentice),
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
          children: [
            _TohnitHadarTabView(apprentice: apprentice),
            _PersonalInfoTabView(apprentice: apprentice),
            _MilitaryServiceTabView(apprentice: apprentice),
          ]
              .map(
                (e) => Builder(
                  builder: (context) {
                    return CustomScrollView(
                      key: PageStorageKey<String>('${e.key}${e.toString()}'),
                      slivers: [
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: e,
                        ),
                        const SliverPadding(
                          padding: EdgeInsets.only(bottom: 20),
                        ),
                      ],
                    );
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _DeleteApprenticeDialog extends StatelessWidget {
  const _DeleteApprenticeDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () => Toaster.unimplemented(),
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
                  (element) => element.id == apprentice.militaryCompound.id,
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
                                        militaryCompound: apprentice
                                            .militaryCompound
                                            .copyWith(
                                          name: baseController.text,
                                        ),
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
                _Card(
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
              (element) => element.apprentices.contains(apprentice.id),
            ) ??
        [];

    return Column(
      children: [
        _Card(
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
                            (element) =>
                                apprentice.reports.take(3).contains(element.id),
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
        _Card(
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
                data: apprentice.thInstitution,
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
                contact: apprentice.thRavMelamedYearA,
                onTapPhone: () async {
                  final phoneCallAction =
                      Uri.parse('tel:${apprentice.thRavMelamedYearA.phone}');
                  if (await canLaunchUrl(phoneCallAction)) {
                    await launchUrl(phoneCallAction);
                  }
                },
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'ר”מ שנה ב',
                data: '',
                contact: apprentice.thRavMelamedYearB,
                onTapPhone: () async {
                  final phoneCallAction =
                      Uri.parse('tel:${apprentice.thRavMelamedYearB.phone}');
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
        if (user.role == Role.ahraiTohnit) ...[
          _Card(
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
          _Card(
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
                  .sortedBy<num>((element) => element.dateTime)
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
        _Card(
          title: 'אירועים',
          trailing: IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                enableDrag: false,
                builder: (context) {
                  return _EventBottomSheet(
                    apprentice: apprentice,
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
                    final children = apprentice.events
                        .take(3)
                        .map(
                          (e) => Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  e.title,
                                  style: TextStyles.s14w400.copyWith(
                                    color: AppColors.gray5,
                                  ),
                                ),
                              ),
                              Text(
                                e.dateTime.asDateTime.asDayMonthYearShortDot,
                                style: TextStyles.s14w400.copyWith(
                                  color: AppColors.gray2,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  _RowIconButton(
                                    onPressed: () => showModalBottomSheet(
                                      context: context,
                                      builder: (context) => _EventBottomSheet(
                                        apprentice: apprentice,
                                        event: e,
                                      ),
                                    ),
                                    icon:
                                        const Icon(FluentIcons.edit_24_regular),
                                  ),
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
    this.event = const EventDto(),
  });

  final ApprenticeDto apprentice;
  final EventDto event;

  @override
  Widget build(BuildContext context, ref) {
    final selectedDatetime = useState<DateTime?>(event.dateTime.asDateTime);
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
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ColoredBox(
                      color: Colors.white,
                      child: SizedBox(
                        height: 60,
                        child: LargeFilledRoundedButton(
                          label: 'שמירה',
                          onPressed: () async {
                            final navContext = Navigator.of(context);
                            final notifier = ref.read(
                              apprenticesControllerProvider.notifier,
                            );

                            if (event.id.isEmpty) {
                              final result = await notifier.addEvent(
                                apprenticeId: apprentice.id,
                                event: EventDto(
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  dateTime: selectedDatetime
                                          .value?.millisecondsSinceEpoch ??
                                      0,
                                ),
                              );
                              if (result) {
                                navContext.maybePop();
                              } else {
                                Toaster.show('שגיאה בעת שמירת האירוע');
                                return;
                              }
                            } else {
                              final edited = apprentice.events.firstWhere(
                                (element) => element.id == event.id,
                              );
                              final result = await notifier.editEvent(
                                apprenticeId: apprentice.id,
                                event: edited.copyWith(
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  dateTime: selectedDatetime
                                          .value?.millisecondsSinceEpoch ??
                                      0,
                                ),
                              );

                              if (result) {
                                navContext.maybePop();
                              } else {
                                Toaster.show('שגיאה בעת שמירת האירוע');
                                return;
                              }
                            }
                          },
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
        _Card(
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
        const _Card(
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
        _Card(
          title: 'משפחה',
          trailing: user.role == Role.ahraiTohnit
              ? IconButton(
                  icon: const Icon(
                    FluentIcons.add_circle_24_regular,
                    color: AppColors.blue02,
                  ),
                  onPressed: () => Toaster.unimplemented(),
                )
              : null,
          child: ListView.separated(
            controller: ScrollController(),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: apprentice.contacts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text.rich(
                  TextSpan(
                    style: TextStyles.s14w400,
                    children: [
                      TextSpan(
                        text: apprentice.contacts[index].relationship,
                        style: const TextStyle(
                          color: AppColors.gray5,
                        ),
                      ),
                      const TextSpan(text: '\t'),
                      TextSpan(
                        text: apprentice.contacts[index].fullName,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: Text(
                        apprentice.contacts[index].phone,
                        style: TextStyles.s14w400.copyWith(
                          color: AppColors.gray2,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (user.role == Role.ahraiTohnit) ...[
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
                        onPressed: () => Toaster.unimplemented(),
                        icon: const Icon(FluentIcons.chat_24_regular),
                      ),
                      const SizedBox(width: 4),
                      _RowIconButton(
                        icon: Assets.icons.whatsapp.svg(
                          height: 20,
                        ),
                        onPressed: () => Toaster.unimplemented(),
                      ),
                      const SizedBox(width: 4),
                      _RowIconButton(
                        onPressed: () => Toaster.unimplemented(),
                        icon: const Icon(FluentIcons.call_24_regular),
                      ),
                      const SizedBox(width: 4),
                      _RowIconButton(
                        onPressed: () => Toaster.unimplemented(),
                        icon: const Icon(FluentIcons.mail_24_regular),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        _Card(
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
                data: apprentice.highSchoolRavMelamed,
              ),
            ],
          ),
        ),
        _Card(
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

class _Card extends StatelessWidget {
  const _Card({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 24,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyles.s20w400.copyWith(
                      color: AppColors.gray2,
                    ),
                  ),
                  const Spacer(),
                  trailing ?? const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.apprentice,
  });

  final ApprenticeDto apprentice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kTextTabBarHeight + 24),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: ColoredBox(
          color: AppColors.blue08,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: 120,
                child: Stack(
                  children: [
                    if (apprentice.avatar.isEmpty)
                      const CircleAvatar(
                        radius: 120,
                        backgroundColor: AppColors.grey6,
                        child: Icon(
                          FluentIcons.person_24_filled,
                          size: 16,
                          color: Colors.white,
                        ),
                      )
                    else
                      CircleAvatar(
                        radius: 120,
                        backgroundImage: CachedNetworkImageProvider(
                          apprentice.avatar,
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.blue08,
                        ),
                        onPressed: () => Toaster.unimplemented(),
                        icon: const Icon(FluentIcons.edit_24_regular),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${apprentice.firstName} ${apprentice.lastName}',
                style: TextStyles.s24w600,
              ),
              const SizedBox(width: 2),
              Text(
                apprentice.phone,
                style: TextStyles.s16w400cGrey2.copyWith(
                  color: AppColors.gray5,
                ),
              ),
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
                          builder: (_) => const _MissingInformationDialog(),
                        );

                        return;
                      }

                      final url = Uri.tryParse('tel:${apprentice.phone}') ??
                          Uri.parse('');

                      if (!await launchUrl(url)) {
                        throw Exception('לא ניתן להתקשר למספר זה');
                      }
                    },
                  ),
                  _ActionButton(
                    text: 'וואטסאפ',
                    icon: Assets.icons.whatsapp.svg(
                      height: 20,
                    ),
                    onPressed: () => Toaster.unimplemented(),
                  ),
                  _ActionButton(
                    text: 'SMS',
                    icon: const Icon(FluentIcons.chat_24_regular),
                    onPressed: () => Toaster.unimplemented(),
                  ),
                  _ActionButton(
                    text: 'דיווח',
                    icon: const Icon(FluentIcons.clipboard_task_24_regular),
                    onPressed: () => Toaster.unimplemented(),
                  ),
                ],
              ),
            ],
          ),
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
