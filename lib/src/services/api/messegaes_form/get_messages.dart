import 'package:collection/collection.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/arch/flags_service.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_messages.g.dart';

@Riverpod(
  dependencies: [
    FlagsService,
    DioService,
  ],
)
class GetMessages extends _$GetMessages {
  @override
  FutureOr<List<MessageDto>> build() async {
    final flags = ref.watch(flagsServiceProvider);

    if (flags.isMock) {
      return flags.messages;
    }

    final request =
        await ref.watch(dioServiceProvider).get(Consts.getAllMessages);

    final parsed = (request.data as List<dynamic>)
        .map((e) => MessageDto.fromJson(e))
        .sortedBy((element) => element.dateTime)
        .toList();

    return parsed;
  }
}
