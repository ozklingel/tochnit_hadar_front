import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InstitutionTypePickerScreen extends HookConsumerWidget {
  const InstitutionTypePickerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final isManual = useState(true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'הוספת מוסד',
          style: TextStyles.s22w500cGrey2,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'בחר את סוג הפעולה',
              style: TextStyles.s12w500cGray5,
            ),
            const SizedBox(height: 12),
            RadioListTile.adaptive(
              value: true,
              groupValue: isManual.value,
              onChanged: (val) => isManual.value = true,
              title: const Text('הזנה ידנית'),
            ),
            RadioListTile.adaptive(
              value: false,
              groupValue: isManual.value,
              onChanged: (val) => isManual.value = false,
              title: const Text('ייבוא נתונים מאקסל'),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: LargeFilledRoundedButton(
                      label: 'הבא',
                      onPressed: () => isManual.value
                          ? const NewInstitutionRouteData().push(context)
                          : const InstitutionFromExcelRouteData().push(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: LargeFilledRoundedButton.cancel(
                      label: 'ביטול',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
