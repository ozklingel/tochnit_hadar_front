import 'package:flutter/material.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';

class AcceptCancelButtons extends StatelessWidget {
  const AcceptCancelButtons({
    super.key,
    this.okText = 'שליחה',
    this.cancelText = 'ביטול',
    this.onPressedOk,
    this.onPressedCancel,
  });

  final String okText;
  final String cancelText;
  final VoidCallback? onPressedOk;
  final VoidCallback? onPressedCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LargeFilledRoundedButton(
            label: okText,
            onPressed: onPressedOk,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: LargeFilledRoundedButton.cancel(
            label: cancelText,
            onPressed: onPressedCancel ?? () => Toaster.unimplemented(),
          ),
        ),
      ],
    );
  }
}
