import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/arch/flags_service.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_service.g.dart';

@Riverpod(
  dependencies: [
    FlagsService,
    DioService,
    Storage,
    GoRouterService,
  ],
)
class UserService extends _$UserService {
  @override
  Future<UserDto> build() async {
    final flags = ref.watch(flagsServiceProvider);

    if (flags.isMock) {
      return flags.user;
    }

    final request = await ref.watch(dioServiceProvider).get(Consts.getAuthUser);

    final user = UserDto.fromJson(request.data);

    ref.keepAlive();

    return user;
  }

  @internal
  void overrideRole(UserRole role) {
    state = AsyncData(
      state.requireValue.copyWith(
        role: role,
      ),
    );
  }

  Future<void> logOff() async {
    await ref.read(storageProvider).requireValue.remove(Consts.userPhoneKey);

    await ref.read(storageProvider).requireValue.remove(Consts.accessTokenKey);

    await ref
        .read(storageProvider)
        .requireValue
        .remove(Consts.isFirstOnboardingKey);

    const HomeRouteData().go(
      ref
          .read(goRouterServiceProvider)
          .configuration
          .navigatorKey
          .currentContext!,
    );
  }
}
