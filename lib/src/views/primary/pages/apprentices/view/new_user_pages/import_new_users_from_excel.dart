import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/users_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/accept_cancel_buttons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ImportNewUsersFromExcel extends HookConsumerWidget {
  const ImportNewUsersFromExcel({
    super.key,
    required this.userType,
  });

  final UserRole userType;

  @override
  Widget build(BuildContext context, ref) {
    final isLoading = useState(false);
    final files = useState<List<PlatformFile>>([]);
    final error = useState('');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'העלאת קובץ נתוני חניכים',
          style: TextStyles.s16w400cGrey5,
        ),
        const SizedBox(height: 24),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            isLoading.value = true;

            try {
              final uploadedResult = await FilePicker.platform.pickFiles(
                allowMultiple: false,
                withData: true,
                type: FileType.custom,
                allowedExtensions: [
                  'xlsx',
                ],
              );

              if (uploadedResult != null) {
                files.value = [
                  ...uploadedResult.files,
                ];
              }
            } catch (e) {
              Logger().e('file upload error', error: e);
              Sentry.captureException(e);
              Toaster.error(e);
            }

            isLoading.value = false;
          },
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            color: AppColors.gray5,
            child: SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (files.value.isEmpty) ...[
                      const Icon(FluentIcons.arrow_upload_24_regular),
                      const SizedBox(height: 12),
                      const Text(
                        'הוסף קובץ',
                        style: TextStyles.s14w500,
                      ),
                    ] else ...[
                      Text(
                        files.value.first.name,
                        style: TextStyles.s14w500,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoading.value) ...[
          const SizedBox(height: 12),
          Card(
            color: AppColors.blue08,
            elevation: 0,
            child: ListTile(
              leading: const Icon(FluentIcons.document_pdf_24_regular),
              title: Text(
                files.value.isEmpty
                    ? '[Empty]'
                    : files.value.first.name.toString().split('/').last,
              ),
              subtitle: const LinearProgressIndicator(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  files.value = [];
                  isLoading.value = false;
                },
              ),
            ),
          ),
        ],
        const Spacer(),
        AcceptCancelButtons(
          onPressedOk: () async {
            final createResult = await ref
                .read(
                  usersControllerProvider.notifier,
                )
                .createExcel(
                  file: files.value.first,
                  userType: userType,
                );

            if (createResult.isEmpty) {
              // ok
            } else {
              error.value = createResult;
            }
          },
          onPressedCancel: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
