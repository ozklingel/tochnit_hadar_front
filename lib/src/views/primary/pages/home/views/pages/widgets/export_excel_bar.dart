import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/apprentices_status_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/success_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExportToExcelBar extends HookConsumerWidget {
  const ExportToExcelBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final selectedDate = useState(DateTime.now());

    return Row(
      children: [
        TextButton(
          onPressed: () async {
            final result = await ref
                .read(apprenticesStatusControllerProvider.notifier)
                .export();

            if (result && context.mounted) {
              showFancyCustomDialog(context);
            }
          },
          child: const Text(
            'ייצוא לאקסל',
            style: TextStyles.s14w400cBlue2,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () => showDatePicker(
            context: context,
            firstDate: DateTime.fromMillisecondsSinceEpoch(0),
            lastDate: DateTime.now(),
          ),
          style: TextButton.styleFrom(),
          icon: Text(
            selectedDate.value.asDayMonthYearShortSlash,
            style: TextStyles.s14w300cGray2,
          ),
          label: const RotatedBox(
            quarterTurns: 1,
            child: Icon(Icons.chevron_left),
          ),
        ),
      ],
    );
  }
}
