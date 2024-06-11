import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/apprentices_status_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/apprentice_status.dto.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/export_excel_bar.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/institutions_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum _SortBy {
  scoreLowToHigh,
  scoreHightoLow,
  abc,
}

class PersonaPerformanceScreen extends HookConsumerWidget {
  const PersonaPerformanceScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context, ref) {
    final selectedPerformanceItem = useState('');
    final institutions = ref.watch(getInstitutionsProvider).valueOrNull ?? [];
    final screenController =
        ref.watch(apprenticesStatusControllerProvider).valueOrNull ??
            const ApprenticeStatusDto();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          title,
          style: TextStyles.s20w500,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            // TODO(noga)
            onPressed: () => selectedPerformanceItem.value.isEmpty
                ? Navigator.of(context).pop()
                : selectedPerformanceItem.value = '',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Text(subtitle),
          const ExportToExcelBar(),
          Expanded(
            child: AnimatedSwitcher(
              duration: Consts.defaultDurationXL,
              child: selectedPerformanceItem.value.isEmpty
                  ? InstitutionsView(
                      items: screenController.items,
                      institutions: institutions,
                      selectedItem: const ApprenticeStatusItemDto(),
                      onTap: (val) => selectedPerformanceItem.value = val.id,
                    )
                  : const _PerformanceBody(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceBody extends HookConsumerWidget {
  const _PerformanceBody();

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
            child: ListView(),
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
