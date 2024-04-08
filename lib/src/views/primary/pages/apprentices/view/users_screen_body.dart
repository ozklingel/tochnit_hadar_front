// ignore_for_file: unused_element

import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/functions/launch_url.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/users_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/widgets/google_map_widget.dart';
import 'package:hadar_program/src/views/secondary/filter/filters_screen.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/appbars/search_appbar.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hadar_program/src/views/widgets/chips/filter_chip.dart';
import 'package:hadar_program/src/views/widgets/list/user_search_results_widget.dart';
import 'package:hadar_program/src/views/widgets/wrappers/fade_indexed_stack.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UsersScreenBody extends HookConsumerWidget {
  const UsersScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final screenController = ref.watch(usersControllerProvider);
    final allUsers = screenController.valueOrNull?.users ?? [];
    final sort = useState(Sort.a2zByFirstName);
    final isSearchOpen = useState(false);
    final mapController = useRef(Completer<GoogleMapController>());
    final mapCameraPosition = useState<CameraPosition?>(null);
    final filters = useState(const FilterDto());
    final selectedPersonas = useState<List<PersonaDto>>([]);
    final compounds = ref.watch(compoundControllerProvider).valueOrNull;
    final institutions = ref.watch(institutionsControllerProvider).valueOrNull;
    final searchController = useTextEditingController();
    useListenable(searchController);
    final users = allUsers
        .where(
          (element) => element.fullName
              .contains(searchController.value.text.toLowerCase()),
        )
        .toList();

    if (screenController.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: (screenController.valueOrNull?.isMapOpen ?? false)
            ? null
            : FloatingActionButton(
                onPressed: () => const NewPersonaRouteData().push(context),
                heroTag: UniqueKey(),
                shape: const CircleBorder(),
                backgroundColor: AppColors.blue02,
                child: const Text(
                  '+',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
        body: CustomScrollView(
          physics: (screenController.valueOrNull?.isMapOpen ?? false)
              ? const NeverScrollableScrollPhysics()
              : null,
          slivers: [
            SliverAppBar(
              expandedHeight:
                  (screenController.valueOrNull?.isMapOpen ?? false) ? 60 : 100,
              collapsedHeight:
                  (screenController.valueOrNull?.isMapOpen ?? false) ? 60 : 100,
              pinned: true,
              flexibleSpace: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: SearchAppBar(
                                controller: searchController,
                                isSearchOpen: isSearchOpen,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          isSearchOpen.value = true,
                                      icon: const Icon(
                                        FluentIcons.search_24_regular,
                                      ),
                                    ),
                                    const Text('משתמשים'),
                                    const SizedBox(),
                                  ],
                                ),
                                actions: [
                                  if (selectedPersonas.value.isNotEmpty) ...[
                                    IconButton(
                                      onPressed: () =>
                                          selectedPersonas.value.length > 1
                                              ? Toaster.error('backend???')
                                              : launchSms(
                                                  phone: selectedPersonas.value
                                                      .map((e) => e.phone)
                                                      .toList(),
                                                ),
                                      icon: const Icon(
                                        FluentIcons.chat_24_regular,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => ReportNewRouteData(
                                        initRecipients: selectedPersonas.value
                                            .map((e) => e.id)
                                            .toList(),
                                      ).push(context),
                                      icon: const Icon(
                                        FluentIcons.clipboard_task_24_regular,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                ],
                              ),
                              // SearchAppBar(
                              //   elevation: MaterialStateProperty.all(0),
                              //   backgroundColor: MaterialStateColor.resolveWith(
                              //     (states) => AppColors.blue08,
                              //   ),
                              //   padding: MaterialStateProperty.all(
                              //     const EdgeInsets.symmetric(horizontal: 16),
                              //   ),
                              //   leading: const Icon(
                              //     FluentIcons.line_horizontal_3_20_filled,
                              //   ),
                              //   trailing: const [
                              //     Icon(
                              //       FluentIcons.search_24_filled,
                              //       size: 20,
                              //     ),
                              //   ],
                              //   hintText: 'חיפוש',
                              //   hintStyle: MaterialStateProperty.all(
                              //     TextStyles.s16w400cGrey2,
                              //   ),
                              // ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Stack(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final result =
                                      await Navigator.of(context).push(
                                            MaterialPageRoute<FilterDto>(
                                              builder: (ctx) =>
                                                  FiltersScreen.users(
                                                initFilters: filters.value,
                                              ),
                                              fullscreenDialog: true,
                                            ),
                                          ) ??
                                          const FilterDto();

                                  final request = await ref
                                      .read(
                                        personasControllerProvider.notifier,
                                      )
                                      .filterUsers(result);

                                  if (request) {
                                    filters.value = result;
                                  }
                                },
                                icon: const Icon(
                                  FluentIcons.filter_add_20_regular,
                                ),
                              ),
                              if (filters.value.length > 0)
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: IgnorePointer(
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.red1,
                                      radius: 7,
                                      child: Text(
                                        filters.value.length.toString(),
                                        style: TextStyles.s11w500fRoboto,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (filters.value.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 32,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...filters.value.roles.map(
                              (e) => FilterChipWidget(
                                text: e,
                                onTap: () =>
                                    filters.value = filters.value.copyWith(
                                  roles: filters.value.roles
                                      .where((element) => element != e)
                                      .toList(),
                                ),
                              ),
                            ),
                            ...filters.value.years.map(
                              (e) => FilterChipWidget(
                                text: e,
                                onTap: () =>
                                    filters.value = filters.value.copyWith(
                                  years: filters.value.years
                                      .where((element) => element != e)
                                      .toList(),
                                ),
                              ),
                            ),
                            ...filters.value.institutions.map(
                              (e) => FilterChipWidget(
                                text: e,
                                onTap: () =>
                                    filters.value = filters.value.copyWith(
                                  institutions: filters.value.institutions
                                      .where((element) => element != e)
                                      .toList(),
                                ),
                              ),
                            ),
                            ...filters.value.periods.map(
                              (e) => FilterChipWidget(
                                text: e,
                                onTap: () =>
                                    filters.value = filters.value.copyWith(
                                  periods: filters.value.periods
                                      .where((element) => element != e)
                                      .toList(),
                                ),
                              ),
                            ),
                            ...filters.value.eshkols.map(
                              (e) => FilterChipWidget(
                                text: e,
                                onTap: () =>
                                    filters.value = filters.value.copyWith(
                                  eshkols: filters.value.eshkols
                                      .where((element) => element != e)
                                      .toList(),
                                ),
                              ),
                            ),
                            ...filters.value.statuses.map(
                              (e) => FilterChipWidget(
                                text: e,
                                onTap: () =>
                                    filters.value = filters.value.copyWith(
                                  statuses: filters.value.statuses
                                      .where((element) => element != e)
                                      .toList(),
                                ),
                              ),
                            ),
                            ...filters.value.bases.map(
                              (e) => FilterChipWidget(
                                text: e,
                                onTap: () =>
                                    filters.value = filters.value.copyWith(
                                  bases: filters.value.bases
                                      .where((element) => element != e)
                                      .toList(),
                                ),
                              ),
                            ),
                            ...filters.value.hativot.map(
                              (e) => FilterChipWidget(
                                text: e,
                                onTap: () =>
                                    filters.value = filters.value.copyWith(
                                  hativot: filters.value.hativot
                                      .where((element) => element != e)
                                      .toList(),
                                ),
                              ),
                            ),
                            ...filters.value.regions.map(
                              (e) => FilterChipWidget(
                                text: e,
                                onTap: () =>
                                    filters.value = filters.value.copyWith(
                                  regions: filters.value.regions
                                      .where((element) => element != e)
                                      .toList(),
                                ),
                              ),
                            ),
                            ...filters.value.cities.map(
                              (e) => FilterChipWidget(
                                text: e,
                                onTap: () =>
                                    filters.value = filters.value.copyWith(
                                  cities: filters.value.cities
                                      .where((element) => element != e)
                                      .toList(),
                                ),
                              ),
                            ),
                          ]
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: e,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    if (!(screenController.valueOrNull?.isMapOpen ?? false))
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                final result = await showDialog<Sort>(
                                  context: context,
                                  builder: (ctx) => _SortDialog(
                                    initSortVal: sort.value,
                                  ),
                                );

                                if (result == null) {
                                  return;
                                }

                                sort.value = result;

                                ref
                                    .read(usersControllerProvider.notifier)
                                    .sort(result);
                              },
                              icon: const Icon(
                                FluentIcons.arrow_sort_down_lines_24_regular,
                                color: AppColors.gray2,
                              ),
                              label: Text(
                                '${(screenController.valueOrNull?.users ?? []).length} משתמשים',
                                style: TextStyles.s14w400
                                    .copyWith(color: AppColors.gray5),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () {
                                ref
                                    .read(usersControllerProvider.notifier)
                                    .mapView(true);
                                isSearchOpen.value = false;
                              },
                              style: TextButton.styleFrom(
                                textStyle: TextStyles.s14w400,
                                foregroundColor: AppColors.gray1,
                              ),
                              icon: const Icon(FluentIcons.location_24_regular),
                              label: const Text('תצוגת מפה'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: FadeIndexedStack(
                index: searchController.text.isNotEmpty && isSearchOpen.value
                    ? 0
                    : 1,
                children: [
                  UserListSearchResultsWidget(
                    searchString: searchController.text,
                    selectedApprentices: selectedPersonas,
                    onTapCard: (double lat, double lng) async {
                      isSearchOpen.value = false;
                      ref.read(usersControllerProvider.notifier).mapView(true);

                      final controller = await mapController.value.future;

                      await controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            zoom: Consts.goToObjectGeolocationZoom,
                            target: LatLng(
                              lat,
                              lng,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  FadeIndexedStack(
                    index: (screenController.valueOrNull?.isMapOpen ?? false)
                        ? 0
                        : 1,
                    children: [
                      GoogleMapWidget(
                        mapController: mapController,
                        onListTypePressed: () => ref
                            .read(usersControllerProvider.notifier)
                            .mapView(false),
                        cameraPostion: mapCameraPosition.value ??
                            Consts.defaultCameraPosition,
                      ),
                      ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (ctx, idx) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTileWithTagsCard(
                            onlineStatus: users[idx].callStatus,
                            avatar: users[idx].avatar,
                            name: users[idx].fullName,
                            tags: [
                              users[idx].highSchoolInstitution,
                              users[idx].thPeriod,
                              users[idx].militaryPositionNew,
                              (institutions?.singleWhere(
                                        (element) =>
                                            element.id ==
                                            users[idx].institutionId,
                                        orElse: () => const InstitutionDto(),
                                      ) ??
                                      const InstitutionDto())
                                  .name,
                              (compounds?.singleWhere(
                                        (element) =>
                                            element.id ==
                                            users[idx].militaryCompoundId,
                                        orElse: () => const CompoundDto(),
                                      ) ??
                                      const CompoundDto())
                                  .name,
                              users[idx].militaryUnit,
                              users[idx].maritalStatus,
                            ],
                            isSelected:
                                selectedPersonas.value.contains(users[idx]),
                            onLongPress: () {
                              if (selectedPersonas.value.contains(users[idx])) {
                                selectedPersonas.value = [
                                  ...selectedPersonas.value.where(
                                    (element) => element.id != users[idx].id,
                                  ),
                                ];
                              } else {
                                selectedPersonas.value = [
                                  ...selectedPersonas.value,
                                  users[idx],
                                ];
                              }
                            },
                            onTap: () => PersonaDetailsRouteData(
                              id: users[idx].id,
                            ).go(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortDialog extends HookWidget {
  const _SortDialog({
    required this.initSortVal,
  });

  final Sort initSortVal;

  @override
  Widget build(BuildContext context) {
    final selectedVal = useState(initSortVal);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 260,
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'מיין לפי',
                style: TextStyles.s16w400cGrey5,
              ),
              RadioListTile.adaptive(
                value: Sort.a2zByFirstName,
                groupValue: selectedVal.value,
                onChanged: (val) =>
                    Navigator.of(context).pop(Sort.a2zByFirstName),
                title: const Text(
                  'א-ב שם פרטי',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
              RadioListTile.adaptive(
                value: Sort.a2zByLastName,
                groupValue: selectedVal.value,
                onChanged: (val) =>
                    Navigator.of(context).pop(Sort.a2zByLastName),
                title: const Text(
                  'א-ב שם משפחה',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
              RadioListTile.adaptive(
                value: Sort.activeToInactive,
                groupValue: selectedVal.value,
                onChanged: (val) =>
                    Navigator.of(context).pop(Sort.activeToInactive),
                title: const Text(
                  'מהפעיל אל הפחות פעיל',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
              RadioListTile.adaptive(
                value: Sort.inactiveToActive,
                groupValue: selectedVal.value,
                onChanged: (val) =>
                    Navigator.of(context).pop(Sort.inactiveToActive),
                title: const Text(
                  'מהפחות פעיל אל הפעיל',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
