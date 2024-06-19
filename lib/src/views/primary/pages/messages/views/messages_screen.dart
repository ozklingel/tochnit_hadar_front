import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/api/messegaes_form/get_messages.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/messages_controller.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/widgets/message_widget.dart';
import 'package:hadar_program/src/views/widgets/appbars/search_appbar.dart';
import 'package:hadar_program/src/views/widgets/chips/filter_chip.dart';
import 'package:hadar_program/src/views/widgets/states/empty_state.dart';
import 'package:hadar_program/src/views/widgets/states/loading_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum _TagFilter {
  data,
  technical,
  users,
  other,
  all;

  String get name {
    switch (this) {
      case data:
        return 'בעיות נתונים';
      case technical:
        return 'תמיכה טכנית';
      case users:
        return 'משתמשים';
      case other:
        return 'אחר';
      default:
        return 'all';
    }
  }
}

class MessagesScreen extends HookConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);
    final user = auth.valueOrNull ?? const AuthDto();
    final role = user.role;

    if (auth.isLoading) {
      return const LoadingState();
    }

    final msgsController = ref.watch(messagesControllerProvider);
    final msgsControllerState = msgsController.valueOrNull ?? [];
    final isSearchOpen = useState(false);
    final searchController = useTextEditingController();
    final tabController = useTabController(initialLength: 3);
    final filter = useState(_TagFilter.all);

    useListenable(searchController);
    useListenable(tabController);

    final customerService = msgsControllerState
        .where(
      (element) => element.type == MessageType.customerService,
    )
        .where((element) {
      if (filter.value == _TagFilter.all) {
        return true;
      }

      return element.title.toUpperCase().contains(filter.value.name);
    }).where((element) {
      final searchText = searchController.text.toLowerCase();

      if (searchText.isEmpty) {
        return true;
      }

      return element.title.toLowerCase().contains(searchText) ||
          element.content.toLowerCase().contains(searchText) ||
          element.from.toLowerCase().contains(searchText) ||
          element.to.any((e) => e.toLowerCase().contains(searchText));
    }).toList();

    final outgoing = msgsControllerState
        .where(
      (element) => element.type == MessageType.sent,
    )
        .where((element) {
      final searchText = searchController.text.toLowerCase();

      if (searchText.isEmpty) {
        return true;
      }

      return element.title.toLowerCase().contains(searchText) ||
          element.content.toLowerCase().contains(searchText) ||
          element.from.toLowerCase().contains(searchText) ||
          element.to.any((e) => e.toLowerCase().contains(searchText));
    }).toList();

    final draft = msgsControllerState
        .where(
      (element) => element.type == MessageType.draft,
    )
        .where(
      (element) {
        final searchText = searchController.text.toLowerCase();

        if (searchText.isEmpty) {
          return true;
        }

        return element.title.toLowerCase().contains(searchText) ||
            element.content.toLowerCase().contains(searchText) ||
            element.from.toLowerCase().contains(searchText) ||
            element.to.any((e) => e.toLowerCase().contains(searchText));
      },
    ).toList();

    final incoming = msgsControllerState
        .where((element) => element.type == MessageType.incoming)
        .where(
      (element) {
        final searchText = searchController.text.toLowerCase();

        if (searchText.isEmpty) {
          return true;
        }

        return element.content.toLowerCase().contains(searchController.text) ||
            element.title.toLowerCase().contains(searchText) ||
            element.from.toLowerCase().contains(searchText) ||
            element.to.any(
              (e) => e.toLowerCase().contains(searchText),
            );
      },
    ).toList();

    switch (role) {
      case UserRole.ahraiTohnit:
      case UserRole.rakazEshkol:
      case UserRole.rakazMosad:
        return Scaffold(
          appBar: SearchAppBar(
            controller: searchController,
            isSearchOpen: isSearchOpen,
            title: const Text('הודעות'),
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
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: role.isAhraiTohnit
                        ? [
                            const Text('פניות שירות'),
                            if (msgsControllerState.any(
                              (element) =>
                                  !element.allreadyRead &&
                                  element.type == MessageType.customerService,
                            ))
                              const _NewNotifIndicator(),
                          ]
                        : [
                            const Text('נכנסות'),
                            if (msgsControllerState.any(
                              (element) =>
                                  !element.allreadyRead &&
                                  element.type == MessageType.incoming,
                            ))
                              const _NewNotifIndicator(),
                          ],
                  ),
                ),
                const Tab(text: 'יוצאות'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Tab(text: 'טיוטות'),
                    if (msgsControllerState.any(
                      (element) =>
                          !element.allreadyRead &&
                          element.type == MessageType.draft,
                    ))
                      const _NewNotifIndicator(),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: (tabController.animation?.value ?? 0) < .5
              ? null
              : role.isAhraiTohnit
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
            child: TabBarView(
              controller: tabController,
              children: [
                Column(
                  children: [
                    if (role.isAhraiTohnit)
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 52,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            children: msgsController.isLoading
                                ? List.generate(
                                    10,
                                    (index) => MessageWidget.collapsed(
                                      message: MessageDto(
                                        title: 'titletitletitletitle',
                                        content: 'contentcontentcontent',
                                        dateTime:
                                            DateTime.now().toIso8601String(),
                                        attachments: ['549247615'],
                                        from: '549247615',
                                      ),
                                    ),
                                  )
                                : [
                                    FilterChipWidget(
                                      text: _TagFilter.data.name,
                                      isSelected:
                                          filter.value == _TagFilter.data,
                                      onTap: () {
                                        if (filter.value == _TagFilter.data) {
                                          filter.value = _TagFilter.all;
                                        } else {
                                          filter.value = _TagFilter.data;
                                        }
                                      },
                                    ),
                                    FilterChipWidget(
                                      text: _TagFilter.technical.name,
                                      isSelected:
                                          filter.value == _TagFilter.technical,
                                      onTap: () {
                                        if (filter.value ==
                                            _TagFilter.technical) {
                                          filter.value = _TagFilter.all;
                                        } else {
                                          filter.value = _TagFilter.technical;
                                        }
                                      },
                                    ),
                                    FilterChipWidget(
                                      text: _TagFilter.users.name,
                                      isSelected:
                                          filter.value == _TagFilter.users,
                                      onTap: () {
                                        if (filter.value == _TagFilter.users) {
                                          filter.value = _TagFilter.all;
                                        } else {
                                          filter.value = _TagFilter.users;
                                        }
                                      },
                                    ),
                                    FilterChipWidget(
                                      text: _TagFilter.other.name,
                                      isSelected:
                                          filter.value == _TagFilter.other,
                                      onTap: () {
                                        if (filter.value == _TagFilter.other) {
                                          filter.value = _TagFilter.all;
                                        } else {
                                          filter.value = _TagFilter.other;
                                        }
                                      },
                                    ),
                                  ]
                                    .map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: e,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                    Expanded(
                      child: role.isAhraiTohnit
                          ? customerService.isEmpty
                              ? EmptyState(
                                  image: Assets.illustrations.pointDown.svg(),
                                  topText: 'אין פניות שירות',
                                  bottomText:
                                      'פניות שירות מכלל המשתמשים, יופיעו כאן',
                                )
                              : ListView(
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
                                )
                          : incoming.isEmpty
                              ? EmptyState(
                                  image: Assets.illustrations.pointDown.svg(),
                                  topText: 'אין הודעות נכנסות',
                                  bottomText:
                                      'הודעות נכנסות שישלחו, יופיעו כאן',
                                )
                              : ListView(
                                  children: incoming
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
                    ),
                  ],
                ),
                if (outgoing.isEmpty)
                  EmptyState(
                    image: Assets.illustrations.pointDown.svg(),
                    topText: 'אין הודעות יוצאות',
                    bottomText: 'הודעות יוצאות שישלחו, יופיעו כאן',
                  )
                else
                  ListView(
                    children: outgoing
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
                    children: draft
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
            ),
          ),
        );
      case UserRole.melave:
      default:
        return Scaffold(
          appBar: SearchAppBar(
            controller: searchController,
            isSearchOpen: isSearchOpen,
            title: const Text('הודעות נכנסות'),
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
            child: _SearchResultsBody(
              isLoading: msgsController.isLoading,
              messages: msgsController.isLoading
                  ? List.generate(
                      10,
                      (index) => MessageDto(
                        title: 'titletitletitletitle',
                        content: 'contentcontentcontent',
                        dateTime: DateTime.now().toIso8601String(),
                        attachments: ['attachment'],
                        from: '549247615',
                      ),
                    )
                  : incoming,
            ),
          ),
        );
    }
  }
}

class _NewNotifIndicator extends StatelessWidget {
  const _NewNotifIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 4),
      child: CircleAvatar(
        radius: 3,
        backgroundColor: AppColors.blue03,
      ),
    );
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
