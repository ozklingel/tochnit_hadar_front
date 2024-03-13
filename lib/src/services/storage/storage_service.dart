import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_service.g.dart';

@Riverpod(
  dependencies: [],
)
class StorageService extends _$StorageService {
  @override
  Future<SharedPreferences> build() async {
    return await SharedPreferences.getInstance();
  }

  String getAuthToken() {
    return state.requireValue.getString(Consts.accessTokenKey) ?? '';
  }

  String getUserPhone() {
    final result = state.requireValue.getString(
          Consts.userPhoneKey,
        ) ??
        '';

    if (result.startsWith('972')) {
      return result.replaceFirst('972', '');
    }

    return result;
  }
}
