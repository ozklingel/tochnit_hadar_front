import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';

void showMissingInfoDialog(BuildContext context) => showDialog(
      context: context,
      builder: (_) => const MissingInformationDialog(),
    );

class MissingInformationDialog extends StatelessWidget {
  const MissingInformationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: SizedBox(
        height: 320,
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
                      'אין אפשרות לשמור את השינויים,'
                      ' '
                      'אנא מלא את הפרטים בשדות החובה.',
                      textAlign: TextAlign.center,
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
    );
  }
}
