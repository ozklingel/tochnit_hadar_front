import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/functions/launch_url.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<PopupMenuItem<dynamic>> getApprenticeCardPopupItems({
  required BuildContext context,
  required ApprenticeDto apprentice,
}) {
  return [
    PopupMenuItem(
      child: const Text('להתקשר'),
      onTap: () => launchPhone(phone: apprentice.phone),
    ),
    PopupMenuItem(
      child: const Text('שליחת וואטסאפ'),
      onTap: () => launchWhatsapp(phone: apprentice.phone),
    ),
    PopupMenuItem(
      child: const Text('שליחת SMS'),
      onTap: () => launchSms(phone: apprentice.phone),
    ),
    PopupMenuItem(
      child: const Text('דיווח'),
      onTap: () => Toaster.unimplemented(),
    ),
    PopupMenuItem(
      child: const Text('פרופיל אישי'),
      onTap: () => ApprenticeDetailsRouteData(id: apprentice.id).push(context),
    ),
  ];
}

class CompoundBottomSheet extends HookConsumerWidget {
  const CompoundBottomSheet({
    super.key,
    required this.e,
  });

  final CompoundDto e;

  @override
  Widget build(BuildContext context, ref) {
    final apprentices = ref
            .watch(apprenticesControllerProvider)
            .valueOrNull
            ?.where(
              (element) => element.militaryCompoundId == e.id,
            )
            .toList() ??
        [];

    final selectedIds = useState(<String>[]);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      expand: false,
      snap: true,
      snapSizes: const [
        0.4,
        0.6,
        0.8,
      ],
      builder: (context, scrollController) => DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'פרטים',
                          style: TextStyles.s20w400,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'פרטי הבסיס',
                      style: TextStyles.s16w400cGrey2,
                    ),
                    const SizedBox(height: 12),
                    DetailsRowItem(
                      label: 'שם הבסיס',
                      data: e.name,
                    ),
                    const SizedBox(height: 12),
                    DetailsRowItem(
                      label: 'כתובת',
                      data: e.latLng.toString(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          const Text(
                            'רשימת חניכים',
                            style: TextStyles.s16w400cGrey2,
                          ),
                          const Spacer(),
                          if (selectedIds.value.length == 1)
                            PopupMenuButton(
                              icon: const Icon(
                                FluentIcons.more_vertical_24_regular,
                              ),
                              offset: const Offset(0, 40),
                              itemBuilder: (context) =>
                                  getApprenticeCardPopupItems(
                                context: context,
                                apprentice: apprentices.firstWhere(
                                  (element) =>
                                      selectedIds.value.first == element.id,
                                ),
                              ),
                            )
                          else if (selectedIds.value.length > 1) ...[
                            IconButton(
                              onPressed: () => Toaster.unimplemented(),
                              icon: const Icon(FluentIcons.chat_24_regular),
                            ),
                            IconButton(
                              onPressed: () => Toaster.unimplemented(),
                              icon: const Icon(
                                FluentIcons.clipboard_task_24_regular,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: apprentices.length,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => ListTileWithTagsCard(
                    name: e.name,
                    isSelected: selectedIds.value.contains(e.id),
                    onLongPress: () {
                      if (selectedIds.value.contains(e.id)) {
                        final newList = selectedIds;
                        newList.value.remove(e.id);
                        selectedIds.value = [
                          ...newList.value,
                        ];
                      } else {
                        selectedIds.value = [
                          ...selectedIds.value,
                          e.id,
                        ];
                      }
                    },
                    onTap: () =>
                        ApprenticeDetailsRouteData(id: apprentices[index].id)
                            .go(context),
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: LargeFilledRoundedButton(
                    label: 'נווט',
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            height: 260,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () =>
                                        Navigator.of(context).maybePop(),
                                  ),
                                ),
                                const Text(
                                  'ניווט',
                                  style: TextStyles.s24w400,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                const Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'ניווט אל הכתובת:'),
                                      TextSpan(text: ' '),
                                      TextSpan(text: ''),
                                    ],
                                  ),
                                  style: TextStyles.s16w400cGrey2,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'בחר אפליקציה לפתיחה:',
                                  style: TextStyles.s16w300cGray2,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      LargeFilledRoundedButton(
                                        label: 'Google Maps',
                                        textStyle: TextStyles.s16w500cGrey2,
                                        onPressed: () =>
                                            Toaster.unimplemented(),
                                      ),
                                      const SizedBox(width: 12),
                                      LargeFilledRoundedButton(
                                        label: 'Waze',
                                        textStyle: TextStyles.s16w500cGrey2,
                                        onPressed: () =>
                                            Toaster.unimplemented(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
