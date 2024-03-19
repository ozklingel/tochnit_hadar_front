import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/api/messegaes_form/get_messages.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/messages_controller.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/widgets/message_widget.dart';
import 'package:hadar_program/src/views/widgets/appbars/search_appbar.dart';
import 'package:hadar_program/src/views/widgets/states/empty_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MessagesScreen extends HookConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);
    final msgsController = ref.watch(messagesControllerProvider);
    final isSearchOpen = useState(false);
    final searchController = useTextEditingController();
    final tabController = useTabController(initialLength: 3);

    useListenable(searchController);
    useListenable(tabController);

    switch (user.valueOrNull?.role) {
      case UserRole.ahraiTohnit:
        return Scaffold(
          appBar: SearchAppBar(
            controller: searchController,
            isSearchOpen: isSearchOpen,
            text: 'הודעות',
            actions: [
              IconButton(
                onPressed: () => isSearchOpen.value = true,
                icon: const Icon(FluentIcons.search_24_regular),
              ),
              const SizedBox(width: 12),
            ],
            bottom: TabBar(
              controller: tabController,
              labelStyle: TextStyles.s14w400,
              tabs: const [
                Tab(text: 'פניות שירות'),
                Tab(text: 'יוצאות'),
                Tab(text: 'טיוטות'),
              ],
            ),
          ),
          floatingActionButton: (tabController.animation?.value ?? 0) < .5
              ? null
              : user.valueOrNull?.role == UserRole.ahraiTohnit
                  ? FloatingActionButton(
                      onPressed: () =>
                          const NewMessageRouteData().push(context),
                      heroTag: UniqueKey(),
                      shape: const CircleBorder(),
                      backgroundColor: AppColors.blue02,
                      child: const Text(
                        '+',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
          body: RefreshIndicator.adaptive(
            onRefresh: () => ref.refresh(getMessagesProvider.future),
            child: msgsController.when(
              loading: () => ListView(
                children: List.generate(
                  10,
                  (index) => MessageWidget.collapsed(
                    message: MessageDto(
                      title: 'titletitletitletitle',
                      content: 'contentcontentcontent',
                      dateTime: DateTime.now().toIso8601String(),
                      attachments: ['549247615'],
                      from: '549247615',
                    ),
                  ),
                ),
              ),
              error: (error, stack) => Text(error.toString()),
              data: (msgList) {
                final customerService = msgList
                    .where(
                      (element) => element.type == MessageType.customerService,
                    )
                    .toList();

                final sent = msgList
                    .where(
                      (element) => element.type == MessageType.sent,
                    )
                    .toList();

                final draft = msgList
                    .where(
                      (element) => element.type == MessageType.draft,
                    )
                    .toList();

                return TabBarView(
                  controller: tabController,
                  children: [
                    if (customerService.isEmpty)
                      EmptyState(
                        image: Assets.illustrations.pointDown.svg(),
                        topText: 'אין פניות שירות',
                        bottomText: 'פניות שירות מכלל המשתמשים, יופיעו כאן',
                      )
                    else
                      ListView(
                        children: customerService
                            .map(
                              (e) => Skeletonizer(
                                enabled: false,
                                child: MessageWidget.collapsed(
                                  message: e,
                                  hasIcon: true,
                                  backgroundColor: e.allreadyRead
                                      ? Colors.white
                                      : AppColors.blue08,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    if (sent.isEmpty)
                      EmptyState(
                        image: Assets.illustrations.pointDown.svg(),
                        topText: 'אין הודעות יוצאות',
                        bottomText: 'הודעות יוצאות שישלחו, יופיעו כאן',
                      )
                    else
                      ListView(
                        children: msgList
                            .where(
                              (element) => element.type == MessageType.sent,
                            )
                            .map(
                              (e) => Skeletonizer(
                                enabled: false,
                                child: MessageWidget.collapsed(
                                  message: e,
                                  hasIcon: true,
                                  backgroundColor: e.allreadyRead
                                      ? Colors.white
                                      : AppColors.blue08,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    if (draft.isEmpty)
                      EmptyState(
                        image: Assets.illustrations.pointDown.svg(),
                        topText: 'אין טיוטות',
                        bottomText: 'הודעות יוצאות שלא ישלחו , יופיעו כאן',
                      )
                    else
                      ListView(
                        children: msgList
                            .where(
                              (element) => element.type == MessageType.draft,
                            )
                            .map(
                              (e) => Skeletonizer(
                                enabled: false,
                                child: MessageWidget.collapsed(
                                  message: e,
                                  hasIcon: true,
                                  backgroundColor: e.allreadyRead
                                      ? Colors.white
                                      : AppColors.blue08,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      case UserRole.melave:
      default:
        return Scaffold(
          appBar: SearchAppBar(
            controller: searchController,
            isSearchOpen: isSearchOpen,
            text: 'הודעות נכנסות',
            actions: [
              IconButton(
                onPressed: () => isSearchOpen.value = true,
                icon: const Icon(FluentIcons.search_24_regular),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: RefreshIndicator.adaptive(
            onRefresh: () => ref.refresh(getMessagesProvider.future),
            child: msgsController.when(
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
              loading: () => _SearchResultsBody(
                isLoading: true,
                messages: List.generate(
                  10,
                  (index) => MessageDto(
                    title: 'titletitletitletitle',
                    content: 'contentcontentcontent',
                    dateTime: DateTime.now().toIso8601String(),
                    attachments: ['attachment'],
                    from: '549247615',
                  ),
                ),
              ),
              data: (messages) => _SearchResultsBody(
                isLoading: false,
                messages: messages
                    .where(
                      (element) =>
                          element.content
                              .toLowerCase()
                              .contains(searchController.text) ||
                          element.title
                              .toLowerCase()
                              .contains(searchController.text),
                    )
                    .toList(),
              ),
            ),
          ),
        );
    }
  }
}

class _SearchResultsBody extends StatelessWidget {
  const _SearchResultsBody({
    required this.messages,
    required this.isLoading,
  });

  final List<MessageDto> messages;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return EmptyState(
        image: Assets.illustrations.pointDown.svg(),
        topText: 'אין הודעות נכנסות',
        bottomText: 'הודעות נכנסות שישלחו, יופיעו כאן',
      );
    }

    return ListView(
      children: messages
          .map(
            (e) => Skeletonizer(
              enabled: isLoading,
              child: MessageWidget.collapsed(
                message: e,
                backgroundColor:
                    e.allreadyRead ? Colors.white : AppColors.blue08,
              ),
            ),
          )
          .toList(),
    );
  }
}
