import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/dialogs/success_dialog.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GiftScreen extends HookConsumerWidget {
  const GiftScreen({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  Widget build(BuildContext context, ref) {
    final apprentice =
        ref.watch(apprenticesControllerProvider).valueOrNull?.firstWhere(
                  (element) => element.events.any((e) => e.id == eventId),
                ) ??
            const ApprenticeDto();

    final isShowCouponCode = useState(false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('שליחת מתנה'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    FluentIcons.gift_24_regular,
                    color: AppColors.blue05,
                    size: 40,
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          DetailsRowItem(
                            label: 'חניך',
                            data: apprentice.fullName,
                          ),
                          const SizedBox(height: 12),
                          DetailsRowItem(
                            label: 'תאריך יום הולדת',
                            data: apprentice.dateOfBirth.asDateTime.he,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              DetailsRowItem(
                                label: 'בסיס',
                                data: apprentice.militaryCompound.name,
                                dataWidth: 100,
                              ),
                              const Spacer(),
                              Text.rich(
                                TextSpan(
                                  style: TextStyles.s14w400.copyWith(
                                    color: AppColors.gray6,
                                  ),
                                  children: [
                                    const TextSpan(text: 'עודכן'),
                                    const TextSpan(text: ' '),
                                    TextSpan(
                                      text: apprentice.militaryUpdatedDateTime
                                          .asDateTime.asDayMonthYearShort,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              DetailsRowItem(
                                label: 'ת”ז',
                                data: apprentice.teudatZehut,
                                dataWidth: 100,
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(FluentIcons.copy_24_regular),
                                color: AppColors.blue03,
                                onPressed: () async {
                                  await Clipboard.setData(
                                    ClipboardData(text: apprentice.teudatZehut),
                                  );

                                  Toaster.show(
                                    'הקוד הועתק',
                                    align: const Alignment(0, -0.8),
                                  );
                                },
                              ),
                              const SizedBox(width: 4),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const DetailsRowItem(
                                label: 'קוד קופון למתנה',
                                data: '',
                                dataWidth: 0,
                              ),
                              if (isShowCouponCode.value) ...[
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      await Clipboard.setData(
                                        const ClipboardData(text: '12345AAA'),
                                      );

                                      Toaster.show(
                                        'הקוד הועתק',
                                        align: const Alignment(0, -0.8),
                                      );
                                    },
                                    child: const Row(
                                      children: [
                                        Text('12345AAA'),
                                        Spacer(),
                                        Icon(
                                          FluentIcons.copy_24_regular,
                                          color: AppColors.blue03,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ] else
                                TextButton(
                                  child: Text(
                                    'לחץ כאן לקבל קוד קופון למתנה',
                                    style: TextStyles.s14w400.copyWith(
                                      color: AppColors.blue03,
                                    ),
                                  ),
                                  onPressed: () =>
                                      isShowCouponCode.value = true,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'על מנת להשלים את תהליך שליחת המתנה לחניך, יש לעבור לקישור חיצוני של אתר כוורת.'
                    '\n\n'
                    'באתר תידרש להזין:'
                    '\n'
                    '1. פרטים אישיים שלך'
                    '\n'
                    '2. פרטים אישיים של החניך (כולל ת”ז ובסיס)'
                    '\n'
                    '3. ברכת יום הולדת'
                    '\n'
                    '4. הזנה של קוד הקופון למתנה',
                  ),
                  const SizedBox(height: 16),
                  const Text('כבר שלחת לחניך את המתנה? מעולה!'),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: () => Toaster.unimplemented(),
                      child: const Text('לחץ כאן לביטול ההתראות הבאות'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: LargeFilledRoundedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const SuccessDialog(msg: 'המתנה סומנה כנשלחה'),
                    );
                  },
                  label: 'מעבר לאתר כוורת',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
