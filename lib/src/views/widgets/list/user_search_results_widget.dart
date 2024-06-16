import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/users_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/widgets/compound_bottom_sheet.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/cards/compound_or_city_card.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserListSearchResultsWidget extends HookConsumerWidget {
  const UserListSearchResultsWidget({
    super.key,
    required this.searchString,
    required this.selectedPersonas,
    required this.onTapCard,
    required this.sort,
  });

  final String searchString;
  final ValueNotifier<List<PersonaDto>> selectedPersonas;
  final Function(double lat, double lng) onTapCard;
  final Sort sort;

  @override
  Widget build(BuildContext context, ref) {
    // final cityList = ref.watch(addressControllerProvider).valueOrNull ?? [];
    final compounds = ref.watch(compoundControllerProvider).valueOrNull ?? [];
    final institutions =
        ref.watch(institutionsControllerProvider).valueOrNull ?? [];
    final personas = ref.watch(personasControllerProvider).valueOrNull ?? [];

    final apprenticeWidgets = personas
        .where(
          (element) => element.fullName.toLowerCase().contains(
                searchString.toLowerCase().trim(),
              ),
        )
        .sorted((e1, e2) {
          switch (sort) {
            case Sort.a2zByLastName:
              return e1.lastName.compareTo(e2.lastName);
            case Sort.activeToInactive:
              return e1.activityScore.compareTo(e2.activityScore);
            case Sort.inactiveToActive:
              return e2.activityScore.compareTo(e1.activityScore);
            case Sort.a2zByFirstName:
            default:
              return e1.firstName.compareTo(e2.firstName);
          }
        })
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

            void onSelect() {
              if (selectedPersonas.value.contains(e)) {
                selectedPersonas.value = [
                  ...selectedPersonas.value
                      .where((element) => element.id != e.id),
                ];
              } else {
                selectedPersonas.value = [
                  ...selectedPersonas.value,
                  e,
                ];
              }
            }

            return ListTileWithTagsCard(
              avatar: e.avatar,
              name: e.fullName,
              tags: [
                e.highSchoolInstitution,
                e.thPeriod,
                e.militaryPositionNew,
                institution.name,
                compound.name,
                e.militaryServiceType,
                e.maritalStatus.name,
              ],
              isSelected: selectedPersonas.value.contains(e),
              onLongPress: onSelect,
              onTap: selectedPersonas.value.isEmpty
                  ? () async {
                      await PersonaDetailsRouteData(id: e.id).push(context);
                      // onTapCard(e.address.lat, e.address.lng);
                    }
                  : onSelect,
            );
          },
        )
        .toList();

    final compoundsWidgets = compounds
        // .where(
        //   (element) => personas
        //       .where((p) => p.militaryCompoundId == element.id)
        //       .isNotEmpty,
        // )
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
            onTap: () async {
              showCompoundBottomSheet(
                context: context,
                compound: e,
              );
              // onTapCard(e.lat, e.lng);
            },
          ),
        )
        .toList();

    // final cityWidgets = personas
    //     .where(
    //       (element) => element.address.city.toLowerCase().contains(
    //             searchString.toLowerCase().trim(),
    //           ),
    //     )
    //     .take(3)
    //     .map(
    //       (e) => CompoundOrCityCard(
    //         title: e.address.city,
    //         address: e.address.fullAddress,
    //         onTap: () {
    //           onTapCard(
    //             cityList[Random().nextInt(cityList.length)].lat,
    //             cityList[Random().nextInt(cityList.length)].lng,
    //           );
    //         },
    //       ),
    //     )
    // .toList();

    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 12,
      ),
      children: [
        // https://trello.com/c/SrdczJAh/82-%D7%91%D7%90%D7%92-%D7%91%D7%97%D7%99%D7%A4%D7%95%D7%A9
        // Row(
        //   children: [
        //     Text(
        //       '${apprenticeWidgets.length} חניכים',
        //       style: TextStyles.s16w400cGrey2.copyWith(
        //         color: AppColors.gray5,
        //       ),
        //     ),
        //     const Spacer(),
        //     ...[
        //       if (selectedPersonas.value.isNotEmpty) ...[
        //         IconButton(
        //           onPressed: () => selectedPersonas.value.length > 1
        //               ? Toaster.error('backend???')
        //               : launchSms(
        //                   phone: selectedPersonas.value
        //                       .map((e) => e.phone)
        //                       .toList(),
        //                 ),
        //           icon: const Icon(
        //             FluentIcons.chat_24_regular,
        //           ),
        //         ),
        //         IconButton(
        //           onPressed: () => ReportNewRouteData(
        //             initRecipients:
        //                 selectedPersonas.value.map((e) => e.id).toList(),
        //           ).push(context),
        //           icon: const Icon(
        //             FluentIcons.clipboard_task_24_regular,
        //           ),
        //         ),
        //         const SizedBox(width: 12),
        //       ],
        //     ],
        //   ],
        // ),
        // const SizedBox(height: 12),
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
        // Text(
        //   'יישובים',
        //   style: TextStyles.s16w400cGrey2.copyWith(
        //     color: AppColors.gray5,
        //   ),
        // ),
        // const SizedBox(height: 12),
        // if (cityWidgets.isEmpty)
        //   const Text('אין')
        // else
        //   ListView.separated(
        //     physics: const NeverScrollableScrollPhysics(),
        //     shrinkWrap: true,
        //     padding: const EdgeInsets.symmetric(horizontal: 16),
        //     itemCount: cityWidgets.length,
        //     separatorBuilder: (_, __) => const SizedBox(height: 12),
        //     itemBuilder: (context, index) => cityWidgets[index],
        //   ),
      ],
    );
  }
}
