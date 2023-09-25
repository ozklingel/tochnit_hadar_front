import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';

class ApprenticeCard extends StatelessWidget {
  const ApprenticeCard({
    super.key,
    required this.selectedIds,
    required this.apprentice,
    this.isLongTapEnabled = true,
    this.onTap,
  });

  final ValueNotifier<List<String>> selectedIds;
  final ApprenticeDto apprentice;
  final bool isLongTapEnabled;
  final VoidCallback? onTap;

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
            color: selectedIds.value.contains(apprentice.id)
                ? AppColors.blue08
                : Colors.white,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap ??
                () => ApprenticeDetailsRouteData(id: apprentice.id).go(context),
            onLongPress: isLongTapEnabled
                ? () {
                    if (selectedIds.value.contains(apprentice.id)) {
                      final newList = selectedIds;
                      newList.value.remove(apprentice.id);
                      selectedIds.value = [
                        ...newList.value,
                      ];
                    } else {
                      selectedIds.value = [
                        ...selectedIds.value,
                        apprentice.id,
                      ];
                    }
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (apprentice.avatar.isEmpty)
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.grey6,
                      child: Icon(
                        FluentIcons.person_24_filled,
                        size: 16,
                        color: Colors.white,
                      ),
                    )
                  else
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: CachedNetworkImageProvider(
                        apprentice.avatar,
                      ),
                    ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${apprentice.firstName} ${apprentice.lastName}',
                        style: TextStyles.s18w400cGray1,
                      ),
                      SizedBox(
                        width: 240,
                        child: Text(
                          [
                            apprentice.highSchoolInstitution,
                            apprentice.thPeriod,
                            apprentice.militaryPositionNew,
                            apprentice.thInstitution,
                            apprentice.militaryCompound.name,
                            apprentice.militaryUnit,
                            apprentice.maritalStatus,
                          ].join(' • '),
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
    );
  }
}
