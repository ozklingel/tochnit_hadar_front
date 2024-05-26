import 'package:flutter/material.dart';

import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../services/routing/go_router_provider.dart';

void showFancyCustomDialogAddGift(BuildContext context, bool isSucces) {
  var fancyDialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
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
              child: Assets.illustrations.twoThumbsUp.svg(),
            ),
            const SizedBox(height: 24),
            const Text(
              'ישנם שגיאות בקובץ',
              textAlign: TextAlign.center,
              style: TextStyles.s20w500,
            ),
            const SizedBox(height: 24),
            Row(
              //rossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    const HomeRouteData().go(context);
                    Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'הראה שגיאות',
                      style: TextStyles.s14w500.copyWith(
                        color: AppColors.blue02,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    const HomeRouteData().go(context);
                    Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
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
          ],
        ),
      ),
    ),
  );
  showDialog(context: context, builder: (BuildContext context) => fancyDialog);
}
