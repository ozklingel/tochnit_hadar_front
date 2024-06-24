import 'package:dio/dio.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:logger/logger.dart';
import 'package:requests_inspector/requests_inspector.dart';
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

    Logger().d('initializing dio with base url::${Consts.baseUrl}');

    final authToken = ref.read(storageServiceProvider.notifier).getAuthToken();
    final userPhone = ref.read(storageServiceProvider.notifier).getUserPhone();
    final userId = userPhone;

    Logger().d('userId::$userId');
    Logger().d('authToken::$authToken');

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

    dio.interceptors.addAll(
      [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Logger().d(
            //   '${options.method}'
            //   ' => '
            //   '${options.uri.path}'
            //   '?${options.queryParameters}',
            //   error: options.data,
            //   stackTrace: StackTrace.current,
            // );

            return handler.next(options);
          },
          onResponse: (response, handler) {
            // Logger().i(response.data);
            return handler.next(response);
          },
          onError: _dioErrorHandler,
        ),
        RequestsInspectorInterceptor(),
      ],
    );

    return dio;
  }

  void _dioErrorHandler(DioException error, handler) {
    if (error.response?.statusCode == 401) {
      // // Handle 401 error without throwing an exception
      // Logger().d("Handled 401 Error Inside Interceptor");

      // handler.resolve(
      //   Response(
      //     requestOptions: error.requestOptions,
      //     statusCode: 401,
      //   ),
      // );
    } else {
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
    }

    handler.next(error);
  }
}
