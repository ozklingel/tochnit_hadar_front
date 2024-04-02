import 'dart:convert';

import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/api/messegaes_form/get_messages.dart';
import 'package:hadar_program/src/services/api/user_profile_form/my_apprentices.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'messages_controller.g.dart';

@Riverpod(
  dependencies: [
    DioService,
    GetMessages,
    GetApprentices,
    StorageService,
    GoRouterService,
  ],
)
class MessagesController extends _$MessagesController {
  @override
  FutureOr<List<MessageDto>> build() async {
    final messages = await ref.watch(getMessagesProvider.future);

    return messages;
  }

  Future<bool> create(MessageDto msg) async {
    Logger().d(msg.to);

    try {
      final result = await ref.read(dioServiceProvider).post(
            Consts.addMessage,
            data: jsonEncode({
              'subject': msg.title,
              'content': msg.content,
              'created_by_id':
                  ref.read(storageServiceProvider.notifier).getUserPhone(),
              'created_for_ids': msg.to,
              'type': msg.type.name,
              'icon': switch (msg.method) {
                MessageMethod.sms => 'PHONE',
                MessageMethod.whatsapp => 'WHATSAPP',
                MessageMethod.system => 'SYSTEM',
                MessageMethod.other => 'UNKNOWN',
              },
              'attachments': msg.attachments,
              // 'icon': msg.icon,
            }),
          );

      if (result.data['result'] == 'success') {
        ref.invalidate(getMessagesProvider);

        ref.read(goRouterServiceProvider).pop();

        return true;
      }
    } catch (e) {
      Logger().e('failed to create msg', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }

  Future<bool> edit(MessageDto msg) async {
    try {
      await ref.read(dioServiceProvider).post(
        Consts.addMessage,
        data: {
          'subject': msg.title,
          'content': msg.content,
          'created_by_id':
              ref.read(storageServiceProvider.notifier).getUserPhone(),
          'created_for_id':
              ref.read(storageServiceProvider.notifier).getUserPhone(),
          'type': msg.type,
          'attachments': msg.attachments,
          'icon': msg.icon,
        },
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setToReadStatus(MessageDto msg) async {
    if (msg.allreadyRead) {
      return true;
    }

    try {
      await ref.read(dioServiceProvider).post(
        Consts.setMessagesWasRead,
        data: {
          'message_id': msg.id,
        },
      );

      ref.invalidate(getMessagesProvider);

      return true;
    } catch (e) {
      Sentry.captureException(e);
      return false;
    }
  }

  Future<bool> deleteMessage(String messageId) async {
    try {
      final result = await ref.read(dioServiceProvider).delete(
        Consts.deleteMessage,
        data: {
          'entityId': messageId,
        },
      );

      // apparently misspelling is intentional
      if (result.data['result'] == 'sucess') {
        ref.invalidate(getMessagesProvider);

        return true;
      }
    } catch (e) {
      Sentry.captureException(e);
    }

    return false;
  }

  Future<List<PersonaDto>> searchApprentices(String keyword) async {
    final apprentices = await ref.read(getApprenticesProvider.future);

    final filtered = apprentices
        .where(
          (element) =>
              element.fullName.toLowerCase().contains(keyword.toLowerCase()),
        )
        .toList();

    return filtered;
  }
}
