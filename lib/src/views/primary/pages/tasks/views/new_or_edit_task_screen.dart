import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/controller/tasks_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/dialogs/pick_date_and_time_dialog.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewOrEditTaskScreen extends HookConsumerWidget {
  const NewOrEditTaskScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, ref) {
    final task =
        (ref.watch(tasksControllerProvider).valueOrNull ?? []).singleWhere(
      orElse: () => const TaskDto(),
      (element) => element.id == id,
    );

    // Logger().d(task.dateTime);

    final titleController = useTextEditingController(
      text: task.event == TaskType.none ? '' : task.event.name,
    );
    final detailsTextController = useTextEditingController(text: task.details);
    final frequencyController = useState(
      task.frequencyMeta == TaskFrequencyMeta.unknown
          ? TaskFrequencyMeta.once
          : task.frequencyMeta,
    );
    final dateTimeController = useState<DateTime?>(
      task.dateTime.isEmpty ? null : task.dateTime.asDateTime,
    );
    useListenable(titleController);
    useListenable(detailsTextController);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('הוספת משימה'),
        actions: const [
          CloseButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputFieldContainer(
                isRequired: true,
                label: 'המשימה',
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'המשימה',
                    hintStyle: TextStyles.s16w400cGrey5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              InputFieldContainer(
                label: 'פרטים',
                child: TextField(
                  controller: detailsTextController,
                  minLines: 8,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    hintText: 'פרטים',
                    hintStyle: TextStyles.s16w400cGrey5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () async {
                    final result = await showPickDateAndTimeDialog<DateTime?>(
                      context,
                      onTap: () => Toaster.show('submit2???'),
                      initVal: dateTimeController.value,
                    );

                    if (result == null) {
                      return;
                    }

                    dateTimeController.value = result;
                  },
                  label: Text(
                    (dateTimeController.value
                                ?.isAtSameMomentAs(DateTime.now()) ??
                            false)
                        ? 'הוספת תזמון'
                        : dateTimeController.value.asTimeAgoDayCutoff,
                    style: TextStyles.s18w400cBlue02,
                  ),
                  icon: const Icon(
                    FluentIcons.timer_24_regular,
                    color: AppColors.blue02,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () async {
                    final result = await showDialog<TaskFrequencyMeta?>(
                      context: context,
                      builder: (context) {
                        return _PickFrequencyDialog(
                          initFrequency: frequencyController.value,
                        );
                      },
                    );

                    if (result == null) {
                      return;
                    }

                    frequencyController.value = result;
                  },
                  label: Text(
                    frequencyController.value == TaskFrequencyMeta.once
                        ? 'חד פעמי'
                        : frequencyController.value.name,
                    style: TextStyles.s18w400cBlue02,
                  ),
                  icon: const Icon(
                    FluentIcons.arrow_rotate_counterclockwise_24_regular,
                    color: AppColors.blue02,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 46,
                child: LargeFilledRoundedButton(
                  label: 'שמירה',
                  onPressed: titleController.text.isEmpty ||
                          detailsTextController.text.isEmpty ||
                          (dateTimeController.value?.isBefore(DateTime.now()) ??
                              false)
                      ? null
                      : () async {
                          final providerNotifier =
                              ref.read(tasksControllerProvider.notifier);

                          final newTask = task.copyWith(
                            dateTime:
                                dateTimeController.value?.toIso8601String() ??
                                    DateTime.now().toIso8601String(),
                            title: titleController.text,
                            details: detailsTextController.text,
                            frequencyMeta: frequencyController.value,
                          );

                          final result = task.id.isEmpty
                              ? await providerNotifier.create(
                                  apprenticeId: '',
                                  task: newTask,
                                )
                              : await providerNotifier.edit(newTask);

                          if (!result) {
                            Toaster.error('error creating or updating task');
                          }
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickFrequencyDialog extends HookWidget {
  const _PickFrequencyDialog({
    this.initFrequency = TaskFrequencyMeta.once,
  });

  final TaskFrequencyMeta initFrequency;

  @override
  Widget build(BuildContext context) {
    final selectedFrequency = useState(initFrequency);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 360,
        width: 160,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'תדירות',
                style: TextStyles.s16w400cGrey5,
              ),
              RadioListTile(
                value: TaskFrequencyMeta.once,
                groupValue: selectedFrequency.value,
                onChanged: (val) => _handleSelectFreq(
                  navState: Navigator.of(context),
                  freq: val!,
                ),
                fillColor: MaterialStateColor.resolveWith(
                  (states) => AppColors.blue02,
                ),
                title: const Text(
                  'חד פעמי',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
              RadioListTile(
                value: TaskFrequencyMeta.daily,
                groupValue: selectedFrequency.value,
                onChanged: (val) => _handleSelectFreq(
                  navState: Navigator.of(context),
                  freq: val!,
                ),
                fillColor: MaterialStateColor.resolveWith(
                  (states) => AppColors.blue02,
                ),
                title: const Text(
                  'מידי יום',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
              RadioListTile(
                value: TaskFrequencyMeta.weekly,
                groupValue: selectedFrequency.value,
                onChanged: (val) => _handleSelectFreq(
                  navState: Navigator.of(context),
                  freq: val!,
                ),
                fillColor: MaterialStateColor.resolveWith(
                  (states) => AppColors.blue02,
                ),
                title: const Text(
                  'מידי שבוע',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
              RadioListTile(
                value: TaskFrequencyMeta.monthly,
                groupValue: selectedFrequency.value,
                onChanged: (val) => _handleSelectFreq(
                  navState: Navigator.of(context),
                  freq: val!,
                ),
                fillColor: MaterialStateColor.resolveWith(
                  (states) => AppColors.blue02,
                ),
                title: const Text(
                  'מידי חודש',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
              RadioListTile(
                value: TaskFrequencyMeta.yearly,
                groupValue: selectedFrequency.value,
                onChanged: (val) => _handleSelectFreq(
                  navState: Navigator.of(context),
                  freq: val!,
                ),
                fillColor: MaterialStateColor.resolveWith(
                  (states) => AppColors.blue02,
                ),
                title: const Text(
                  'מידי שנה',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
              // TODO(noga-dev): come back to this once oz implements it
              IgnorePointer(
                child: Opacity(
                  opacity: 0.3,
                  child: RadioListTile(
                    value: TaskFrequencyMeta.custom,
                    groupValue: selectedFrequency.value,
                    onChanged: (val) async {
                      final navContext = Navigator.of(context);

                      final result = await navContext.push(
                        MaterialPageRoute(
                          builder: (context) => const _CustomFrequencyPage(),
                        ),
                      );

                      if (result == null) {
                        return;
                      }

                      _handleSelectFreq(
                        navState: navContext,
                        freq: val!,
                      );
                    },
                    fillColor: MaterialStateColor.resolveWith(
                      (states) => AppColors.blue02,
                    ),
                    title: const Text(
                      'בהתאמה אישית',
                      style: TextStyles.s16w400cGrey2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSelectFreq({
    required NavigatorState navState,
    required TaskFrequencyMeta freq,
  }) {
    navState.pop(freq);
  }
}

enum _EndFrequencyValue {
  never,
  onSpecificDate,
  afterXIterations,
}

class _CustomFrequencyPage extends HookWidget {
  const _CustomFrequencyPage();

  @override
  Widget build(BuildContext context) {
    final endFrequencyOn = useState(_EndFrequencyValue.never);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('תדירות מותאמת אישית'),
        actions: const [
          CloseButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const InputFieldContainer(
              label: 'חזרה כל',
              child: Row(
                children: [
                  SizedBox(width: 20),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '1',
                        hintStyle: TextStyles.s16w400cGrey5,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          borderSide: BorderSide(
                            width: 2,
                            color: AppColors.grey5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 120,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'שבועות',
                        hintStyle: TextStyles.s16w400cGrey5,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          borderSide: BorderSide(
                            width: 2,
                            color: AppColors.grey5,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(
                            FluentIcons.chevron_down_24_regular,
                            color: AppColors.shades500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Divider(color: AppColors.blue07),
            ),
            InputFieldContainer(
              label: 'חזרה בימים',
              child: Wrap(
                spacing: 6,
                children: ['א', 'ב', 'ג', 'ד', 'ה', 'ו', 'ש']
                    .map(
                      (day) => ActionChip(
                        label: Text(day),
                        labelStyle: TextStyles.s14w400cBlue2,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: const BorderSide(
                            color: AppColors.blue06,
                          ),
                        ),
                        onPressed: () => Toaster.unimplemented(),
                      ),
                    )
                    .toList(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Divider(color: AppColors.blue07),
            ),
            InputFieldContainer(
              label: 'סיום',
              child: Column(
                children: [
                  RadioListTile(
                    value: _EndFrequencyValue.never,
                    groupValue: endFrequencyOn.value,
                    title: const Text(
                      'אף פעם',
                      style: TextStyles.s16w400cGrey2,
                    ),
                    onChanged: (val) => Toaster.unimplemented(),
                  ),
                  RadioListTile(
                    value: _EndFrequencyValue.onSpecificDate,
                    groupValue: endFrequencyOn.value,
                    title: Row(
                      children: [
                        const Text(
                          'ב',
                          style: TextStyles.s16w400cGrey2,
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: DateTime.now().asDayMonthYearShortSlash,
                              hintStyle: TextStyles.s16w400cGrey5,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(24),
                                ),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: AppColors.grey5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onChanged: (val) => Toaster.unimplemented(),
                  ),
                  RadioListTile(
                    value: _EndFrequencyValue.afterXIterations,
                    groupValue: endFrequencyOn.value,
                    title: const Row(
                      children: [
                        Text(
                          'אחרי',
                          style: TextStyles.s16w400cGrey2,
                        ),
                        SizedBox(width: 12),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '1',
                              hintStyle: TextStyles.s16w400cGrey5,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(24),
                                ),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: AppColors.grey5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'חזרות',
                          style: TextStyles.s16w400cGrey2,
                        ),
                      ],
                    ),
                    onChanged: (val) => Toaster.unimplemented(),
                  ),
                ],
              ),
            ),
            const Spacer(),
            LargeFilledRoundedButton(
              label: 'שמירה',
              onPressed: () => Toaster.unimplemented(),
            ),
          ],
        ),
      ),
    );
  }
}
