import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/messages_controller.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/widgets/message_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class MessageDetailsScreen extends HookConsumerWidget {
  const MessageDetailsScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider).valueOrNull ?? const UserDto();
    final messages = ref.watch(messagesControllerProvider).valueOrNull ?? [];
    final message = messages.firstWhere(
      (element) => element.id == id,
      orElse: () => const MessageDto(),
    );

    useEffect(
      () {
        if (user.role == UserRole.melave) {
          ref
              .read(messagesControllerProvider.notifier)
              .setToReadStatus(message);
        }

        return null;
      },
      [user],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('פרטי הודעה'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            child: const Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                if (user.role != UserRole.melave)
                  if (message.type == MessageType.draft ||
                      message.dateTime.asDateTime.isAfter(DateTime.now()))
                    PopupMenuItem(
                      child: const Text('עריכה'),
                      onTap: () =>
                          EditMessageRouteData(id: id).pushReplacement(context),
                    ),
                if (user.role != UserRole.melave)
                  PopupMenuItem(
                    child: const Text('שכפול'),
                    onTap: () =>
                        DupeMessageRouteData(id: id).pushReplacement(context),
                  ),
                if (user.role == UserRole.melave ||
                    message.type == MessageType.draft ||
                    message.dateTime.asDateTime.isAfter(DateTime.now()))
                  PopupMenuItem(
                    value: 'delete',
                    child: const Text('מחיקה'),
                    onTap: () async {
                      final navContext = Navigator.of(context);

                      final result = await ref
                          .read(messagesControllerProvider.notifier)
                          .deleteMessage(id);

                      if (result) {
                        navContext.pop();
                      } else {
                        Logger().w('failed to pop on deleted msg');
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
