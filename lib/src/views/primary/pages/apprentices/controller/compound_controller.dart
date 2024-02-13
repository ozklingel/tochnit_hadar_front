import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compound_controller.g.dart';

const _compoundCoordinates = [
  LatLng(
    41.72968294429526,
    44.75831792024938,
  ),
  LatLng(
    41.71767453740806,
    44.760338174181285,
  ),
  LatLng(
    41.7219895752664,
    44.73268980082815,
  ),
  LatLng(
    41.72961210962762,
    44.74617756089861,
  ),
  LatLng(
    41.71602190223969,
    44.74627340657671,
  ),
  LatLng(
    41.7178138350973,
    44.779413520894146,
  ),
  LatLng(
    41.73464558757453,
    44.74299792463824,
  ),
];

@Riverpod(
  dependencies: [],
)
class CompoundController extends _$CompoundController {
  @override
  FutureOr<List<CompoundDto>> build() {
    return List.generate(
      _compoundCoordinates.length,
      (index) => CompoundDto(
        id: Consts.mockCompoundGuids[index],
        name: 'קומפאונד $index',
        lat: _compoundCoordinates[index].latitude,
        lng: _compoundCoordinates[index].longitude,
      ),
    );
  }
}
