import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_service.g.dart';

@Riverpod(
  dependencies: [],
)
class Storage extends _$Storage {
  @override
  Future<SharedPreferences> build() async {
    return await SharedPreferences.getInstance();
  }

  String getAuthToken() {
    return state.requireValue.getString(Consts.accessTokenKey) ?? '';
  }

  String getUserPhone() {
    return state.requireValue.getString(
          Consts.userPhoneKey,
        ) ??
        '';
  }
}
