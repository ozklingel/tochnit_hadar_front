import 'dart:math';

import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messages_controller.g.dart';

@Riverpod(dependencies: [])
class MessagesController extends _$MessagesController {
  @override
  FutureOr<List<MessageDto>> build() async {
    await Future.delayed(const Duration(milliseconds: 200));

    final result1 = Random().nextBool();
    final result2 = Random().nextBool();

    return result1
        ? [
            MessageDto(
              id: '1-1',
              from: const ApprenticeDto(
                firstName: 'יאיר',
                lastName: 'כהן',
              ),
              title: 'כותרת ההודעה',
              content:
                  'תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה',
              attachments: [
                'פרסום מפגש תמוז',
              ],
              dateTimeInMsSinceEpoch: DateTime.now()
                  .subtract(const Duration(minutes: 40))
                  .millisecondsSinceEpoch,
            ),
            MessageDto(
              id: '1-2',
              from: const ApprenticeDto(
                firstName: 'יאיר',
                lastName: 'כהן',
              ),
              title: 'כותרת ההודעה',
              content:
                  'תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה',
              attachments: [],
              dateTimeInMsSinceEpoch: DateTime.now()
                  .subtract(const Duration(minutes: 720))
                  .millisecondsSinceEpoch,
            ),
            MessageDto(
              id: '1-3',
              from: const ApprenticeDto(
                firstName: 'יאיר',
                lastName: 'כהן',
              ),
              title: 'כותרת ההודעה',
              content:
                  'תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה תוכן ההודעה',
              attachments: [
                'פרסום מפגש תמוז',
              ],
              dateTimeInMsSinceEpoch: DateTime.now()
                  .subtract(const Duration(days: 120))
                  .millisecondsSinceEpoch,
            ),
          ]
        : result2
            ? []
            : throw Exception('Error fetching messages');
  }

  Future<bool> deleteMessage(String messageId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final result = Random().nextBool();

    if (result) {
      state = AsyncValue.data(
        state.value!.where((e) => e.id != messageId).toList(),
      );
    } else {
      Toaster.show('המחיקה נכשלה');
    }

    return result;
  }
}
