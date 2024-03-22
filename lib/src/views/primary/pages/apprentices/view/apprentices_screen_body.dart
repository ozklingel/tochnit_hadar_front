import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/api/user_profile_form/my_apprentices.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/widgets/apprentice_appbar.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hadar_program/src/views/widgets/list/user_search_results_widget.dart';
import 'package:hadar_program/src/views/widgets/maps/google_map_widget.dart';
import 'package:hadar_program/src/views/widgets/wrappers/fade_indexed_stack.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ApprenticesScreenBody extends HookConsumerWidget {
  const ApprenticesScreenBody({
    super.key,
    required this.isMapOpen,
  });

  final bool isMapOpen;

  @override
  Widget build(BuildContext context, ref) {
    final isMapShown = useState(isMapOpen);
    final isSearchOpen = useState(false);
    final selectedApprentices = useState(<ApprenticeDto>[]);
    final mapController = useRef(Completer<GoogleMapController>());
    final mapCameraPosition = useState<CameraPosition?>(null);
    final searchController = useTextEditingController();
    useListenable(searchController);

    useEffect(
      () {
        if (mapCameraPosition.value != null) {
          isSearchOpen.value = false;
          isMapShown.value = true;
        }

        return null;
      },
      [mapCameraPosition.value],
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ApprenticeAppBar(
          isSearchOpen: isSearchOpen,
          searchController: searchController,
          selectedApprentices: selectedApprentices,
        ),
      ),
      body: FadeIndexedStack(
        index: searchController.text.isNotEmpty && isSearchOpen.value ? 0 : 1,
        children: [
          UserListSearchResultsWidget(
            searchString: searchController.text,
            selectedApprentices: selectedApprentices,
            onTapCard: (double lat, double lng) async {
              isSearchOpen.value = false;
              isMapShown.value = true;

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
            index: isMapShown.value ? 0 : 1,
            children: [
              GoogleMapWidget(
                mapController: mapController,
                onListTypePressed: () => isMapShown.value = false,
                cameraPostion:
                    mapCameraPosition.value ?? Consts.defaultCameraPosition,
              ),
              _ApprenticeList(
                selectedApprentices: selectedApprentices,
                isMapShownPressed: () => isMapShown.value = true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ApprenticeList extends ConsumerWidget {
  const _ApprenticeList({
    required this.selectedApprentices,
    required this.isMapShownPressed,
  });

  final ValueNotifier<List<ApprenticeDto>> selectedApprentices;
  final VoidCallback isMapShownPressed;

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: isMapShownPressed,
              style: TextButton.styleFrom(
                textStyle: TextStyles.s16w500cGrey2,
                foregroundColor: AppColors.blue03,
              ),
              label: const Icon(FluentIcons.location_24_regular),
              icon: const Text('תצוגת מפה'),
            ),
          ),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () => ref.refresh(getApprenticesProvider.future),
              child: ref.watch(apprenticesControllerProvider).when(
                    error: (error, stack) => CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          child: Center(
                            child: Text(error.toString()),
                          ),
                        ),
                      ],
                    ),
                    loading: () => _ListBody(
                      selectedApprentices: selectedApprentices,
                      isLoading: true,
                      apprentices: List.generate(
                        10,
                        (index) => const ApprenticeDto(
                          firstName: 'firstName',
                          lastName: 'lastName',
                          avatar: 'https://picsum.photos/200',
                          highSchoolInstitution: 'highSchool',
                          thPeriod: 'thPeriod',
                          militaryPositionNew: 'militaryPosition',
                          institutionId: 'thInstitution',
                          militaryUnit: 'militaryUnit',
                          maritalStatus: 'maritalStatus',
                        ),
                      ),
                    ),
                    data: (apprentices) => _ListBody(
                      apprentices: apprentices,
                      selectedApprentices: selectedApprentices,
                      isLoading: false,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListBody extends ConsumerWidget {
  const _ListBody({
    required this.apprentices,
    required this.selectedApprentices,
    required this.isLoading,
  });

  final List<ApprenticeDto> apprentices;
  final ValueNotifier<List<ApprenticeDto>> selectedApprentices;
  final bool isLoading;

  @override
  Widget build(BuildContext context, ref) {
    final compounds = ref.watch(compoundControllerProvider).valueOrNull ?? [];
    final institutions =
        ref.watch(institutionsControllerProvider).valueOrNull ?? [];

    final children = apprentices.map(
      (e) {
        final compound = compounds.singleWhere(
          (element) => element.id == e.militaryCompoundId,
          orElse: () => const CompoundDto(),
        );

        final institution = institutions.singleWhere(
          (element) => element.id == e.institutionId,
          orElse: () => const InstitutionDto(),
        );

        return Skeletonizer(
          enabled: isLoading,
          child: ListTileWithTagsCard(
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
            isSelected: selectedApprentices.value.contains(e.id),
            onTap: () => ApprenticeDetailsRouteData(id: e.id).go(context),
            onLongPress: () {
              if (selectedApprentices.value.contains(e.id)) {
                final newList = selectedApprentices;
                newList.value.remove(e.id);
                selectedApprentices.value = [
                  ...newList.value,
                ];
              } else {
                selectedApprentices.value = [
                  ...selectedApprentices.value,
                  e,
                ];
              }
            },
          ),
        );
      },
    ).toList();

    return ListView.separated(
      itemCount: children.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => children[index],
    );
  }
}
