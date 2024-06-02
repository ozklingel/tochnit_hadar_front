import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/services/arch/flags_service.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

@Riverpod(
  dependencies: [
    FlagsService,
    DioService,
    StorageService,
    GoRouterService,
  ],
)
class AuthService extends _$AuthService {
  @override
  Future<AuthDto> build() async {
    final flags = ref.watch(flagsServiceProvider);

    if (flags.isMock) {
      return flags.user;
    }

    final request = await ref.watch(dioServiceProvider).get(Consts.getAuthUser);

    final user = AuthDto.fromJson(request.data);

    if (kDebugMode) {
      final phone = ref.read(storageServiceProvider.notifier).getUserPhone();

      Logger().d('current phone: $phone');

      if (phone == '523301800') {
        return user.copyWith(
          role: UserRole.ahraiTohnit,
        );
      }
    } else {
      ref.keepAlive();
    }

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
    await ref
        .read(storageServiceProvider)
        .requireValue
        .remove(Consts.userPhoneKey);

    await ref
        .read(storageServiceProvider)
        .requireValue
        .remove(Consts.accessTokenKey);

    await ref
        .read(storageServiceProvider)
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
