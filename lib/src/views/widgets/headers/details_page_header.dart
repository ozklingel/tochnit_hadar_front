import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';

class DetailsPageHeader extends StatelessWidget {
  const DetailsPageHeader({
    super.key,
    required this.name,
    required this.phone,
    required this.onTapEditAvatar,
    this.avatar = '',
    this.bottom,
  });

  final String avatar;
  final String name;
  final String phone;
  final Widget? bottom;
  final VoidCallback onTapEditAvatar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kTextTabBarHeight + 24),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: ColoredBox(
          color: AppColors.blue08,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: 120,
                child: Stack(
                  children: [
                    if (avatar.isEmpty)
                      const CircleAvatar(
                        radius: 120,
                        backgroundColor: AppColors.grey6,
                        child: Icon(
                          FluentIcons.person_24_filled,
                          size: 72,
                          color: Colors.white,
                        ),
                      )
                    else
                      CircleAvatar(
                        radius: 120,
                        backgroundImage: CachedNetworkImageProvider(
                          avatar,
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Transform.scale(
                        scale: 0.8,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.blue08,
                          ),
                          onPressed: () => Toaster.unimplemented(),
                          icon: const Icon(FluentIcons.edit_24_regular),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: TextStyles.s24w600,
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 2),
              Center(
                child: Text(
                  phone,
                  style: TextStyles.s16w400cGrey5,
                  textAlign: TextAlign.center,
                ),
              ),
              if (bottom != null) bottom!,
            ],
          ),
        ),
      ),
    );
  }
}
