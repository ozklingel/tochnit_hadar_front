import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/core/utils/functions/launch_url.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
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
    final auth = ref.watch(authServiceProvider).valueOrNull ?? const AuthDto();
    final messages = ref.watch(messagesControllerProvider).valueOrNull ?? [];
    final message = messages.firstWhere(
      (element) => element.id == id,
      orElse: () => const MessageDto(),
    );

    final isEditable = message.type == MessageType.draft ||
        message.dateTime.asDateTime.isAfter(DateTime.now());

    useEffect(
      () {
        ref.read(messagesControllerProvider.notifier).setToReadStatus(message);

        return null;
      },
      [auth],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          message.type == MessageType.customerService
              ? 'פרטי פניית שירות'
              : 'פרטי הודעה',
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            child: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              if (message.type == MessageType.customerService) ...[
                if (RegExp(r'^5\d{8}$').hasMatch(message.from)) ...[
                  PopupMenuItem(
                    child: const Text('להתקשר'),
                    onTap: () => launchCall(phone: message.from),
                  ),
                  PopupMenuItem(
                    child: const Text('שליחת וואטסאפ'),
                    onTap: () => launchWhatsapp(phone: message.from),
                  ),
                  PopupMenuItem(
                    child: const Text('שליחת SMS'),
                    onTap: () => launchSms(phone: [message.from]),
                  ),
                  PopupMenuItem(
                    child: const Text('פרופיל אישי'),
                    onTap: () => PersonaDetailsRouteData(id: message.to.first)
                        .push(context),
                  ),
                ],
              ],
              if (auth.role != UserRole.melave) ...[
                if (isEditable)
                  PopupMenuItem(
                    child: const Text('עריכה'),
                    onTap: () =>
                        EditMessageRouteData(id: id).pushReplacement(context),
                  ),
                PopupMenuItem(
                  child: const Text('שכפול'),
                  onTap: () =>
                      DupeMessageRouteData(id: id).pushReplacement(context),
                ),
              ],
              if (auth.role == UserRole.melave || isEditable)
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
            ],
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
