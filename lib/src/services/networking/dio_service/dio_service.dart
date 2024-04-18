import 'package:dio/dio.dart';
import 'package:fancy_dio_inspector/fancy_dio_inspector.dart';
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
    final userPhone = ref.read(storageServiceProvider.notifier).getUserPhone();
    
    //const userPhone = "506795170";
    //const userPhone = "544817610";
    //const userPhone = "543124511";

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
        FancyDioInterceptor(),
      ],
    );

    return dio;
  }

  void _dioErrorHandler(DioException error, handler) {
    if (error.response?.statusCode == 401) {
      // Handle 401 error without throwing an exception
      Logger().d("Handled 401 Error Inside Interceptor");
      // You can return a custom Response object or handle the error differently
      handler.resolve(
        Response(
          requestOptions: error.requestOptions,
          statusCode: 401,
        ),
      ); // Modify this as needed
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

      handler.next(error);
    }
  }
}
