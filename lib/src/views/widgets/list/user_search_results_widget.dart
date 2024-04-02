import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/address_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/cards/compound_or_city_card.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserListSearchResultsWidget extends ConsumerWidget {
  const UserListSearchResultsWidget({
    super.key,
    required this.searchString,
    required this.selectedApprentices,
    required this.onTapCard,
  });

  final String searchString;
  final ValueNotifier<List<PersonaDto>> selectedApprentices;
  final Function(double lat, double lng) onTapCard;

  @override
  Widget build(BuildContext context, ref) {
    final cityList = ref.watch(addressControllerProvider).valueOrNull ?? [];
    final compounds = ref.watch(compoundControllerProvider).valueOrNull ?? [];
    final institutions =
        ref.watch(institutionsControllerProvider).valueOrNull ?? [];
    final apprentices = ref.watch(personasControllerProvider).valueOrNull ?? [];

    final apprenticeWidgets = apprentices
        .where(
          (element) => element.fullName.toLowerCase().contains(
                searchString.toLowerCase().trim(),
              ),
        )
        .take(3)
        .map(
      (e) {
        final compound = compounds.singleWhere(
          (element) => element.id == e.militaryCompoundId,
          orElse: () => const CompoundDto(),
        );

        final institution = institutions.singleWhere(
          (element) => element.id == e.institutionId,
          orElse: () => const InstitutionDto(),
        );

        return ListTileWithTagsCard(
          avatar: e.avatar,
          name: e.fullName,
          tags: [
            e.highSchoolInstitution,
            e.thPeriod,
            e.militaryPositionNew,
            institution.name,
            compound.name,
            e.militaryUnit,
            e.maritalStatus,
          ],
          isSelected: selectedApprentices.value.contains(e),
          onLongPress: () {
            if (selectedApprentices.value.contains(e)) {
              selectedApprentices.value = [
                ...selectedApprentices.value
                    .where((element) => element.id != e.id),
              ];
            } else {
              selectedApprentices.value = [
                ...selectedApprentices.value,
                e,
              ];
            }
          },
          onTap: () {
            onTapCard(e.address.lat, e.address.lng);
          },
        );
      },
    ).toList();

    final compoundsWidgets = compounds
        .where(
          (element) => element.name.toLowerCase().contains(
                searchString.toLowerCase().trim(),
              ),
        )
        .take(3)
        .map(
          (e) => CompoundOrCityCard(
            title: e.name,
            address: e.address,
            count: 4,
            onTap: () {
              onTapCard(e.lat, e.lng);
            },
          ),
        )
        .toList();

    final cityWidgets = apprentices
        .where(
          (element) => element.address.city.toLowerCase().contains(
                searchString.toLowerCase().trim(),
              ),
        )
        .take(3)
        .map(
          (e) => CompoundOrCityCard(
            title: e.address.city,
            address: e.address.fullAddress,
            onTap: () {
              onTapCard(
                cityList[Random().nextInt(cityList.length)].lat,
                cityList[Random().nextInt(cityList.length)].lng,
              );
            },
          ),
        )
        .toList();

    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 12,
      ),
      children: [
        Text(
          'חניכים',
          style: TextStyles.s16w400cGrey2.copyWith(
            color: AppColors.gray5,
          ),
        ),
        const SizedBox(height: 12),
        if (apprenticeWidgets.isEmpty)
          const Text('אין')
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: apprenticeWidgets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => apprenticeWidgets[index],
          ),
        const SizedBox(height: 40),
        Text(
          'בסיסים',
          style: TextStyles.s16w400cGrey2.copyWith(
            color: AppColors.gray5,
          ),
        ),
        const SizedBox(height: 12),
        if (compoundsWidgets.isEmpty)
          const Text('אין')
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: compoundsWidgets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => compoundsWidgets[index],
          ),
        const SizedBox(height: 40),
        Text(
          'יישובים',
          style: TextStyles.s16w400cGrey2.copyWith(
            color: AppColors.gray5,
          ),
        ),
        const SizedBox(height: 12),
        if (cityWidgets.isEmpty)
          const Text('אין')
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cityWidgets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => cityWidgets[index],
          ),
      ],
    );
  }
}
