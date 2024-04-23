// ignore_for_file: unused_element

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/performance_status_controller.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PerformanceStatusScreen extends HookConsumerWidget {
  const PerformanceStatusScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context, ref) {
    final apprentices = ref.watch(personasControllerProvider).valueOrNull ?? [];
    final selectedDate = useState(DateTime.now());

    const percent = .76;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyles.s20w500,
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () => ref
                    .read(performanceStatusControllerProvider.notifier)
                    .export(),
                child: const Text(
                  'ייצוא לאקסל',
                  style: TextStyles.s14w400cBlue2,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => showDatePicker(
                  context: context,
                  firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                  lastDate: DateTime.now(),
                ),
                style: TextButton.styleFrom(),
                icon: Text(
                  selectedDate.value.asDayMonthYearShortSlash,
                  style: TextStyles.s14w300cGray2,
                ),
                label: const RotatedBox(
                  quarterTurns: 1,
                  child: Icon(Icons.chevron_left),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: LayoutBuilder(
                    builder: (context, constaints) {
                      return SizedBox(
                        width: constaints.maxWidth,
                        child: SearchBar(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateColor.resolveWith(
                            (states) => AppColors.blue07,
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          leading: const Icon(Icons.menu),
                          hintText: 'חיפוש',
                          trailing: const [
                            Icon(Icons.search),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const _SortDialog(),
                  ),
                  icon: const Icon(
                    FluentIcons.arrow_sort_down_lines_24_regular,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: apprentices.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) => ListTileWithTagsCard(
                avatar: apprentices[index].avatar,
                name: apprentices[index].fullName,
                tags: const [
                  'מלווה',
                  'בני דוד עלי',
                  'מחזור ג',
                ],
                onlineStatus: apprentices[index].callStatus,
                trailing: Row(
                  children: [
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          '${(percent * 100).round()}%',
                          style: percent > 75
                              ? TextStyles.s18w400cYellow1
                              : TextStyles.s18w400cRed1,
                        ),
                        const Text(
                          'ציון',
                          style: TextStyles.s12w400cGrey6,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SortDialog extends HookWidget {
  const _SortDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedVal = useState('');

    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: SizedBox(
        height: 220,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'מיין לפי',
                style: TextStyles.s16w400cGrey5,
              ),
              const Spacer(),
              RadioListTile(
                value: 'h2l',
                groupValue: selectedVal.value,
                onChanged: (val) => selectedVal.value = val!,
                title: const Text(
                  'ציון: מהנמוך אל הגבוה',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
              RadioListTile(
                value: 'l2h',
                groupValue: selectedVal.value,
                onChanged: (val) => selectedVal.value = val!,
                title: const Text(
                  'ציון: מהגבוה אל הנמוך',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
              RadioListTile(
                value: 'abc',
                groupValue: selectedVal.value,
                onChanged: (val) => selectedVal.value = val!,
                title: const Text(
                  'א-ב',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
