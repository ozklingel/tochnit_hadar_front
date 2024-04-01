import 'package:dio/dio.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_service.g.dart';

@Riverpod(
  dependencies: [
    StorageService,
  ],
)
class DioService extends _$DioService {
  @override
  Dio build() {
    ref.watch(storageServiceProvider);

    final authToken = ref.read(storageServiceProvider.notifier).getAuthToken();

    final userPhone = "528827064";

    Logger().d('initializing dio with base url::${Consts.baseUrl}');

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
            '${options.method}'
            ' => '
            '${options.uri.path}',
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
        'error.type': error.type,
        'error.message': error.message ?? 'no err msg',
        // 'error.requestOptions.path': error.requestOptions.path,
        'response.data': error.response?.data ?? 'no response data',
        'respone.headers': error.response?.headers ?? 'no response headers',
      },
      error: error.error,
      stackTrace: error.stackTrace,
    );

    Toaster.error(error.type.name);

    handler.next(error);
  }
}
