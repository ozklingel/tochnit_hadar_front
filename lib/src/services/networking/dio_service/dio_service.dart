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
class DioService extends _$DioService {
  @override
  Dio build() {
    ref.watch(storageProvider);

    final authToken = ref.read(storageProvider.notifier).getAuthToken();

    final userPhone = ref.read(storageProvider.notifier).getUserPhone();

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
          Logger().d(
            options.uri,
            error: options.data,
            stackTrace: StackTrace.current,
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Logger().i(response.data);
          return handler.next(response);
        },
        onError: _dioErrorHandler,
      ),
    );

    return dio;
  }

  void _dioErrorHandler(DioException error, handler) {
    Logger().e(
      {
        'response.data': error.response?.data ?? 'no response data',
        'respone.headers': error.response?.headers ?? 'no response headers',
      },
      error: error,
      stackTrace: StackTrace.current,
    );

    Toaster.error(error.type.name);

    handler.next(error);
  }
}
