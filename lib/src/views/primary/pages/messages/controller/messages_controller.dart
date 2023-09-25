import 'dart:math';

import 'package:faker/faker.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messages_controller.g.dart';

@Riverpod(
  dependencies: [
    ApprenticesController,
  ],
)
class MessagesController extends _$MessagesController {
  @override
  FutureOr<List<MessageDto>> build() async {
    await Future.delayed(const Duration(milliseconds: 200));

    final apprentices =
        ref.watch(apprenticesControllerProvider).valueOrNull ?? [];

    return List.generate(
      31,
      (index) {
        return MessageDto(
          id: faker.guid.guid(),
          from: apprentices.isEmpty
              ? const ApprenticeDto()
              : apprentices[Random().nextInt(apprentices.length)],
          title: faker.lorem.sentence(),
          content: faker.lorem.sentence(),
          dateTime: faker.date
              .dateTime(
                minYear: 1971,
                maxYear: DateTime.now().year,
              )
              .millisecondsSinceEpoch,
          attachments: List.generate(
            11,
            (index) => faker.image.image(height: 100, width: 100),
          ),
        );
      },
    );
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
