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
              ? const ApprenticeDto().phone
              : apprentices[Random().nextInt(apprentices.length)].phone,
          title: faker.lorem.sentence(),
          content: faker.lorem.sentence(),
          icon: faker.food.dish(),
          allreadyRead: faker.randomGenerator.boolean().toString(),
          dateTime: faker.randomGenerator.boolean()
              ? faker.date
                  .dateTime(
                    minYear: 1971,
                    maxYear: DateTime.now().year,
                  )
                  .millisecondsSinceEpoch
              : faker.date
                  .dateTime(
                    minYear: DateTime.now().year,
                    maxYear: DateTime.now().year + 1,
                  )
                  .millisecondsSinceEpoch,
          attachments: List.generate(
            Random().nextInt(2),
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

  Future<List<ApprenticeDto>> searchApprentices(String keyword) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return ref
            .read(apprenticesControllerProvider)
            .valueOrNull
            ?.where(
              (element) => element.fullName
                  .toLowerCase()
                  .contains(keyword.toLowerCase()),
            )
            .toList() ??
        [];
  }
}
