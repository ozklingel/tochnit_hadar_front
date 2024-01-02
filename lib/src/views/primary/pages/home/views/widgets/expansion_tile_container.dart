import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';

class ExpansionTileContainer extends StatelessWidget {
  const ExpansionTileContainer({
    super.key,
    required this.title,
    required this.children,
    required this.height,
    this.isApplyShadow = true,
    this.onTap,
  });

  final String title;
  final List<Widget> children;
  final bool isApplyShadow;
  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      collapsedIconColor: AppColors.blue03,
      iconColor: AppColors.blue03,
      collapsedBackgroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      collapsedShape: const BeveledRectangleBorder(),
      shape: const BeveledRectangleBorder(),
      title: Row(
        children: [
          Text(
            title,
            style: TextStyles.s20w500,
          ),
          const Spacer(),
          Text(
            DateTime.now().asDayMonthYearShortSlash,
            style: TextStyles.s14w300,
          ),
        ],
      ),
      children: [
        SizedBox(
          height: height,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: children
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(12),
                    child: DecoratedBox(
                      decoration: Consts.defaultBoxDecorationWithShadow,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: Consts.borderRadius24,
                          onTap: onTap,
                          child: e,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
