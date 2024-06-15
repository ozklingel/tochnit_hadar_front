import 'package:flutter/material.dart';

import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../services/routing/go_router_provider.dart';

void showFancyCustomDialog(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) => const _FancyDialog(),
    );

class _FancyDialog extends StatelessWidget {
  const _FancyDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.close),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Assets.illustrations.clap.svg(),
              ),
              const SizedBox(height: 24),
              const Text(
                'המתנה סומנה כנשלחה',
                textAlign: TextAlign.center,
                style: TextStyles.s20w500,
              ),
              const SizedBox(height: 24),
              const Text(
                'יישר כח!',
                textAlign: TextAlign.center,
                style: TextStyles.s16w400cGrey2,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    const HomeRouteData().go(context);
                  },
                  child: Text(
                    'חזרה לעמוד הבית',
                    style: TextStyles.s14w500.copyWith(
                      color: AppColors.blue02,
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
}
