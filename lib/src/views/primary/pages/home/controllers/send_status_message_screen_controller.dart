import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'send_status_message_screen_controller.g.dart';

@Riverpod(
  dependencies: [
    StorageService,
    DioService,
  ],
)
class SendStatusMsgScreenController extends _$SendStatusMsgScreenController {
  @override
  FutureOr<void> build() async {
    return null;
  }

  FutureOr<bool> sendMsgPerPersona({
    required List<UserRole> roles,
    required MessageMethod method,
    required String content,
    required String subject,
    required List<String> attachments,
  }) async {
    try {
      final result = await ref.read(dioServiceProvider).post(
        Consts.postMessageSendPerPersona,
        data: {
          "created_by_id":
              ref.read(storageServiceProvider.notifier).getUserPhone(),
          "icon": method.postType,
          "content": content,
          "subject": subject,
          "roles": roles.map((e) => e.val.toString()).toList(),
          'attachments': attachments,
        },
      );

      if (result.data['result'] == 'success') {
        return true;
      }
    } catch (e) {
      Logger().e('failed to send msg per persona', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }
}
