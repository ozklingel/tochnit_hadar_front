import 'package:flutter/material.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/users_screen_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ApprenticesOrUsersScreen extends ConsumerWidget {
  const ApprenticesOrUsersScreen({
    super.key,
  });

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
      // return const ApprenticesScreenBody();
      case UserRole.ahraiTohnit:
      case UserRole.rakazEshkol:
      case UserRole.rakazMosad:
        return const UsersScreenBody();
      default:
        return const Center(
          child: Text('USER ROLE?'),
        );
    }
  }
}
