import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_service.g.dart';

@Riverpod(dependencies: [])
Dio dioService(DioServiceRef ref) {
  return Dio();
}
