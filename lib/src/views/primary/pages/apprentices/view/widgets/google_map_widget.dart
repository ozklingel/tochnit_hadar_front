import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/geolocation/geolocation_service.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/widgets/compound_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class GoogleMapWidget extends HookConsumerWidget {
  const GoogleMapWidget({
    super.key,
    required this.mapController,
    required this.cameraPostion,
  });

  final ObjectRef<Completer<GoogleMapController>> mapController;
  final CameraPosition cameraPostion;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider).valueOrNull ?? const AuthDto();
    final compounds = ref.watch(compoundControllerProvider).valueOrNull ?? [];
    final apprentices = ref.watch(personasControllerProvider).valueOrNull ?? [];
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
                onTap: () => showCompoundBottomSheet(
                  context: context,
                  compound: c,
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
            padding: const EdgeInsets.all(16) +
                EdgeInsets.only(bottom: auth.role == UserRole.melave ? 0 : 64),
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
      ],
    );
  }
}
