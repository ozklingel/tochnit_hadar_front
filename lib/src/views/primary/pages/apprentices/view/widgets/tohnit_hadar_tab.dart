import 'package:collection/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/enums/matsbar_status.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/core/utils/functions/launch_url.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/events_controller.dart';
import 'package:hadar_program/src/views/primary/pages/report/controller/reports_controller.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/accept_cancel_buttons.dart';
import 'package:hadar_program/src/views/widgets/buttons/general_dropdown_button.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/buttons/row_icon_button.dart';
import 'package:hadar_program/src/views/widgets/cards/details_card.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class TohnitHadarTabView extends HookConsumerWidget {
  const TohnitHadarTabView({
    super.key,
    required this.persona,
  });

  final PersonaDto persona;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider).valueOrNull ?? const AuthDto();
    final reports = (ref.watch(reportsControllerProvider).valueOrNull ?? [])
        .where(
          (element) => element.recipients.contains(persona.id),
        )
        .sortedBy<num>(
          (element) => element.dateTime.asDateTime.millisecondsSinceEpoch,
        )
        .reversed
        .take(5);
    final institution =
        (ref.watch(institutionsControllerProvider).valueOrNull ?? [])
            .singleWhere(
      (element) => element.id == persona.institutionId,
      orElse: () => const InstitutionDto(),
    );

    final events = (ref.watch(eventsControllerProvider).valueOrNull ?? [])
        .where(
          (element) =>
              persona.events.where((e2) => e2.id == element.id).isNotEmpty,
        )
        .toList();

    return Column(
      children: [
        _GeneralSection(
          persona: persona,
          institution: institution,
        ),
        if (auth.role.isProgramDirector)
          DetailsCard(
            title: 'מצב”ר',
            trailing: Row(
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: switch (persona.matsbarStatus) {
                    MatsbarStatus.pious ||
                    MatsbarStatus.connected =>
                      AppColors.green1,
                    MatsbarStatus.partial ||
                    MatsbarStatus.leaving =>
                      AppColors.yellow1,
                    MatsbarStatus.disconnected => AppColors.red1,
                    _ => AppColors.grey1,
                  },
                ),
                const SizedBox(width: 6),
                Text(
                  persona.matsbarStatus.name,
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
                ReportsRouteData(apprenticeId: persona.id).push(context),
            child: const Text(
              'הצג הכל',
              style: TextStyles.s12w300cBlue2,
            ),
          ),
          child: Column(
            children: reports
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(e.event.iconData),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '${e.dateTime.asDateTime.he}, ${e.dateTime.asDateTime.asDayMonth}. ${e.dateTime.asDateTime.asTimeAgo}',
                            style: TextStyles.s14w400cGrey5,
                            softWrap: false,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        DetailsCard(
          title: 'אירועים',
          trailing: IconButton(
            icon: const Icon(FluentIcons.add_circle_24_regular),
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                enableDrag: false,
                builder: (context) {
                  return _EventBottomSheet(
                    persona: persona,
                    event: events.firstOrNull ?? const EventDto(),
                  );
                },
              );
            },
          ),
          child: persona.events.isEmpty
              ? const Text(
                  'אין אירועים מוזנים. לחץ כדי להוסיף אירוע',
                  textAlign: TextAlign.start,
                )
              : Builder(
                  builder: (context) {
                    final children = persona.events
                        .sortedBy((element) => element.datetime)
                        .reversed
                        .take(3)
                        .map(
                          (e) => Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  e.eventType,
                                  style: TextStyles.s14w400.copyWith(
                                    color: AppColors.gray5,
                                  ),
                                ),
                              ),
                              Text(
                                e.datetime.asDateTime.asDayMonthYearShortDot,
                                style: TextStyles.s14w400.copyWith(
                                  color: AppColors.gray2,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  RowIconButton(
                                    onPressed: () => showModalBottomSheet(
                                      context: context,
                                      builder: (context) => _EventBottomSheet(
                                        persona: persona,
                                        event: e,
                                      ),
                                    ),
                                    icon:
                                        const Icon(FluentIcons.edit_24_regular),
                                  ),
                                  const SizedBox(width: 4),
                                  RowIconButton(
                                    onPressed: () async {
                                      final result = await ref
                                          .read(
                                            personasControllerProvider.notifier,
                                          )
                                          .deleteEvent(eventId: e.id);

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

class _GeneralSection extends HookConsumerWidget {
  const _GeneralSection({
    required this.persona,
    required this.institution,
  });

  final PersonaDto persona;
  final InstitutionDto institution;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider).valueOrNull ?? const AuthDto();
    final institutions = ref.watch(getInstitutionsProvider).valueOrNull ?? [];
    final isEditMode = useState(false);
    final selectedMentor = useState(persona.thMentor);
    final selectedInstitution = useState(institution);
    final selectedMahzor = useState(persona.thPeriod);
    final ravMelamedYearAName =
        useTextEditingController(text: persona.thRavMelamedYearAName);
    final ravMelamedYearAPhone =
        useTextEditingController(text: persona.thRavMelamedYearAPhone);
    final ravMelamedYearBName =
        useTextEditingController(text: persona.thRavMelamedYearBName);
    final ravMelamedYearBPhone =
        useTextEditingController(text: persona.thRavMelamedYearBPhone);
    final isPaying = useState(persona.isPaying);
    final spiritualStatus = useState(persona.matsbarStatus);

    return DetailsCard(
      title: 'תוכנית הדר',
      trailing: Row(
        children: [
          if (auth.role != UserRole.melave)
            TextButton.icon(
              onPressed: null,
              style: TextButton.styleFrom(
                disabledForegroundColor:
                    persona.isPaying ? AppColors.success600 : AppColors.red1,
              ),
              icon: const Icon(Icons.check),
              label: Text(persona.isPaying ? 'משלם' : 'לא משלם'),
            ),
          if (!auth.role.isProgramDirector)
            IconButton(
              icon: const Icon(FluentIcons.edit_24_regular),
              onPressed: () => isEditMode.value = !isEditMode.value,
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: isEditMode.value
            ? [
                if (auth.role.isProgramDirector)
                  InputFieldContainer(
                    label: 'מקום לימודים',
                    isRequired: true,
                    child: GeneralDropdownButton<InstitutionDto>(
                      value: selectedInstitution.value.name,
                      items: institutions,
                      stringMapper: (e) => e.name,
                      onChanged: (value) {
                        final buttonInstitution =
                            value ?? const InstitutionDto();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('בחירת מלווה\nב$value'),
                              content: GeneralDropdownButton<String>(
                                value: selectedMentor.value,
                                items: buttonInstitution.melavim,
                                onChanged: (value) {
                                  selectedMentor.value = value ?? '';
                                  selectedInstitution.value = buttonInstitution;
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'מחזור',
                  child: GeneralDropdownButton<String>(
                    value: selectedMahzor.value,
                    onChanged: (value) => selectedMahzor.value = value ?? '',
                    items: const [
                      'א',
                      'ב',
                      'ג',
                      'ד',
                      'ה',
                      'ו',
                      'ז',
                      'ח',
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'ר״מ שנה א׳',
                  child: TextField(
                    controller: ravMelamedYearAName,
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'מספר פלאפון ר״מ שנה א׳',
                  child: TextField(
                    controller: ravMelamedYearAPhone,
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'ר״מ שנה ב׳',
                  child: TextField(
                    controller: ravMelamedYearBName,
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'מספר פלאפון ר״מ שנה ב׳',
                  child: TextField(
                    controller: ravMelamedYearBPhone,
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'משלם/לא משלם',
                  child: GeneralDropdownButton<String>(
                    value: isPaying.value ? 'משלם' : 'לא משלם',
                    items: const ['משלם', 'לא משלם'],
                    onChanged: (value) => isPaying.value = value == 'משלם',
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'מצב רוחני - מצב״ר',
                  child: GeneralDropdownButton<MatsbarStatus>(
                    value: spiritualStatus.value.name,
                    onChanged: (value) =>
                        spiritualStatus.value = value ?? MatsbarStatus.unknown,
                    items: MatsbarStatus.values,
                  ),
                ),
                const SizedBox(height: 24),
                AcceptCancelButtons(
                  onPressedCancel: () => isEditMode.value = false,
                  okText: 'שמירה',
                  onPressedOk: () async {
                    final result = await ref
                        .read(personasControllerProvider.notifier)
                        .edit(
                          persona: persona.copyWith(
                            institutionId: selectedInstitution.value.id,
                            thMentor: selectedMentor.value,
                            thPeriod: selectedMahzor.value,
                            thRavMelamedYearAName: ravMelamedYearAName.text,
                            thRavMelamedYearAPhone: ravMelamedYearAPhone.text,
                            thRavMelamedYearBName: ravMelamedYearBName.text,
                            thRavMelamedYearBPhone: ravMelamedYearBPhone.text,
                            isPaying: isPaying.value,
                            matsbarStatus: spiritualStatus.value,
                          ),
                        );

                    if (result) {}
                  },
                ),
              ]
            : [
                DetailsRowItem(
                  label: 'מקום לימודים',
                  data: institution.name,
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'מחזור',
                  data: persona.thPeriod,
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'ר”מ שנה א',
                  data: '',
                  contactName: persona.thRavMelamedYearAName,
                  contactPhone: persona.thRavMelamedYearAPhone.format,
                  onTapPhone: () =>
                      launchCall(phone: persona.thRavMelamedYearAPhone),
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'ר”מ שנה ב',
                  data: '',
                  contactName: persona.thRavMelamedYearBName,
                  contactPhone: persona.thRavMelamedYearBPhone.format,
                  onTapPhone: () =>
                      launchCall(phone: persona.thRavMelamedYearBPhone),
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'מלווה',
                  data: persona.thMentorName,
                ),
              ],
      ),
    );
  }
}

class _EventBottomSheet extends HookConsumerWidget {
  const _EventBottomSheet({
    required this.persona,
    required this.event,
  });

  final PersonaDto persona;
  final EventDto event;

  @override
  Widget build(BuildContext context, ref) {
    final selectedDatetime = useState<DateTime?>(event.datetime.asDateTime);
    final titleController = useTextEditingController(
      text: event.eventType,
      keys: [event],
    );
    final descriptionController = useTextEditingController(
      text: event.description,
      keys: [event],
    );

    useListenable(titleController);
    useListenable(descriptionController);

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
                                isRequired: true,
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
                          onPressed: titleController.text.isEmpty
                              ? null
                              : () async {
                                  final notifier = ref.read(
                                    personasControllerProvider.notifier,
                                  );
                                  final newEvent = event.copyWith(
                                    eventType: titleController.text,
                                    description: descriptionController.text,
                                    datetime: selectedDatetime.value
                                            ?.toIso8601String() ??
                                        DateTime.now().toIso8601String(),
                                  );

                                  final result = event.id.isEmpty
                                      ? await notifier.addEvent(
                                          apprenticeId: persona.id,
                                          event: newEvent,
                                        )
                                      : await notifier.editEvent(
                                          apprenticeId: persona.id,
                                          event: newEvent,
                                        );
                                  if (!result) {
                                    Toaster.show('שגיאה בעת שמירת האירוע');
                                  } else if (context.mounted) {
                                    Navigator.pop(context);
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
