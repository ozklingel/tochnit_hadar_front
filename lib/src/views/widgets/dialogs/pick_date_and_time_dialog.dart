import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/widgets/buttons/accept_cancel_buttons.dart';

showPickDateAndTimeDialog<T>(
  BuildContext context, {
  VoidCallback? onTap,
}) =>
    showDialog<T>(
      context: context,
      builder: (context) {
        return _PickDateAndTimeDialog(
          onTap: onTap ?? () => Toaster.show('EMPTY???'),
        );
      },
    );

class _PickDateAndTimeDialog extends HookWidget {
  const _PickDateAndTimeDialog({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedDateTime = useState<DateTime?>(null);
    final selectedTimeOfDay = useState<TimeOfDay?>(null);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 300,
        width: 160,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'בחירת תאריך ושעה',
                style: TextStyles.s20w400,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 42,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.shades300,
                    ),
                  ),
                  onPressed: () async {
                    final result = await showDatePicker(
                      context: context,
                      initialDate: selectedDateTime.value ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(
                        const Duration(days: 365 * 10),
                      ),
                    );

                    if (result != null) {
                      selectedDateTime.value = result;
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        selectedDateTime.value?.asDayMonthYearShortDot ??
                            'בחירת תאריך',
                        style: TextStyles.s16w400cGrey5,
                      ),
                      const Spacer(),
                      const Icon(
                        FluentIcons.calendar_24_regular,
                        color: Colors.black,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 42,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.shades300,
                    ),
                  ),
                  onPressed: () async {
                    final result = await showTimePicker(
                      context: context,
                      initialTime: selectedTimeOfDay.value ?? TimeOfDay.now(),
                    );

                    if (result != null) {
                      selectedTimeOfDay.value = result;
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        selectedTimeOfDay.value?.format(context) ?? 'בחירת שעה',
                        style: TextStyles.s16w400cGrey5,
                      ),
                      const Spacer(),
                      const Icon(
                        FluentIcons.chevron_down_24_regular,
                        color: Colors.black,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 46,
                child: AcceptCancelButtons(
                  onPressedCancel: () => Navigator.of(context).pop(),
                  onPressedOk: () {
                    if (selectedDateTime.value == null ||
                        selectedTimeOfDay.value == null) {
                      return;
                    }

                    Navigator.of(context).pop(
                      DateTime(
                        selectedDateTime.value!.year,
                        selectedDateTime.value!.month,
                        selectedDateTime.value!.day,
                        selectedTimeOfDay.value!.hour,
                        selectedTimeOfDay.value!.minute,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
