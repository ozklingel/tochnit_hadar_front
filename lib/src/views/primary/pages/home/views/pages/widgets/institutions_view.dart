import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/apprentice_status.dto.dart';

class InstitutionsView extends StatelessWidget {
  const InstitutionsView({
    super.key,
    required this.items,
    required this.institutions,
    required this.selectedItem,
    required this.onTap,
  });

  final ApprenticeStatusItemDto selectedItem;
  final List<ApprenticeStatusItemDto> items;
  final List<InstitutionDto> institutions;
  final void Function(ApprenticeStatusItemDto apprentice) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 6),
      itemBuilder: (context, index) => items
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    Consts.defaultBoxShadow,
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    onTap: () => onTap(e),
                    title: Row(
                      children: [
                        Text(
                          institutions
                              .singleWhere(
                                (element) => element.id == e.id,
                                orElse: () => const InstitutionDto(),
                              )
                              .name,
                          style: TextStyles.s18w500cGray1,
                        ),
                        const Spacer(),
                        Text(
                          '${e.value} חניכים',
                          style: TextStyles.s14w400cGrey1,
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList()[index],
    );
  }
}
