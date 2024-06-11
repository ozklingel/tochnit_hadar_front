import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_status_message_screen_controller.g.dart';

@Riverpod(
  dependencies: [],
)
class SendStatusMsgScreenController extends _$SendStatusMsgScreenController {
  @override
  FutureOr<void> build() async {
    return null;
  }

  FutureOr<bool> sendMsgPerPersona({
    required List<UserRole> roles,
    required String content,
    required String subject,
  }) {
    return false;
  }
}
