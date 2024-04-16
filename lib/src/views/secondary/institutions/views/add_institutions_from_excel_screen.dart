import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/accept_cancel_buttons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AddInstitutionFromExcel extends HookConsumerWidget {
  const AddInstitutionFromExcel({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final isLoading = useState(false);
    final requestResult = useState(true);
    final selectedFile = useState<PlatformFile?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'הוספת משתמשים',
          style: TextStyles.s22w500cGrey2,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'העלאת קובץ נתוני חניכים',
              style: TextStyles.s12w500cGray5,
            ),
            const SizedBox(height: 24),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                isLoading.value = true;

                try {
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    withData: true,
                    type: FileType.custom,
                    allowedExtensions: [
                      'xlsx',
                    ],
                  );

                  if (result != null) {
                    selectedFile.value = result.files.first;
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
                child: const SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FluentIcons.arrow_upload_24_regular),
                        SizedBox(height: 12),
                        Text(
                          'הוסף קובץ',
                          style: TextStyles.s14w500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (selectedFile.value != null)
              ColoredBox(
                color: requestResult.value
                    ? AppColors.blue08
                    : AppColors.failedUpload,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListTile(
                    leading: SvgPicture.string(_excelSvg),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      selectedFile.value!.name,
                      style: TextStyles.s14w500cGrey2,
                    ),
                    subtitle: isLoading.value
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: LinearProgressIndicator(),
                          )
                        : requestResult.value
                            ? null
                            : Text(
                                'שגיאה בנתוני הקובץ',
                                style: TextStyles.s14w400.copyWith(
                                  color: AppColors.red1,
                                ),
                              ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        selectedFile.value = null;
                        requestResult.value = true;
                      },
                    ),
                  ),
                ),
              ),
            const Spacer(),
            AcceptCancelButtons(
              okText: 'שמירה',
              onPressedCancel: () => Navigator.of(context).pop(),
              onPressedOk: selectedFile.value == null
                  ? null
                  : () async {
                      if (selectedFile.value == null) {
                        return;
                      }

                      isLoading.value = true;

                      final result = await ref
                          .read(institutionsControllerProvider.notifier)
                          .addFromExcel(selectedFile.value!);

                      isLoading.value = false;

                      if (result) {
                      } else {
                        requestResult.value = false;
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}

const _excelSvg = '''

<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_4082_43628)">
<path fill-rule="evenodd" clip-rule="evenodd" d="M4.46344 11.1328H18.7889V7.29297H14.4877C14.036 7.29297 13.4072 7.06445 13.1095 6.78516C12.8118 6.50586 12.6307 6.00195 12.6307 5.58008V1.49219H1.69661C1.65914 1.49219 1.62999 1.50977 1.61125 1.52734C1.58002 1.54688 1.5717 1.57227 1.5717 1.60938V22.4004C1.5717 22.4277 1.59043 22.4629 1.60917 22.4805C1.62791 22.5078 1.66746 22.5156 1.69453 22.5156C6.43707 22.5156 13.7882 22.5156 18.664 22.5156C18.7015 22.5156 18.6994 22.498 18.7202 22.4805C18.7493 22.4629 18.7889 22.4258 18.7889 22.4004V20.2207H4.46344C3.60154 20.2207 2.88953 19.5566 2.88953 18.7441V12.6074C2.89161 11.7969 3.59945 11.1328 4.46344 11.1328ZM5.25872 13.7617H6.6515L7.376 14.9414L8.07968 13.7617H9.4558L8.18585 15.6191L9.57655 17.5957H8.15462L7.3531 16.3633L6.54533 17.5957H5.13589L6.54533 15.5977L5.25872 13.7617ZM9.89508 13.7617H11.1567V16.6543H13.1324V17.5977H9.89508V13.7617ZM13.401 16.3281L14.6001 16.2578C14.6251 16.4395 14.6793 16.5781 14.7584 16.6738C14.8895 16.8281 15.0748 16.9062 15.3163 16.9062C15.4954 16.9062 15.6348 16.8672 15.7327 16.7871C15.8305 16.707 15.8784 16.6152 15.8784 16.5117C15.8784 16.4121 15.8326 16.3242 15.741 16.2441C15.6494 16.166 15.4329 16.0918 15.0956 16.0215C14.5419 15.9062 14.1484 15.75 13.9131 15.5566C13.6758 15.3633 13.5571 15.1172 13.5571 14.8184C13.5571 14.6211 13.6175 14.4355 13.7403 14.2617C13.8611 14.0859 14.0443 13.9492 14.2899 13.8477C14.5335 13.748 14.8687 13.6973 15.2955 13.6973C15.8181 13.6973 16.2157 13.7891 16.4905 13.9707C16.7653 14.1523 16.9277 14.4434 16.9797 14.8418L15.7931 14.9082C15.7618 14.7344 15.6952 14.6074 15.5932 14.5293C15.4912 14.4492 15.3517 14.4102 15.1727 14.4102C15.0269 14.4102 14.9145 14.4395 14.8416 14.498C14.7667 14.5566 14.7313 14.627 14.7313 14.7109C14.7313 14.7715 14.7625 14.8262 14.8208 14.875C14.8791 14.9258 15.0207 14.9727 15.2414 15.0156C15.7931 15.127 16.1886 15.2402 16.426 15.3555C16.6654 15.4707 16.8382 15.6113 16.9464 15.7813C17.0547 15.9492 17.1088 16.1387 17.1088 16.3496C17.1088 16.5957 17.036 16.8223 16.8923 17.0293C16.7466 17.2363 16.5446 17.3945 16.2844 17.502C16.0242 17.6094 15.6973 17.6621 15.3017 17.6621C14.6064 17.6621 14.1255 17.5371 13.859 17.2852C13.5863 17.0332 13.4343 16.7148 13.401 16.3281ZM17.3753 13.7617H18.7681L19.4926 14.9414L20.1942 13.7617H21.5703L20.3004 15.6191L21.6911 17.5957H20.2691L19.4676 16.3633L18.6598 17.5957H17.2504L18.6598 15.5977L17.3753 13.7617ZM20.3587 11.1328H22.426C23.292 11.1328 23.9999 11.7988 23.9999 12.6094V18.7461C23.9999 19.5566 23.2899 20.2227 22.426 20.2227H20.3587V22.8691C20.3587 23.1836 20.2233 23.4629 20.0047 23.6699C19.784 23.877 19.4863 24.002 19.1512 24.002C13.0221 24.002 7.36975 24.002 1.20945 24.002C0.874264 24.002 0.576554 23.877 0.355874 23.6699C0.135194 23.4629 0.00195312 23.1836 0.00195312 22.8691V1.14258C0.00195312 0.828125 0.137276 0.548828 0.355874 0.341797C0.576554 0.134766 0.882591 0.00976562 1.20945 0.00976562H13.4343C13.4614 0 13.4905 0 13.5196 0C13.6529 0 13.7882 0.0546875 13.884 0.134766H13.9027C13.9215 0.144531 13.9319 0.152344 13.9506 0.169922L20.1942 6.09961C20.3004 6.19922 20.3774 6.33398 20.3774 6.48633C20.3774 6.53125 20.367 6.56641 20.3587 6.61328V11.1328ZM14.0568 5.46289V1.74609L18.5183 5.98438H14.6126C14.4586 5.98438 14.3253 5.92188 14.2192 5.83203C14.1234 5.74219 14.0568 5.60742 14.0568 5.46289Z" fill="black"/>
</g>
<defs>
<clipPath id="clip0_4082_43628">
<rect width="24" height="24" fill="white"/>
</clipPath>
</defs>
</svg>
''';
