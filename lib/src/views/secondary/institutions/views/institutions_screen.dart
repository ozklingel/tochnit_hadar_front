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
    final sortBy = useState(SortBy.fromA2Z);
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
                    final result = await showDialog<SortBy?>(
                      context: context,
                      builder: (context) => _SortDialog(
                        initialVal: sortBy.value,
                      ),
                    );

                    switch (result) {
                      case SortBy.fromA2Z:
                        sortBy.value = SortBy.fromA2Z;
                        ref
                            .read(institutionsControllerProvider.notifier)
                            .sortBy(SortBy.fromA2Z);
                        break;
                      case SortBy.scoreLow2High:
                        sortBy.value = SortBy.scoreLow2High;
                        ref
                            .read(institutionsControllerProvider.notifier)
                            .sortBy(SortBy.scoreLow2High);
                        break;
                      case SortBy.scoreHigh2Low:
                        sortBy.value = SortBy.scoreHigh2Low;
                        ref
                            .read(institutionsControllerProvider.notifier)
                            .sortBy(SortBy.scoreHigh2Low);
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
                                '${e.hanihim.length} חניכים',
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

class _SortDialog extends HookWidget {
  const _SortDialog({
    super.key,
    required this.initialVal,
  });

  final SortBy initialVal;

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
                value: SortBy.fromA2Z,
                groupValue: sortVal.value,
                onChanged: (_) => Navigator.of(context).pop(SortBy.fromA2Z),
                title: const Text('א-ב'),
              ),
              RadioListTile(
                value: SortBy.scoreLow2High,
                groupValue: sortVal.value,
                onChanged: (_) =>
                    Navigator.of(context).pop(SortBy.scoreLow2High),
                title: const Text('ציון מוסד- נמוך אל הגבוה'),
              ),
              RadioListTile(
                value: SortBy.scoreHigh2Low,
                groupValue: sortVal.value,
                onChanged: (_) =>
                    Navigator.of(context).pop(SortBy.scoreHigh2Low),
                title: const Text('ציון מוסד- גבוה אל הנמוך'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
