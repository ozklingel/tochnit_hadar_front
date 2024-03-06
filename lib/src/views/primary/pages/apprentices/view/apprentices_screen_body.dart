import 'dart:async';
import 'dart:math';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/api/user_profile_form/my_apprentices.dart';
import 'package:hadar_program/src/services/geolocation/geolocation_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/address_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/widgets/apprentice_appbar.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/widgets/compound_bottom_sheet.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class ApprenticesScreenBody extends HookConsumerWidget {
  const ApprenticesScreenBody({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final isMapShown = useState(false);
    final selectedIds = useState(<String>[]);
    final isSearchOpen = useState(false);
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
          selectedIds: selectedIds,
        ),
      ),
      body: _FadeIndexedStack(
        index: searchController.text.isNotEmpty && isSearchOpen.value ? 0 : 1,
        children: [
          _SearchResults(
            searchString: searchController.text,
            selectedIds: selectedIds,
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
          _FadeIndexedStack(
            index: isMapShown.value ? 0 : 1,
            children: [
              _MapWidget(
                mapController: mapController,
                onListTypePressed: () => isMapShown.value = false,
                cameraPostion:
                    mapCameraPosition.value ?? Consts.defaultCameraPosition,
              ),
              _ApprenticeList(
                selectedIds: selectedIds,
                isMapShownPressed: () => isMapShown.value = true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapWidget extends HookConsumerWidget {
  const _MapWidget({
    required this.mapController,
    required this.cameraPostion,
    required this.onListTypePressed,
  });

  final ObjectRef<Completer<GoogleMapController>> mapController;
  final VoidCallback onListTypePressed;
  final CameraPosition cameraPostion;

  @override
  Widget build(BuildContext context, ref) {
    final compounds = ref.watch(compoundControllerProvider).valueOrNull ?? [];
    final apprentices =
        ref.watch(apprenticesControllerProvider).valueOrNull ?? [];
    final markers = useState(<Marker>{});

    useEffect(
      () {
        void init() async {
          markers.value = {};

          for (final c in compounds) {
            final totalApprentices = apprentices.where(
              (element) => element.militaryCompoundId == c.id,
            );

            // NOTE(nogadev): without this the widget is painted twice but
            // gets overriden with a 0 as total apprentices count
            if (totalApprentices.isEmpty) {
              continue;
            }

            markers.value = {
              ...markers.value,
              Marker(
                markerId: MarkerId(c.id),
                position: LatLng(
                  c.lat,
                  c.lng,
                ),
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => CompoundBottomSheet(compound: c),
                ),
                icon: await Padding(
                  padding: const EdgeInsets.all(12),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      border: Border.all(
                        color: AppColors.blue02,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          offset: Offset(0, 5),
                          color: Colors.black26,
                        ),
                        BoxShadow(
                          blurRadius: 18,
                          offset: Offset(0, 1),
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 12,
                      ),
                      child: Text.rich(
                        TextSpan(
                          style: TextStyles.s16w500cGrey2,
                          children: [
                            TextSpan(text: c.name),
                            const TextSpan(text: '\n'),
                            TextSpan(
                              text: totalApprentices.length.toString(),
                              style: const TextStyle(color: AppColors.blue04),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ).toBitmapDescriptor(
                  waitToRender: Duration.zero,
                ),
              ),
            };
          }
        }

        init();

        return null;
      },
      [compounds, apprentices],
    );

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) {
            if (mapController.value.isCompleted) return;

            mapController.value.complete(controller);
          },
          initialCameraPosition: cameraPostion,
          markers: markers.value,
        ),
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FloatingActionButton(
              heroTag: UniqueKey(),
              shape: const CircleBorder(),
              onPressed: () async {
                final controller = await mapController.value.future;
                final currentPosition =
                    await ref.read(geoLocationServiceProvider.future);

                await controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      zoom: 14,
                      target: LatLng(
                        currentPosition.latitude ??
                            Consts.defaultGeolocationLat,
                        currentPosition.longitude ??
                            Consts.defaultGeolocationLng,
                      ),
                    ),
                  ),
                );
              },
              child: const RotatedBox(
                quarterTurns: 1,
                child: Icon(
                  FluentIcons.compass_northwest_24_filled,
                  color: AppColors.blue03,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FloatingActionButton.extended(
              onPressed: onListTypePressed,
              heroTag: UniqueKey(),
              backgroundColor: AppColors.mainCTA,
              foregroundColor: Colors.white,
              extendedTextStyle: const TextStyle(
                fontFamily: 'Assistant',
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              label: const Text('תצוגת רשימה'),
              icon: const Icon(FluentIcons.text_bullet_list_24_regular),
            ),
          ),
        ),
      ],
    );
  }
}

class _ApprenticeList extends ConsumerWidget {
  const _ApprenticeList({
    required this.selectedIds,
    required this.isMapShownPressed,
  });

  final ValueNotifier<List<String>> selectedIds;
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
                      selectedIds: selectedIds,
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
                      selectedIds: selectedIds,
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
    required this.selectedIds,
    required this.isLoading,
  });

  final List<ApprenticeDto> apprentices;
  final ValueNotifier<List<String>> selectedIds;
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
            isSelected: selectedIds.value.contains(e.id),
            onTap: () => ApprenticeDetailsRouteData(id: e.id).go(context),
            onLongPress: () {
              if (selectedIds.value.contains(e.id)) {
                final newList = selectedIds;
                newList.value.remove(e.id);
                selectedIds.value = [
                  ...newList.value,
                ];
              } else {
                selectedIds.value = [
                  ...selectedIds.value,
                  e.id,
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

class _CompoundOrCityCard extends StatelessWidget {
  const _CompoundOrCityCard({
    required this.title,
    required this.address,
    required this.onTap,
    this.count,
  });

  final String title;
  final String address;
  final int? count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: AnimatedContainer(
        duration: Consts.defaultDurationM,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'בה”ד 1',
                    style: TextStyles.s16w500cGrey2,
                  ),
                  Text(
                    'כתובת: הנגב 8, בה”ד 1',
                    style: TextStyles.s14w300cGray2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({
    required this.searchString,
    required this.selectedIds,
    required this.onTapCard,
  });

  final String searchString;
  final ValueNotifier<List<String>> selectedIds;
  final Function(double lat, double lng) onTapCard;

  @override
  Widget build(BuildContext context, ref) {
    final cityList = ref.watch(addressControllerProvider).valueOrNull ?? [];
    final compounds = ref.watch(compoundControllerProvider).valueOrNull ?? [];
    final institutions =
        ref.watch(institutionsControllerProvider).valueOrNull ?? [];
    final apprentices =
        ref.watch(apprenticesControllerProvider).valueOrNull ?? [];

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
          isSelected: selectedIds.value.contains(e.id),
          onLongPress: () {
            if (selectedIds.value.contains(e.id)) {
              final newList = selectedIds;
              newList.value.remove(e.id);
              selectedIds.value = [
                ...newList.value,
              ];
            } else {
              selectedIds.value = [
                ...selectedIds.value,
                e.id,
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
          (e) => _CompoundOrCityCard(
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
          (e) => _CompoundOrCityCard(
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

// https://gist.github.com/diegoveloper/1cd23e79a31d0c18a67424f0cbdfd7ad
class _FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const _FadeIndexedStack({
    required this.index,
    required this.children,
  });

  @override
  _FadeIndexedStackState createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<_FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void didUpdateWidget(_FadeIndexedStack oldWidget) {
    if (!mounted) return super.didUpdateWidget(oldWidget);

    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Consts.defaultDurationXL);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      // required for errors not to occur during rapid switching between tabs
      child: RepaintBoundary(
        child: IndexedStack(
          index: widget.index,
          children: widget.children,
        ),
      ),
    );
  }
}
