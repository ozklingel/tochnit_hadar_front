import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/events_controller.dart';
import 'package:hadar_program/src/views/primary/pages/report/controller/reports_controller.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/accept_cancel_buttons.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/buttons/row_icon_button.dart';
import 'package:hadar_program/src/views/widgets/cards/details_card.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TohnitHadarTabView extends HookConsumerWidget {
  const TohnitHadarTabView({
    super.key,
    required this.persona,
  });

  final PersonaDto persona;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider).valueOrNull ?? const AuthDto();
    final reports =
        (ref.watch(reportsControllerProvider).valueOrNull ?? []).where(
      (element) => element.recipients.contains(persona.id),
    );
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
        if (!auth.role.isProgramDirector)
          DetailsCard(
            title: 'דיווחים אחרונים',
            trailing: TextButton(
              onPressed: () =>
                  ReportsRouteData(apprenticeId: persona.id).push(context),
              child: const Text(
                'הצג הכל',
                style: TextStyles.s12w300cGray2,
              ),
            ),
            child: Builder(
              builder: (context) {
                final reports =
                    (ref.watch(reportsControllerProvider).valueOrNull ?? [])
                        .where(
                  (element) => persona.reportsIds.take(3).contains(element.id),
                );

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => reports
                      .map(
                        (e) => _AnnouncementItem(
                          type: e.event,
                          text: TextSpan(
                            children: [
                              TextSpan(text: '${e.dateTime.asDateTime.he}, '),
                              TextSpan(
                                text: '${e.dateTime.asDateTime.asDayMonth}. ',
                              ),
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
        _GeneralSection(
          persona: persona,
          institution: institution,
        ),
        if (auth.role.isProgramDirector) ...[
          DetailsCard(
            title: 'מצב”ר',
            trailing: Row(
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: switch (persona.spiritualStatus) {
                    'אדוק' || 'מחובר' => AppColors.green1,
                    'מחובר חלקית' || 'בשלבי ניתוק' => AppColors.yellow1,
                    'מנותק' => AppColors.red1,
                    _ => AppColors.grey1,
                  },
                ),
                const SizedBox(width: 6),
                Text(
                  persona.spiritualStatus,
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
                  .sortedBy<num>(
                    (element) =>
                        DateTime.parse(element.dateTime).millisecondsSinceEpoch,
                  )
                  .reversed
                  .take(5)
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          if ([
                            Event.call,
                            Event.callParents,
                          ].contains(e.event))
                            const Icon(FluentIcons.call_24_regular)
                          else if ([
                            Event.mosadMeetings,
                            Event.onlineMeeting,
                            Event.offlineMeeting,
                            Event.recurringMeeting,
                            Event.offlineGroupMeeting,
                          ].contains(e.event))
                            const Icon(FluentIcons.people_24_regular)
                          else if ([
                            Event.fiveMessages,
                          ].contains(e.event))
                            const Icon(FluentIcons.chat_24_regular)
                          else
                            const Icon(FluentIcons.question_24_regular),
                          const SizedBox(width: 6),
                          Text(
                            e.dateTime.asDateTime.he,
                            style: TextStyles.s14w400cGrey5,
                          ),
                          const Text(', '),
                          Text(
                            e.dateTime.asDateTime.asDayMonth,
                            style: TextStyles.s14w400cGrey5,
                          ),
                          const Text('.'),
                          const SizedBox(width: 6),
                          Text(
                            e.dateTime.asDateTime.asTimeAgoDayCutoff,
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
                                  e.title,
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
    final selectedInstitution = useState(
      institutions.singleWhere(
        (element) => element.id == persona.institutionId,
        orElse: () => const InstitutionDto(),
      ),
    );
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
    final spiritualStatus = useState(persona.spiritualStatus);

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
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<InstitutionDto>(
                        hint: Text(
                          selectedInstitution.value.name,
                          overflow: TextOverflow.fade,
                        ),
                        style: Theme.of(context).inputDecorationTheme.hintStyle,
                        buttonStyleData: ButtonStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36),
                            border: Border.all(
                              color: AppColors.shade04,
                            ),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.only(right: 8),
                        ),
                        onChanged: (value) => selectedInstitution.value =
                            value ?? const InstitutionDto(),
                        dropdownStyleData: const DropdownStyleData(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.chevron_left,
                                color: AppColors.grey6,
                              ),
                            ),
                          ),
                          openMenuIcon: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Icon(
                                Icons.chevron_left,
                                color: AppColors.grey6,
                              ),
                            ),
                          ),
                        ),
                        items: institutions
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'מחזור',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      hint: Text(
                        selectedMahzor.value,
                        overflow: TextOverflow.fade,
                      ),
                      style: Theme.of(context).inputDecorationTheme.hintStyle,
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          border: Border.all(
                            color: AppColors.shade04,
                          ),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.only(right: 8),
                      ),
                      onChanged: (value) => selectedMahzor.value = value ?? '',
                      dropdownStyleData: const DropdownStyleData(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Icon(
                              Icons.chevron_left,
                              color: AppColors.grey6,
                            ),
                          ),
                        ),
                        openMenuIcon: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Icon(
                              Icons.chevron_left,
                              color: AppColors.grey6,
                            ),
                          ),
                        ),
                      ),
                      items: [
                        'א',
                        'ב',
                        'ג',
                        'ד',
                        'ה',
                        'ו',
                        'ז',
                        'ח',
                      ]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                    ),
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
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<bool>(
                      hint: Text(
                        isPaying.value ? 'משלם' : 'לא משלם',
                        overflow: TextOverflow.fade,
                      ),
                      style: Theme.of(context).inputDecorationTheme.hintStyle,
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          border: Border.all(
                            color: AppColors.shade04,
                          ),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.only(right: 8),
                      ),
                      onChanged: (value) => isPaying.value = value ?? false,
                      dropdownStyleData: const DropdownStyleData(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Icon(
                              Icons.chevron_left,
                              color: AppColors.grey6,
                            ),
                          ),
                        ),
                        openMenuIcon: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Icon(
                              Icons.chevron_left,
                              color: AppColors.grey6,
                            ),
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: true,
                          child: Text('משלם'),
                        ),
                        DropdownMenuItem(
                          value: false,
                          child: Text('לא משלם'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'מצב רוחני - מצב״ר',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      hint: Text(
                        spiritualStatus.value,
                        overflow: TextOverflow.fade,
                      ),
                      style: Theme.of(context).inputDecorationTheme.hintStyle,
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          border: Border.all(
                            color: AppColors.shade04,
                          ),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.only(right: 8),
                      ),
                      onChanged: (value) => spiritualStatus.value = value ?? '',
                      dropdownStyleData: const DropdownStyleData(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Icon(
                              Icons.chevron_left,
                              color: AppColors.grey6,
                            ),
                          ),
                        ),
                        openMenuIcon: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Icon(
                              Icons.chevron_left,
                              color: AppColors.grey6,
                            ),
                          ),
                        ),
                      ),
                      items: [
                        'אדוק',
                        'מחובר',
                        'מחובר חלקית',
                        'בשלבי ניתוק',
                        'מנותק',
                      ]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                // const SizedBox(height: 12),
                // InputFieldContainer(
                //   label: 'מלווה - משויך',
                //   child: DropdownButtonHideUnderline(
                //     child: DropdownButton2<PersonaDto>(
                //       hint: Text(
                //         selectedPersona,
                //         overflow: TextOverflow.fade,
                //       ),
                //       style: Theme.of(context).inputDecorationTheme.hintStyle,
                //       buttonStyleData: ButtonStyleData(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(36),
                //           border: Border.all(
                //             color: AppColors.shade04,
                //           ),
                //         ),
                //         elevation: 0,
                //         padding: const EdgeInsets.only(right: 8),
                //       ),
                //       onChanged: (value) => matsbar.value = value ?? '',
                //       dropdownStyleData: const DropdownStyleData(
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.all(
                //             Radius.circular(16),
                //           ),
                //         ),
                //       ),
                //       iconStyleData: const IconStyleData(
                //         icon: Padding(
                //           padding: EdgeInsets.only(left: 16),
                //           child: RotatedBox(
                //             quarterTurns: 1,
                //             child: Icon(
                //               Icons.chevron_left,
                //               color: AppColors.grey6,
                //             ),
                //           ),
                //         ),
                //         openMenuIcon: Padding(
                //           padding: EdgeInsets.only(left: 16),
                //           child: RotatedBox(
                //             quarterTurns: 3,
                //             child: Icon(
                //               Icons.chevron_left,
                //               color: AppColors.grey6,
                //             ),
                //           ),
                //         ),
                //       ),
                //       items: [
                //         'אדוק',
                //         'מחובר',
                //         'מחובר חלקית',
                //         'בשלבי ניתוק',
                //         'מנותק',
                //       ]
                //           .map(
                //             (e) => DropdownMenuItem(
                //               value: e,
                //               child: Text(e),
                //             ),
                //           )
                //           .toList(),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 24),
                AcceptCancelButtons(
                  onPressedCancel: () => isEditMode.value = false,
                  okText: 'שמירה',
                  onPressedOk: () async {
                    final result = await ref
                        .read(personasControllerProvider.notifier)
                        .edit(
                          persona: persona.copyWith(
                            educationalInstitution:
                                selectedInstitution.value.name,
                            thPeriod: selectedMahzor.value,
                            thRavMelamedYearAName: ravMelamedYearAName.text,
                            thRavMelamedYearAPhone: ravMelamedYearAPhone.text,
                            thRavMelamedYearBName: ravMelamedYearBName.text,
                            thRavMelamedYearBPhone: ravMelamedYearBPhone.text,
                            isPaying: isPaying.value,
                            spiritualStatus: spiritualStatus.value,
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
                  onTapPhone: () async {
                    final phoneCallAction =
                        Uri.parse('tel:${persona.thRavMelamedYearAPhone}');
                    if (await canLaunchUrl(phoneCallAction)) {
                      await launchUrl(phoneCallAction);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'ר”מ שנה ב',
                  data: '',
                  contactName: persona.thRavMelamedYearBName,
                  contactPhone: persona.thRavMelamedYearBPhone.format,
                  onTapPhone: () async {
                    final phoneCallAction =
                        Uri.parse('tel:${persona.thRavMelamedYearBPhone}');
                    if (await canLaunchUrl(phoneCallAction)) {
                      await launchUrl(phoneCallAction);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'מלווה',
                  data: persona.thMentor,
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
      text: event.title,
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
                                    title: titleController.text,
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
                                  if (result && context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },

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
    required this.type,
  });

  final TextSpan text;
  final Event type;

  @override
  Widget build(BuildContext context) {
    final iconData = switch (type) {
      Event.call || Event.callParents => FluentIcons.call_24_regular,
      Event.fiveMessages => FluentIcons.chat_24_regular,
      Event.mosadMeetings ||
      Event.onlineMeeting ||
      Event.offlineMeeting ||
      Event.recurringMeeting ||
      Event.offlineGroupMeeting =>
        FluentIcons.people_24_regular,
      _ => FluentIcons.question_24_regular,
    };
    return Row(
      children: [
        Icon(iconData),
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
