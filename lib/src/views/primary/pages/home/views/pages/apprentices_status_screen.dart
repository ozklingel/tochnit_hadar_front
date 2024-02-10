// ignore_for_file: unused_element

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/send_message_screen.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ApprenticesStatusScreen extends HookConsumerWidget {
  const ApprenticesStatusScreen({
    super.key,
    required this.title,
    required this.isExtended,
  });

  final String title;
  final bool isExtended;

  @override
  Widget build(BuildContext context, ref) {
    final apprentices =
        ref.watch(apprenticesControllerProvider).valueOrNull ?? [];
    final tabController = useTabController(initialLength: 3);
    final selectedApprentice = useState(const ApprenticeDto());
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
            onPressed: () => selectedApprentice.value.id.isEmpty
                ? Navigator.of(context).pop()
                : selectedApprentice.value = const ApprenticeDto(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (selectedApprentice.value.id.isNotEmpty)
              Text(
                selectedApprentice.value.fullName,
                style: TextStyles.s24w500cGrey2,
              ),
            Row(
              children: [
                TextButton(
                  onPressed: () => Toaster.unimplemented(),
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
                      const Text(
                        'סה”כ 64',
                        style: TextStyles.s14w300cGray5,
                      ),
                      if (selectedApprentice.value.id.isNotEmpty) ...[
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
                  if (selectedApprentice.value.id.isNotEmpty) ...[
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
                              builder: (context) => const SendMessageScreen(),
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
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        _TabView(
                          selectedApprentice: selectedApprentice.value,
                          apprentices: apprentices,
                          onTap: (apprentice) =>
                              selectedApprentice.value = apprentice,
                        ),
                        _TabView(
                          selectedApprentice: selectedApprentice.value,
                          apprentices: apprentices,
                          onTap: (apprentice) =>
                              selectedApprentice.value = apprentice,
                        ),
                        _TabView(
                          selectedApprentice: selectedApprentice.value,
                          apprentices: apprentices,
                          onTap: (apprentice) =>
                              selectedApprentice.value = apprentice,
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

class _TabView extends StatelessWidget {
  const _TabView({
    super.key,
    required this.apprentices,
    required this.selectedApprentice,
    required this.onTap,
  });

  final ApprenticeDto selectedApprentice;
  final List<ApprenticeDto> apprentices;
  final void Function(ApprenticeDto apprentice) onTap;

  @override
  Widget build(BuildContext context) {
    return selectedApprentice.id.isEmpty
        ? ListView.separated(
            itemCount: apprentices.length,
            separatorBuilder: (context, index) => const SizedBox(height: 6),
            itemBuilder: (context, index) => apprentices
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
                                e.fullName,
                                style: TextStyles.s18w500cGray1,
                              ),
                              const Spacer(),
                              const Text(
                                '12 חניכים',
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
          )
        : ListView(
            children: apprentices
                .map(
                  (e) => ListTileWithTagsCard(
                    avatar: e.avatar,
                    name: e.fullName,
                    onlineStatus: e.onlineStatus,
                    tags: const [
                      'עברו 78 ימים מהשיחה האחרונה',
                    ],
                  ),
                )
                .toList(),
          );
  }
}
