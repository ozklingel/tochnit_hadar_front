import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_wrapper.dart';

class ChartCardContainer extends StatelessWidget {
  const ChartCardContainer({
    super.key,
    required this.label,
    required this.child,
    this.onTap,
    this.isPrimary = true,
  });

  final String label;
  final Widget child;
  final VoidCallback? onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return ChartCardWrapper(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Padding(
            padding:
                const EdgeInsets.all(12) + const EdgeInsets.only(bottom: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: isPrimary
                          ? TextStyles.s16w500cGrey2
                          : TextStyles.s12w400cGrey4,
                    ),
                    if (isPrimary) const Spacer(),
                    if (onTap != null) const Icon(Icons.chevron_right),
                  ],
                ),
                const SizedBox(height: 12),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
