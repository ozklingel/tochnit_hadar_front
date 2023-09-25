import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.selectedItems,
    required this.task,
  });

  final ValueNotifier<List<TaskDto>> selectedItems;
  final TaskDto task;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selectedItems.value.contains(task)
          ? AppColors.blue07
          : Colors.transparent,
      child: InkWell(
        // TODO(noga-dev): provide callback instead of passing selectedItems
        onLongPress: () {
          if (selectedItems.value.contains(task)) {
            final newList = selectedItems.value;
            newList.remove(task);
            selectedItems.value = [...newList];
          } else {
            selectedItems.value = [...selectedItems.value, task];
          }
        },
        child: ListTile(
          leading: CircleAvatar(
            radius: 16,
            backgroundImage: CachedNetworkImageProvider(
              task.apprentice.avatar,
            ),
            child: selectedItems.value.contains(task)
                ? const Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: AppColors.green1,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  )
                : null,
          ),
          title: Text(
            task.apprentice.fullName,
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
