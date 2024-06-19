import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/api/export_import/upload_file.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/send_status_message_screen_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/accept_cancel_buttons.dart';
import 'package:hadar_program/src/views/widgets/buttons/general_dropdown_button.dart';
import 'package:hadar_program/src/views/widgets/dialogs/missing_details_dialog.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SendStatusMessagecreen extends HookConsumerWidget {
  const SendStatusMessagecreen({
    super.key,
    required this.recipients,
  });

  final List<String> recipients;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider).valueOrNull ?? const AuthDto();
    final roles = useState(<UserRole>[]);
    final type = useState(MessageMethod.unknown);
    final subject = useTextEditingController();
    final content = useTextEditingController();
    final attachments = useState(<String>[]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('שליחת הודעה'),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                allowMultiple: false,
                withData: true,
              );

              if (result == null) {
                return;
              }

              Toaster.isLoading(true);

              try {
                final uploadUrl = await ref.read(
                  uploadFileProvider(result.files.first).future,
                );

                attachments.value = [
                  uploadUrl,
                  ...attachments.value,
                ];
              } catch (e) {
                Toaster.error(e);
              } finally {
                Toaster.isLoading(false);
              }
            },
            icon: const Icon(FluentIcons.attach_24_regular),
          ),
          // IconButton(
          //   onPressed: () => Toaster.unimplemented(),
          //   icon: const Icon(FluentIcons.more_vertical_24_regular),
          // ),
          const SizedBox(width: 6),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12) - const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    'שליחת הודעה לבעלי התפקידים במוסד',
                    style: TextStyles.s16w400cGrey3,
                  ),
                  const SizedBox(height: 12),
                  InputFieldContainer(
                    label: 'נמענים',
                    isRequired: true,
                    child: Column(
                      children: [
                        if (auth.role.isAhraiTohnit)
                          CheckboxListTile(
                            value: roles.value.contains(UserRole.rakazEshkol),
                            onChanged: (_) => roles.value =
                                roles.value.contains(UserRole.rakazEshkol)
                                    ? [
                                        ...roles.value.whereNot(
                                          (element) => element.isRakazEshkol,
                                        ),
                                      ]
                                    : [
                                        ...roles.value,
                                        UserRole.rakazEshkol,
                                      ],
                            controlAffinity: ListTileControlAffinity.leading,
                            title: const Text(
                              'רכז אשכול',
                              style: TextStyles.s16w400cGrey2,
                            ),
                          ),
                        if ([
                          UserRole.ahraiTohnit,
                          UserRole.rakazEshkol,
                        ].contains(auth.role))
                          CheckboxListTile(
                            value: roles.value.contains(UserRole.rakazMosad),
                            onChanged: (_) => roles.value =
                                roles.value.contains(UserRole.rakazMosad)
                                    ? [
                                        ...roles.value.whereNot(
                                          (element) => element.isRakazMosad,
                                        ),
                                      ]
                                    : [
                                        ...roles.value,
                                        UserRole.rakazMosad,
                                      ],
                            controlAffinity: ListTileControlAffinity.leading,
                            title: const Text(
                              'רכז מוסד',
                              style: TextStyles.s16w400cGrey2,
                            ),
                          ),
                        if ([
                          UserRole.ahraiTohnit,
                          UserRole.rakazEshkol,
                          UserRole.rakazMosad,
                        ].contains(auth.role))
                          CheckboxListTile(
                            value: roles.value.contains(UserRole.melave),
                            onChanged: (_) => roles.value =
                                roles.value.contains(UserRole.melave)
                                    ? [
                                        ...roles.value.whereNot(
                                          (element) => element.isMelave,
                                        ),
                                      ]
                                    : [
                                        ...roles.value,
                                        UserRole.melave,
                                      ],
                            controlAffinity: ListTileControlAffinity.leading,
                            title: const Text(
                              'מלווה',
                              style: TextStyles.s16w400cGrey2,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputFieldContainer(
                    label: 'סוג ההודעה',
                    isRequired: true,
                    child: GeneralDropdownButton<MessageMethod>(
                      value: type.value.isEmpty
                          ? 'בחר סוג הודעה'
                          : type.value.name,
                      onChanged: (p0) =>
                          type.value = p0 ?? MessageMethod.unknown,
                      items: MessageMethod.values
                          .whereNot(
                            (element) => element == MessageMethod.unknown,
                          )
                          .toList(),
                      stringMapper: (p0) => p0.name,
                    ),
                  ),
                  const SizedBox(height: 24),
                  InputFieldContainer(
                    label: 'כותרת',
                    isRequired: true,
                    child: TextField(
                      controller: subject,
                      decoration: const InputDecoration(
                        hintText: 'היקף המשימות בשבוע 24.7.23',
                        hintStyle: TextStyles.s16w400cGrey5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  InputFieldContainer(
                    label: 'תוכן ההודעה',
                    child: TextField(
                      controller: content,
                      minLines: 8,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        hintText:
                            'שלום, שים לב שבשבוע האחרון היתה ירידה בהיקף המשימות.'
                            ' '
                            'בבקשה תעקוב ותוודא שנוצרו כל הקשרים הנדרשים עם החניכים.',
                      ),
                    ),
                  ),
                  if (attachments.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: SizedBox(
                        height: 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (final item in attachments.value)
                              if (item.endsWith('.png') ||
                                  item.endsWith('.jpg') ||
                                  item.endsWith('.jpeg'))
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: item,
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: AcceptCancelButtons(
                onPressedOk: () async {
                  final navContext = Navigator.of(context);

                  if (roles.value.isEmpty ||
                      type.value.isEmpty ||
                      subject.text.isEmpty ||
                      content.text.isEmpty) {
                    showMissingInfoDialog(context);

                    return;
                  }

                  Toaster.isLoading(true);

                  try {
                    final result = await ref
                        .read(sendStatusMsgScreenControllerProvider.notifier)
                        .sendMsgPerPersona(
                          roles: roles.value,
                          method: type.value,
                          subject: subject.text,
                          content: content.text,
                          attachments: attachments.value,
                        );

                    if (result) {
                      navContext.pop();
                    }
                  } catch (e) {
                    Toaster.error(e);
                  } finally {
                    Toaster.isLoading(false);
                  }
                },
                onPressedCancel: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
