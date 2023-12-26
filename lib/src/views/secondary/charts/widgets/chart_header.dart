import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChartHeader extends ConsumerWidget {
  const ChartHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider).valueOrNull;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${user?.fullName ?? 'N/A'}'
          ' '
          '(${user?.role.name ?? 'N/A'})',
          style: TextStyles.s24w500cGrey2,
        ),
        const Spacer(),
        TextButton(
          onPressed: () => Toaster.unimplemented(),
          child: const Text('כרטיס אישי'),
        ),
      ],
    );
  }
}
