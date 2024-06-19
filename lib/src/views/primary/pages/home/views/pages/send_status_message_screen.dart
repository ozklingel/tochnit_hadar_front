import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/widgets/buttons/accept_cancel_buttons.dart';
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
    final isRakazEshkol = useState(true);
    final isRakazMosad = useState(true);
    final isMelave = useState(true);
    // final attachment = useState<PlatformFile?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('שליחת הודעה'),
        actions: [
          IconButton(
            onPressed: () async => Toaster.unimplemented(),
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
                        if (auth.role == UserRole.ahraiTohnit)
                          CheckboxListTile(
                            value: isRakazEshkol.value,
                            onChanged: (_) =>
                                isRakazEshkol.value = !isRakazEshkol.value,
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
                            value: isRakazMosad.value,
                            onChanged: (_) =>
                                isRakazMosad.value = !isRakazMosad.value,
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
                            value: isMelave.value,
                            onChanged: (_) => isMelave.value = !isMelave.value,
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
                  const InputFieldContainer(
                    label: 'סוג ההודעה',
                    isRequired: true,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'הזן כותרת',
                        hintStyle: TextStyles.s16w400cGrey5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const InputFieldContainer(
                    label: 'כותרת',
                    isRequired: true,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'היקף המשימות בשבוע 24.7.23',
                        hintStyle: TextStyles.s16w400cGrey5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const InputFieldContainer(
                    label: 'תוכן ההודעה',
                    child: TextField(
                      minLines: 8,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText:
                            'שלום, שים לב שבשבוע האחרון היתה ירידה בהיקף המשימות.'
                            ' '
                            'בבקשה תעקוב ותוודא שנוצרו כל הקשרים הנדרשים עם החניכים.',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: AcceptCancelButtons(
                onPressedOk: () => Toaster.unimplemented(),
                onPressedCancel: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
