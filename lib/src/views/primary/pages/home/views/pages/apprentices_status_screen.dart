// ignore_for_file: unused_element

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/apprentices_status_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/apprentice_status.dto.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/send_status_messagecreen.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ApprenticesStatusScreen extends HookConsumerWidget {
  const ApprenticesStatusScreen({
    super.key,
    required this.title,
    required this.isExtended,
    required this.initIndex,
  });

  final String title;
  final bool isExtended;
  final int initIndex;

  @override
  Widget build(BuildContext context, ref) {
    final screenController =
        ref.watch(apprenticesStatusControllerProvider).valueOrNull ??
            const ApprenticeStatusDto();
    final tabController = useTabController(
      initialLength: 3,
      initialIndex: initIndex,
    );
    final selectedApprenticeStatusItem =
        useState(const ApprenticeStatusItemDto());
    final selectedDate = useState(DateTime.now());
    useListenable(tabController);

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
            onPressed: () => selectedApprenticeStatusItem.value.id.isEmpty
                ? Navigator.of(context).pop()
                : selectedApprenticeStatusItem.value =
                    const ApprenticeStatusItemDto(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (selectedApprenticeStatusItem.value.id.isNotEmpty)
              Text(
                selectedApprenticeStatusItem.value.name,
                style: TextStyles.s24w500cGrey2,
              ),
            Row(
              children: [
                TextButton(
                  onPressed: () => ref
                      .read(apprenticesStatusControllerProvider.notifier)
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
            const SizedBox(height: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isExtended)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.shades300,
                        ),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TabBar(
                          controller: tabController,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelStyle: TextStyles.s16w500cBlue2,
                          unselectedLabelStyle: TextStyles.s16w400cGrey2,
                          splashBorderRadius: BorderRadius.circular(36),
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.blue06,
                          ),
                          tabs: const [
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text("כללי"),
                              ),
                            ),
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text("שיחות"),
                              ),
                            ),
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text("מפגשים"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    isExtended
                        ? tabController.index == 0
                            ? 'חניכים עם ציון כללי- לא תקין'
                            : tabController.index == 1
                                ? 'חניכים שעברו מעל 45 יום משיחה איתם'
                                : 'חניכים שעברו מעל 60 יום ממפגש איתם'
                        : 'חניכים שלא נוצר איתם קשר מעל 100 יום',
                    style: TextStyles.s16w500cGrey2,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'סה”כ ${screenController.total}',
                        style: TextStyles.s14w300cGray5,
                      ),
                      if (selectedApprenticeStatusItem.value.id.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          FluentIcons.arrow_trending_24_regular,
                          color: AppColors.green1,
                        ),
                        const SizedBox(width: 2),
                        const Text('2%'),
                      ],
                    ],
                  ),
                  if (selectedApprenticeStatusItem.value.id.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.blue04,
                            ),
                          ),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SendStatusMessagecreen(),
                            ),
                          ),
                          child: const Text(
                            'שליחת הודעה ',
                            style: TextStyles.s14w300cBlue2,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Expanded(
                    child: selectedApprenticeStatusItem.value.id.isEmpty
                        ? _InstitutionsView(
                            selectedItem: selectedApprenticeStatusItem.value,
                            items: screenController.items,
                            onTap: (apprentice) =>
                                selectedApprenticeStatusItem.value = apprentice,
                          )
                        : TabBarView(
                            controller: tabController,
                            children: const [
                              _PersonasView(
                                personas: [],
                              ),
                              _PersonasView(
                                personas: [],
                              ),
                              _PersonasView(
                                personas: [],
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonasView extends StatelessWidget {
  const _PersonasView({
    super.key,
    required this.personas,
  });

  final List<PersonaDto> personas;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: personas
          .map(
            (e) => ListTileWithTagsCard(
              avatar: e.avatar,
              name: e.fullName,
              onlineStatus: e.callStatus,
              tags: const [
                'עברו 78 ימים מהשיחה האחרונה',
              ],
            ),
          )
          .toList(),
    );
  }
}

class _InstitutionsView extends StatelessWidget {
  const _InstitutionsView({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onTap,
  });

  final ApprenticeStatusItemDto selectedItem;
  final List<ApprenticeStatusItemDto> items;
  final void Function(ApprenticeStatusItemDto apprentice) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 6),
      itemBuilder: (context, index) => items
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    Consts.defaultBoxShadow,
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    onTap: () => onTap(e),
                    title: Row(
                      children: [
                        Text(
                          e.name,
                          style: TextStyles.s18w500cGray1,
                        ),
                        const Spacer(),
                        Text(
                          '${e.value} חניכים',
                          style: TextStyles.s14w400cGrey1,
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList()[index],
    );
  }
}
