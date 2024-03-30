import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/widgets/images/avatar_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskCard extends ConsumerWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onLongPress,
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final TaskDto task;
  final VoidCallback onLongPress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, ref) {
    final apprentice =
        ref.watch(apprenticesControllerProvider).valueOrNull?.firstWhere(
                  (element) => task.apprenticeIds.contains(element.id),
                  orElse: () => const ApprenticeDto(),
                ) ??
            const ApprenticeDto();

    return Material(
      color: isSelected ? AppColors.blue07 : Colors.transparent,
      child: InkWell(
        onLongPress: onLongPress,
        onTap: onTap,
        child: ListTile(
          leading: Stack(
            children: [
              AvatarWidget(
                radius: 16,
                avatarUrl: apprentice.avatar,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: apprentice.callStatus.toColor(),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: isSelected
                    ? const Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 6,
                          backgroundColor: AppColors.green1,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          title: Text(
            apprentice.fullName,
            style: TextStyles.s18w500cGray1,
          ),
          subtitle: Text(
            task.dateTime.asDateTime.asTimeAgo,
            style: TextStyles.s16w300cGray2,
          ),
        ),
      ),
    );
  }
}
