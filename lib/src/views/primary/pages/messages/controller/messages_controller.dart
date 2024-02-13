import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/api/messegaes_form/get_messages.dart';
import 'package:hadar_program/src/services/api/user_profile_form/my_apprentices.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'messages_controller.g.dart';

@Riverpod(
  dependencies: [
    Storage,
    DioService,
    GetMessages,
    GetApprentices,
  ],
)
class MessagesController extends _$MessagesController {
  @override
  FutureOr<List<MessageDto>> build() async {
    final messages = await ref.watch(getMessagesProvider.future);

    return messages;
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

      ref.invalidateSelf();

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

      if (result.data['result'] == 'success') {
        ref.invalidateSelf();

        return true;
      }
    } catch (e) {
      Sentry.captureException(e);
    }

    return false;
  }

  Future<List<ApprenticeDto>> searchApprentices(String keyword) async {
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
