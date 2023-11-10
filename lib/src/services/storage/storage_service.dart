import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_service.g.dart';

@Riverpod(dependencies: [])
Future<SharedPreferences> storage(StorageRef ref) async {
  return await SharedPreferences.getInstance();
}
