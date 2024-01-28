import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
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
        SizedBox(
          width: 200,
          child: Text(
            '${user?.fullName ?? 'N/A'}'
            ' '
            '(${user?.role.name ?? 'N/A'})',
            style: TextStyles.s24w500cGrey2,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => const UserProfileRouteData().push(context),
          child: const Text('כרטיס אישי'),
        ),
      ],
    );
  }
}
