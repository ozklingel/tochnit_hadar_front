import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    required this.avatarUrl,
    this.radius = 20,
  });

  final String avatarUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (avatarUrl.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.gray7,
        child: const Icon(
          FluentIcons.person_24_filled,
          color: Colors.white,
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: CachedNetworkImageProvider(
        avatarUrl,
      ),
    );
  }
}
