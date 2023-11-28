import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/messages_controller.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/widgets/message_widget.dart';
import 'package:hadar_program/src/views/widgets/states/empty_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(messagesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Toaster.unimplemented(),
            icon: const Icon(FluentIcons.search_24_regular),
          ),
          const SizedBox(width: 16),
        ],
        title: const Text('הודעות נכנסות'),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () => ref.refresh(messagesControllerProvider.future),
        child: controller.unwrapPrevious().when(
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
              loading: () => _ResultsBody(
                isLoading: true,
                messages: List.generate(
                  10,
                  (index) => const MessageDto(
                    title: 'titletitletitletitle',
                    content: 'contentcontentcontent',
                    dateTime: 0,
                    attachments: ['attachment'],
                    from: '549247615',
                  ),
                ),
              ),
              data: (messages) => _ResultsBody(
                isLoading: false,
                messages: messages,
              ),
            ),
      ),
    );
  }
}

class _ResultsBody extends StatelessWidget {
  const _ResultsBody({
    required this.messages,
    required this.isLoading,
  });

  final List<MessageDto> messages;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return EmptyState(
        image: Assets.images.noMessages.svg(),
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
              ),
            ),
          )
          .toList(),
    );
  }
}
