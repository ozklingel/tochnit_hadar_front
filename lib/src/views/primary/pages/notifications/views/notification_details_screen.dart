import 'package:flutter/material.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/messages_controller.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/widgets/message_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageDetailsScreen extends ConsumerWidget {
  const MessageDetailsScreen({
    super.key,
    required this.messageId,
  });

  final String messageId;

  @override
  Widget build(BuildContext context, ref) {
    final message = ref.watch(
      messagesControllerProvider.select(
        (val) {
          return val.value!.firstWhere(
            (element) => element.id == messageId,
            orElse: () => const MessageDto(),
          );
        },
      ),
    );

    final navContext = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('פרטי הודעה'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            child: const Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 'delete',
                  child: const Text('מחק הודעה'),
                  onTap: () async {
                    final result = await ref
                        .read(messagesControllerProvider.notifier)
                        .deleteMessage(messageId);

                    if (result) {
                      navContext.pop();
                    }
                  },
                ),
              ];
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: MessageWidget.expanded(
        message: message,
      ),
    );
  }
}
