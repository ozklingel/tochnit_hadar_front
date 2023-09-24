import 'dart:async';

import 'package:location/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'geolocation_service.g.dart';

@Riverpod(dependencies: [])
FutureOr<void> geoPermissionsService(GeoPermissionsServiceRef ref) async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await Location.instance.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await Location.instance.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  permissionGranted = await Location.instance.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await Location.instance.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
}

@Riverpod(
  dependencies: [
    geoPermissionsService,
  ],
)
Stream<LocationData> geoLocationService(GeoLocationServiceRef ref) async* {
  await ref.watch(geoPermissionsServiceProvider.future);

  final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    ref.invalidateSelf();
  });

  ref.onDispose(() {
    timer.cancel();
  });

  yield* Location.instance.onLocationChanged;
}
