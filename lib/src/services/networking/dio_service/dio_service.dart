import 'package:dio/dio.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_service.g.dart';

@Riverpod(
  dependencies: [
    Storage,
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

  final dio = Dio(
    BaseOptions(
      baseUrl: Consts.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
        'User-Agent': 'flutter-app',
        if (authToken.isNotEmpty) 'Authorization': 'Bearer $authToken',
      },
      queryParameters: {
        if (userPhone.isNotEmpty) 'userId': userPhone,
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        Logger().d(options.uri, error: options.data);
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Logger().i(response.data);
        return handler.next(response);
      },
      onError: (error, handler) {
        Logger().e(error);
        Toaster.error(error.type.name);
        return handler.next(error);
      },
    ),
  );

  return dio;
}
