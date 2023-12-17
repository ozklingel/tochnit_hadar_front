import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';

class ListTileWithTagsCard extends StatelessWidget {
  const ListTileWithTagsCard({
    super.key,
    this.avatar = '',
    this.name = '',
    this.tags = const [],
    this.isSelected = false,
    this.onLongPress,
    this.onTap,
    this.onlineStatus,
  });

  final bool isSelected;
  final String avatar;
  final String name;
  final List<String> tags;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;
  final String? onlineStatus;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: Consts.defaultDurationM,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? AppColors.blue08 : Colors.white,
          ),
          child: Material(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              onLongPress: onLongPress,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        avatar.isEmpty
                            ? const CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.grey6,
                                child: Icon(
                                  FluentIcons.person_24_filled,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              )
                            : CircleAvatar(
                                radius: 20,
                                backgroundImage: CachedNetworkImageProvider(
                                  avatar,
                                ),
                              ),
                        if (onlineStatus != null)
                          Positioned(
                            bottom: 1,
                            right: 1,
                            child: CircleAvatar(
                              radius: 6,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 4,
                                backgroundColor: onlineStatus == 'debug'
                                    ? Colors.pink
                                    : Colors.pink,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 240,
                          child: Text(
                            name,
                            style: TextStyles.s18w400cGray1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 240,
                          child: Text(
                            tags.join(' • '),
                            style: TextStyles.s12w500.copyWith(
                              color: AppColors.blue03,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
