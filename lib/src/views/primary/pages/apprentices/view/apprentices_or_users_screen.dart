import 'package:flutter/material.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/apprentices_screen_body.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/users_screen_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ApprenticesOrUsersScreen extends ConsumerWidget {
  const ApprenticesOrUsersScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);

    switch (user.role) {
      case Role.melave:
        return const ApprenticesScreenBody();
      default:
        return const UsersScreenBody();
    }
  }
}
