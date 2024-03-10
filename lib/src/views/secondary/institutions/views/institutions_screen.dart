// ignore_for_file: unused_element

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InstitutionsScreen extends HookConsumerWidget {
  const InstitutionsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final institutionsController = ref.watch(institutionsControllerProvider);
    final sortBy = useState(SortInstitutionBy.fromA2Z);
    final isSearchActive = useState(false);
    final searchTextEditingController = useTextEditingController();
    useListenable(searchTextEditingController);

    var filtered = (institutionsController.valueOrNull ?? []).where(
      (element) => element.name
          .toLowerCase()
          .contains(searchTextEditingController.text.toLowerCase()),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedSwitcher(
          duration: Consts.defaultDurationM,
          transitionBuilder: (child, animation) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
          child: isSearchActive.value
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SearchBar(
                    controller: searchTextEditingController,
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    leading: IconButton(
                      onPressed: () => isSearchActive.value = false,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    trailing: const [Icon(FluentIcons.search_24_regular)],
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateColor.resolveWith(
                      (states) => AppColors.blue07,
                    ),
                  ),
                )
              : AppBar(
                  title: const Text('מוסדות'),
                  actions: [
                    IconButton(
                      onPressed: () => isSearchActive.value = true,
                      icon: const Icon(FluentIcons.search_24_regular),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => const NewInstitutionRouteData().push(context),
        heroTag: UniqueKey(),
        backgroundColor: AppColors.blue02,
        shape: const CircleBorder(),
        child: const Icon(
          FluentIcons.add_24_regular,
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                TextButton.icon(
                  icon: const Icon(
                    FluentIcons.arrow_sort_down_lines_24_regular,
                    color: AppColors.grey2,
                  ),
                  label: Text(
                    '${filtered.length} מוסדות',
                    style: TextStyles.s14w400cGrey5,
                  ),
                  onPressed: () async {
                    final result = await showDialog<SortInstitutionBy?>(
                      context: context,
                      builder: (context) => _SortByDialog(
                        initialVal: sortBy.value,
                      ),
                    );

                    switch (result) {
                      case SortInstitutionBy.fromA2Z:
                        sortBy.value = SortInstitutionBy.fromA2Z;
                        ref
                            .read(institutionsControllerProvider.notifier)
                            .sortBy(SortInstitutionBy.fromA2Z);
                        break;
                      case SortInstitutionBy.scoreLow2High:
                        sortBy.value = SortInstitutionBy.scoreLow2High;
                        ref
                            .read(institutionsControllerProvider.notifier)
                            .sortBy(SortInstitutionBy.scoreLow2High);
                        break;
                      case SortInstitutionBy.scoreHigh2Low:
                        sortBy.value = SortInstitutionBy.scoreHigh2Low;
                        ref
                            .read(institutionsControllerProvider.notifier)
                            .sortBy(SortInstitutionBy.scoreHigh2Low);
                        break;
                      case null:
                        return;
                    }
                  },
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
          Expanded(
            child: institutionsController.isLoading
                ? const CircularProgressIndicator()
                : ListView(
                    padding: const EdgeInsets.all(24),
                    children: filtered
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTileWithTagsCard(
                              name: e.name,
                              onTap: () => InstitutionDetailsRouteData(id: e.id)
                                  .push(context),
                              tags: [
                                '${e.melavim.length} מלווים',
                                '${e.apprentices.length} חניכים',
                                '${e.score.toInt()} ציון',
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SortByDialog extends HookWidget {
  const _SortByDialog({
    super.key,
    required this.initialVal,
  });

  final SortInstitutionBy initialVal;

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
                value: SortInstitutionBy.fromA2Z,
                groupValue: sortVal.value,
                onChanged: (_) =>
                    Navigator.of(context).pop(SortInstitutionBy.fromA2Z),
                title: const Text('א-ב'),
              ),
              RadioListTile(
                value: SortInstitutionBy.scoreLow2High,
                groupValue: sortVal.value,
                onChanged: (_) =>
                    Navigator.of(context).pop(SortInstitutionBy.scoreLow2High),
                title: const Text('ציון מוסד- נמוך אל הגבוה'),
              ),
              RadioListTile(
                value: SortInstitutionBy.scoreHigh2Low,
                groupValue: sortVal.value,
                onChanged: (_) =>
                    Navigator.of(context).pop(SortInstitutionBy.scoreHigh2Low),
                title: const Text('ציון מוסד- גבוה אל הנמוך'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
