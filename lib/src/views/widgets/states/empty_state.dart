import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.image,
    required this.topText,
    required this.bottomText,
  });

  final SvgPicture image;
  final String topText;
  final String bottomText;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              image,
              Text(
                topText,
                textAlign: TextAlign.center,
                style: TextStyles.s20w500,
              ),
              Text(
                bottomText,
                textAlign: TextAlign.center,
                style: TextStyles.s14w400,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
