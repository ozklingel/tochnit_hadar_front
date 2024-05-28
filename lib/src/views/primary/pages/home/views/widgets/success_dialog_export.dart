import 'package:flutter/material.dart';

import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../services/routing/go_router_provider.dart';

void showFancyCustomDialog(BuildContext context) {

    var fancyDialog= Dialog(
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
                child: Assets.illustrations.clap.svg(),
              ),
              const SizedBox(height: 24),
              Text(
                '  נתונים  הוצאו  בהצלחה',
                textAlign: TextAlign.center,
                style: TextStyles.s20w500,
              ),
              const SizedBox(height: 24),
                Text(
                'תמצא אותם בתקיית הורדות',
                textAlign: TextAlign.center,
                style: TextStyles.s20w400,
              ),
            Row(
            //rossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
        
               TextButton(
                onPressed: () {
                  const HomeRouteData().go(context);
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
                   
            ])],
          ),
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => fancyDialog);

}
