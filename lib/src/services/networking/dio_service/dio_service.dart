import 'package:dio/dio.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_service.g.dart';

@Riverpod(
  dependencies: [
    storage,
  ],
)
Dio dio(DioRef ref) {
  final authToken = ref
          .watch(storageProvider)
          .requireValue
          .getString(Consts.accessTokenKey) ??
      '';

  final userPhone = ref
          .watch(
            storageProvider,
          )
          .requireValue
          .getString(
            Consts.userPhoneKey,
          ) ??
      '';

  return Dio(
    BaseOptions(
      baseUrl: Consts.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (authToken.isNotEmpty) 'Authorization': 'Bearer $authToken',
      },
      queryParameters: {
        'userId': userPhone,
      },
    ),
  );
}
