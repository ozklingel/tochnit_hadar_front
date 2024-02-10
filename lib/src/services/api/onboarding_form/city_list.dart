import 'package:collection/collection.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'city_list.g.dart';

@Riverpod(
  dependencies: [
    DioService,
  ],
)
class GetCitiesList extends _$GetCitiesList {
  @override
  Future<List<String>> build() async {
    final result = await ref.watch(dioServiceProvider).get(Consts.getAllCities);

    final parsed = result.data as List<dynamic>;

    final processed = parsed
        .map((e) => e.toString().trim())
        .where(
          (element) => RegExp(r'[a-z\u0590-\u05fe]+').hasMatch(element),
        )
        .toSet()
        .sortedBy((element) => element)
        .toList();

    ref.keepAlive();

    return processed;
  }
}
