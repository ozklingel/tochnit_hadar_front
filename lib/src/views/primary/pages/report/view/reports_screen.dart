import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/report/controller/reports_controller.dart';
import 'package:hadar_program/src/views/secondary/onboarding/widgets/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/loading_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';

class ReportsScreen extends HookConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final selectedIds = useState(<String>[]);

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (selectedIds.value.isEmpty)
            IconButton(
              onPressed: () => Toaster.unimplemented(),
              icon: const Icon(FluentIcons.search_24_regular),
            )
          else if (selectedIds.value.length == 1) ...[
            IconButton(
              onPressed: () =>
                  ReportEditRouteData(id: selectedIds.value.first).go(context),
              icon: const Icon(
                FluentIcons.edit_24_regular,
                size: 16,
              ),
            ),
            PopupMenuButton(
              icon: const Icon(FluentIcons.more_vertical_24_regular),
              surfaceTintColor: Colors.white,
              offset: const Offset(0, 32),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('שכפול'),
                  onTap: () => Toaster.unimplemented(),
                ),
                PopupMenuItem(
                  child: const Text('עריכה'),
                  onTap: () => ReportEditRouteData(id: selectedIds.value.first)
                      .go(context),
                ),
                PopupMenuItem(
                  child: const Text('מחיקה'),
                  onTap: () => Toaster.unimplemented(),
                ),
                PopupMenuItem(
                  child: const Text('פרופיל אישי'),
                  onTap: () => Toaster.unimplemented(),
                ),
              ],
            ),
          ] else
            IconButton(
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => Dialog(
                    child: SizedBox(
                      height: 360,
                      child: ColoredBox(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Align(
                                alignment: AlignmentDirectional.topEnd,
                                child: IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'מחיקת 2 דיווחים',
                                      style: TextStyles.bodyB4,
                                    ),
                                    TextSpan(text: '\n'),
                                    TextSpan(
                                      text:
                                          'האם אתה מעוניין למחוק את הדיווחים שנבחרו? ',
                                      style: TextStyles.bodyB3,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              LargeFilledRoundedButton(
                                label: 'לא, השאר',
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              const SizedBox(height: 16),
                              LargeFilledRoundedButton(
                                label: 'כן, מחק',
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.blue03,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );

                if (result == null || !result) {
                  return;
                }

                Toaster.unimplemented();
              },
              icon: const Icon(FluentIcons.delete_24_regular),
            ),
          const SizedBox(width: 16),
        ],
        title: const Text('דיווחים'),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.blue02,
        foregroundColor: AppColors.blue06,
        child: const Icon(FluentIcons.add_32_filled),
        onPressed: () => const ReportNewRouteData().go(context),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () => ref.refresh(reportsControllerProvider.future),
        child: ref.watch(reportsControllerProvider).when(
              loading: () => const LoadingWidget(),
              error: (error, s) => CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    child: Center(
                      child: Text(error.toString()),
                    ),
                  ),
                ],
              ),
              data: (reports) {
                if (reports.isEmpty) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Assets.images.noMessages.svg(),
                            const Text(
                              'אין הודעות נכנסות',
                              textAlign: TextAlign.center,
                              style: TextStyles.bodyB41Bold,
                            ),
                            const Text(
                              'הודעות נכנסות שישלחו, יופיעו כאן',
                              textAlign: TextAlign.center,
                              style: TextStyles.bodyB2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                final children = reports
                    .map(
                      (e) => DecoratedBox(
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
                            duration: Consts.kDefaultDurationM,
                            decoration: BoxDecoration(
                              color: selectedIds.value.contains(e.id)
                                  ? AppColors.blue08
                                  : Colors.white,
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () =>
                                  ReportDetailsRouteData(id: e.id).go(context),
                              onLongPress: () {
                                if (selectedIds.value.contains(e.id)) {
                                  final newList = selectedIds;
                                  newList.value.remove(e.id);
                                  selectedIds.value = [...newList.value];
                                } else {
                                  selectedIds.value = [
                                    ...selectedIds.value,
                                    e.id,
                                  ];
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        if (e.apprentices.isEmpty ||
                                            e.apprentices.first.avatar.isEmpty)
                                          const CircleAvatar(
                                            radius: 12,
                                            backgroundColor: AppColors.grey6,
                                            child: Icon(
                                              FluentIcons.person_24_filled,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          )
                                        else
                                          CircleAvatar(
                                            radius: 12,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              e.apprentices.first.avatar,
                                            ),
                                          ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 280,
                                          child: Text(
                                            e.apprentices
                                                .map(
                                                  (a) =>
                                                      '${a.firstName} ${a.lastName}',
                                                )
                                                .join(', '),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyles.reportName,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text.rich(
                                      TextSpan(
                                        style: TextStyles.bodyB2,
                                        children: [
                                          TextSpan(
                                            text: DateFormat('dd.MM.yy')
                                                .format(
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                    e.dateTime,
                                                  ),
                                                )
                                                .toString(),
                                          ),
                                          const TextSpan(text: ', '),
                                          TextSpan(
                                            text: format(
                                              e.dateTime.asDateTime,
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
                                      e.reportEventType.name,
                                      style: TextStyles.bodyB3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList();

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: children.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) => children[index],
                );
              },
            ),
      ),
    );
  }
}
