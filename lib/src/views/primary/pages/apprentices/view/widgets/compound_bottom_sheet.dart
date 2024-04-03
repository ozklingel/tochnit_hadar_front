import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/functions/launch_url.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<PopupMenuItem<dynamic>> getApprenticeCardPopupItems({
  required BuildContext context,
  required PersonaDto apprentice,
}) {
  return [
    PopupMenuItem(
      child: const Text('להתקשר'),
      onTap: () => launchCall(phone: apprentice.phone),
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
      onTap: () => PersonaDetailsRouteData(id: apprentice.id).push(context),
    ),
  ];
}

class CompoundBottomSheet extends HookConsumerWidget {
  const CompoundBottomSheet({
    super.key,
    required this.compound,
  });

  final CompoundDto compound;

  @override
  Widget build(BuildContext context, ref) {
    final apprentices = ref
            .watch(personasControllerProvider)
            .valueOrNull
            ?.where(
              (element) => element.militaryCompoundId == compound.id,
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
                      data: compound.name,
                    ),
                    const SizedBox(height: 12),
                    DetailsRowItem(
                      label: 'כתובת',
                      data: compound.address,
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
                    name: apprentices[index].fullName,
                    isSelected: selectedIds.value.contains(compound.id),
                    onLongPress: () {
                      if (selectedIds.value.contains(compound.id)) {
                        final newList = selectedIds;
                        newList.value.remove(compound.id);
                        selectedIds.value = [
                          ...newList.value,
                        ];
                      } else {
                        selectedIds.value = [
                          ...selectedIds.value,
                          compound.id,
                        ];
                      }
                    },
                    onTap: () =>
                        PersonaDetailsRouteData(id: apprentices[index].id)
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
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(text: 'ניווט אל הכתובת:'),
                                      const TextSpan(text: ' '),
                                      TextSpan(text: compound.address),
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
                                        onPressed: () => launchGoogleMaps(
                                          lat: compound.lat.toString(),
                                          lng: compound.lng.toString(),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      LargeFilledRoundedButton(
                                        label: 'Waze',
                                        textStyle: TextStyles.s16w500cGrey2,
                                        onPressed: () => launchWaze(
                                          lat: compound.lat.toString(),
                                          lng: compound.lng.toString(),
                                        ),
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
