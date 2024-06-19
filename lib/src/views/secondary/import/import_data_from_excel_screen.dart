import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_user_pages/new_persona_appbar.dart';
import 'package:hadar_program/src/views/widgets/buttons/accept_cancel_buttons.dart';
import 'package:hadar_program/src/views/widgets/dialogs/upload_excel_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ImportDataFromExcelScreen extends HookConsumerWidget {
  const ImportDataFromExcelScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.uploadExcel,
  });

  final String title;
  final String subtitle;
  final Future<List<String>> Function(PlatformFile file) uploadExcel;

  @override
  Widget build(BuildContext context, ref) {
    final isLoading = useState(false);
    final uploadedFile = useState<PlatformFile?>(null);
    final errors = useState(<String>[]);

    return Scaffold(
      appBar: NewPersonaAppbar(title: title),
      body: Padding(
        padding: Consts.defaultBodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text(
                    subtitle,
                    style: TextStyles.s16w400cGrey5,
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      isLoading.value = true;
                      errors.value = [];

                      try {
                        final uploadedResult =
                            await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          withData: true,
                          type: FileType.custom,
                          allowedExtensions: [
                            'xlsx',
                          ],
                        );

                        if (uploadedResult != null) {
                          uploadedFile.value = uploadedResult.files.first;
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
                              if (uploadedFile.value == null) ...[
                                const Icon(FluentIcons.arrow_upload_24_regular),
                                const SizedBox(height: 12),
                                const Text(
                                  'הוסף קובץ',
                                  style: TextStyles.s14w500,
                                ),
                              ] else ...[
                                Text(
                                  uploadedFile.value!.name,
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
                        leading:
                            const Icon(FluentIcons.document_pdf_24_regular),
                        title: Text(
                          uploadedFile.value == null
                              ? '[Empty]'
                              : uploadedFile.value!.name
                                  .toString()
                                  .split('/')
                                  .last,
                        ),
                        subtitle: const LinearProgressIndicator(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            uploadedFile.value = null;
                            isLoading.value = false;
                          },
                        ),
                      ),
                    ),
                  ] else if (errors.value.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Card(
                      color: AppColors.failedUpload,
                      elevation: 0,
                      child: ListTile(
                        leading:
                            const Icon(FluentIcons.document_pdf_24_regular),
                        title: Text(
                          uploadedFile.value == null
                              ? '[Empty]'
                              : uploadedFile.value!.name
                                  .toString()
                                  .split('/')
                                  .last,
                        ),
                        subtitle: const Text(
                          'שגיאה בנתוני הקובץ',
                          style: TextStyles.s14w400cRed1,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            uploadedFile.value = null;
                            isLoading.value = false;
                          },
                        ),
                      ),
                    ),
                    for (final error in errors.value)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          tileColor: AppColors.failedUpload,
                          title: Text(error),
                        ),
                      ),
                  ],
                ],
              ),
            ),
            AcceptCancelButtons(
              onPressedOk: uploadedFile.value == null
                  ? null
                  : () async {
                      // if (uploadedFile.value == null) {
                      //   return;
                      // }

                      final response = await uploadExcel(uploadedFile.value!);

                      if (response.isEmpty) {
                        Toaster.success('SUCCESS');
                      } else {
                        if (!context.mounted) {
                          return;
                        }

                        final result =
                            await showFancyCustomDialogUploadExcel<ShowError?>(
                                  context: context,
                                  apiResponse: ApiResponse.partialSuccess,
                                  error: 'ישנם שגיאות בקובץ',
                                ) ??
                                false;

                        if (result) {
                          errors.value = response;
                        }
                      }
                    },
              onPressedCancel: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
