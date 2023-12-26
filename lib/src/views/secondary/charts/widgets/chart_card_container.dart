import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';

class ChartCardContainer extends StatelessWidget {
  const ChartCardContainer({
    super.key,
    required this.label,
    required this.child,
    required this.onTap,
  });

  final String label;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 12),
            blurRadius: 24,
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
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
                  children: [
                    Text(
                      label,
                      style: TextStyles.s16w500cGrey2,
                    ),
                    const Spacer(),
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
