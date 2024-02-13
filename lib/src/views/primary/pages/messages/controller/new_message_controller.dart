import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/api/messegaes_form/get_messages.dart';
import 'package:hadar_program/src/services/api/user_profile_form/my_apprentices.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_message_controller.g.dart';

@Riverpod(
  dependencies: [
    GetApprentices,
  ],
)
class NewMessageController extends _$NewMessageController {
  @override
  FutureOr<MessageDto> build({
    required String id,
  }) async {
    final messages = await ref.watch(getMessagesProvider.future);

    final filtered = messages.singleWhere(
      (element) => element.id == id,
      orElse: () => const MessageDto(),
    );

    return filtered;
  }

  Future<bool> sendMessage(MessageDto msg) async {
    try {
      await ref.read(dioServiceProvider).post(
        Consts.addMessage,
        data: {
          'created_by_id': ref.read(storageProvider.notifier).getUserPhone(),
          'created_for_id': ref.read(storageProvider.notifier).getUserPhone(),
          'subject': msg.title,
          'content': msg.content,
          'attachments': msg.attachments,
          'type': msg.type,
          'icon': msg.icon,
        },
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
