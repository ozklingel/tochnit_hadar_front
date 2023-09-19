import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/messages_controller.dart';
import 'package:hadar_program/src/views/primary/pages/messages/widgets/message_widget.dart';
import 'package:hadar_program/src/views/widgets/loading_widget.dart';
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
              loading: () => const Center(child: LoadingWidget()),
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
