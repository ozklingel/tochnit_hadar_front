import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/api/messegaes_form/get_messages.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_message_controller.g.dart';

@Riverpod(
  dependencies: [
    GetMessages,
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
}
