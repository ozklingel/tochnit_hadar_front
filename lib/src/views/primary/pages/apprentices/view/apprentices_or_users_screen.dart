import 'package:flutter/material.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/apprentices_screen_body.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/users_screen_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ApprenticesOrUsersScreen extends ConsumerWidget {
  const ApprenticesOrUsersScreen({
    super.key,
    required this.isMapOpen,
  });

  final bool isMapOpen;

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);

    if (user.isLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    switch (user.valueOrNull?.role) {
      case UserRole.melave:
        return ApprenticesScreenBody(
          isMapOpen: isMapOpen,
        );
      case UserRole.ahraiTohnit:
      case UserRole.rakazEshkol:
      case UserRole.rakazMosad:
        return UsersScreenBody(
          isMapOpen: isMapOpen,
        );
      default:
        return const Center(
          child: Text('USER ROLE?'),
        );
    }
  }
}
