import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago/timeago.dart';

class ReportCard extends ConsumerWidget {
  const ReportCard({
    super.key,
    required this.report,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  final ReportDto report;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context, ref) {
    final apprentices = (ref
                .watch(
                  personasControllerProvider,
                )
                .valueOrNull ??
            [])
        .where(
          (element) => report.recipients.contains(element.id),
        )
        .toList();

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: Consts.defaultDurationM,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue08 : Colors.white,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            onLongPress: onLongPress,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.grey6,
                        child: Icon(
                          FluentIcons.person_24_filled,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 264,
                        child: Text(
                          apprentices
                              .map(
                                (a) => '${a.firstName} ${a.lastName}',
                              )
                              .join(', '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.s18w500cGray1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      style: TextStyles.s14w400,
                      children: [
                        TextSpan(
                          text: report
                              .creationDate.asDateTime.asDayMonthYearShortDot,
                        ),
                        const TextSpan(text: ', '),
                        TextSpan(
                          text: format(
                            report.creationDate.asDateTime,
                            locale: Localizations.localeOf(
                              context,
                            ).languageCode,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    report.event.name,
                    style: TextStyles.s16w400cGrey2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
