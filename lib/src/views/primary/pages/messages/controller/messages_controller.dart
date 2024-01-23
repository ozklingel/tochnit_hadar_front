import 'dart:math';

import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'messages_controller.g.dart';

@Riverpod(
  dependencies: [
    ApprenticesController,
    DioService,
    Storage,
  ],
)
class MessagesController extends _$MessagesController {
  @override
  FutureOr<List<MessageDto>> build() async {
    final request =
        await ref.watch(dioServiceProvider).get('messegaes_form/getAll');

    // await Future.delayed(const Duration(milliseconds: 200));

    // final apprentices =
    //     ref.watch(apprenticesControllerProvider).valueOrNull ?? [];

    final parsed = (request.data as List<dynamic>)
        .map((e) => MessageDto.fromJson(e))
        .toList();

    return parsed;

    // return List.generate(
    //   31,
    //   (index) {
    //     return MessageDto(
    //       id: faker.guid.guid(),
    //       from: apprentices.isEmpty
    //           ? const ApprenticeDto().phone
    //           : apprentices[Random().nextInt(apprentices.length)].phone,
    //       title: faker.lorem.sentence(),
    //       content: faker.lorem.sentence(),
    //       icon: faker.food.dish(),
    //       allreadyRead: faker.randomGenerator.boolean().toString(),
    //       dateTime: faker.randomGenerator.boolean()
    //           ? faker.date
    //               .dateTime(
    //                 minYear: 1971,
    //                 maxYear: DateTime.now().year,
    //               )
    //               .millisecondsSinceEpoch
    //           : faker.date
    //               .dateTime(
    //                 minYear: DateTime.now().year,
    //                 maxYear: DateTime.now().year + 1,
    //               )
    //               .millisecondsSinceEpoch,
    //       attachments: List.generate(
    //         Random().nextInt(2),
    //         (index) => faker.image.image(height: 100, width: 100),
    //       ),
    //     );
    //   },
    // );
  }

  Future<bool> setToReadStatus(MessageDto msg) async {
    if (msg.allreadyRead) {
      return true;
    }

    try {
      await ref.read(dioServiceProvider).post(
        'messegaes_form/setWasRead',
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

  Future<bool> sendMessage(MessageDto msg) async {
    try {
      await ref.read(dioServiceProvider).post(
        'messegaes_form/add',
        data: {
          'created_by_id': ref.read(storageProvider.notifier).getUserPhone(),
          'created_for_id': ref.read(storageProvider.notifier).getUserPhone(),
          'subject': msg.title,
          'content': msg.content,
          'attachments': msg.attachments,
          'icon': 'icon',
        },
      );

      return true;
    } catch (e) {
      return false;
    }
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
