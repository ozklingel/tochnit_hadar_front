import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';

enum ApiResponse {
  success,
  partialSuccess,
  failure,
}

typedef ShowError = bool;

Future<T?> showFancyCustomDialogUploadExcel<T>({
  required BuildContext context,
  required ApiResponse apiResponse,
  required String error,
}) {
  return showDialog<T?>(
    context: context,
    useRootNavigator: true,
    builder: (BuildContext context) => _Dialog(
      apiResponse: apiResponse,
      error: error,
    ),
  );
}

class _Dialog extends StatelessWidget {
  const _Dialog({
    required this.apiResponse,
    required this.error,
  });

  final ApiResponse apiResponse;
  final String error;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
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
            apiResponse == ApiResponse.success
                ? Expanded(
                    child: Assets.illustrations.clap.svg(),
                  )
                : Expanded(
                    child: Assets.illustrations.thinking.svg(),
                  ),
            const SizedBox(height: 24),
            apiResponse == ApiResponse.success
                ? Text(
                    error,
                    textAlign: TextAlign.center,
                    style: TextStyles.s20w500,
                  )
                : const Text(
                    'ישנם שגיאות בקובץ',
                    textAlign: TextAlign.center,
                    style: TextStyles.s20w500,
                  ),
            const SizedBox(height: 24),
            Row(
              //rossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                apiResponse == ApiResponse.success
                    ? const Text(
                        '',
                        textAlign: TextAlign.center,
                        style: TextStyles.s20w500,
                      )
                    : TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
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
                    final navContext = Navigator.of(context);
                    navContext.pop();
                    const HomeRouteData().go(navContext.context);
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
    );
  }
}
