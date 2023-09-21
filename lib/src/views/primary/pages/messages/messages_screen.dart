import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/messages_controller.dart';
import 'package:hadar_program/src/views/primary/pages/messages/widgets/message_widget.dart';
import 'package:hadar_program/src/views/widgets/loading_widget.dart';
import 'package:hadar_program/src/views/widgets/states/empty_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
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
        child: ref.watch(messagesControllerProvider).when(
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
              data: (messages) {
                if (messages.isEmpty) {
                  return EmptyState(
                    image: Assets.images.noMessages.svg(),
                    topText: 'אין הודעות נכנסות',
                    bottomText: 'הודעות נכנסות שישלחו, יופיעו כאן',
                  );
                }

                return ListView(
                  children: messages
                      .map((e) => MessageWidget.collapsed(message: e))
                      .toList(),
                );
              },
            ),
      ),
    );
  }
}
