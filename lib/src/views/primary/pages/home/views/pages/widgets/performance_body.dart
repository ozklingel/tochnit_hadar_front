import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum _SortBy {
  scoreLowToHigh,
  scoreHightoLow,
  abc,
}

class PerformanceBody extends HookConsumerWidget {
  const PerformanceBody({
    super.key,
    // required this.institutionId,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context, ref) {
    final sortBy = useState(_SortBy.scoreLowToHigh);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: SearchBar(
                  backgroundColor: WidgetStatePropertyAll(AppColors.blue07),
                  elevation: WidgetStatePropertyAll(0),
                  leading: Icon(FluentIcons.navigation_24_regular),
                  trailing: [Icon(FluentIcons.search_24_regular)],
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () async {
                  final result = await showDialog<_SortBy?>(
                    context: context,
                    builder: (context) => _SortByDialog(
                      initialVal: sortBy.value,
                    ),
                  );

                  if (result == null) return;
                  sortBy.value = result;
                },
                icon: Transform.scale(
                  scaleX: -1,
                  child: const Icon(
                    FluentIcons.arrow_sort_down_lines_24_regular,
                    color: AppColors.grey2,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class _SortByDialog extends HookWidget {
  const _SortByDialog({
    required this.initialVal,
  });

  final _SortBy initialVal;

  @override
  Widget build(BuildContext context) {
    final sortVal = useState(initialVal);

    return Dialog(
      child: SizedBox(
        height: 240,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            runSpacing: 8,
            runAlignment: WrapAlignment.center,
            children: [
              const Text(
                'מיין לפי',
                style: TextStyles.s16w400cGrey5,
              ),
              RadioListTile(
                value: _SortBy.scoreLowToHigh,
                groupValue: sortVal.value,
                onChanged: (_) =>
                    Navigator.of(context).pop(_SortBy.scoreLowToHigh),
                title: const Text('ציון: מהנמוך אל הגבוה'),
              ),
              RadioListTile(
                value: _SortBy.scoreHightoLow,
                groupValue: sortVal.value,
                onChanged: (_) =>
                    Navigator.of(context).pop(_SortBy.scoreHightoLow),
                title: const Text('ציון: מהגבוה אל הנמוך'),
              ),
              RadioListTile(
                value: _SortBy.abc,
                groupValue: sortVal.value,
                onChanged: (_) => Navigator.of(context).pop(_SortBy.abc),
                title: const Text('א-ב'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
