import 'package:faker/faker.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'address_controller.g.dart';

@Riverpod(
  dependencies: [],
)
class AddressController extends _$AddressController {
  @override
  FutureOr<List<AddressDto>> build() async {
    return List.generate(
      21,
      (index) => AddressDto(
        city: faker.address.city(),
        lat: faker.geo.latitude(),
        lng: faker.geo.longitude(),
      ),
    );
  }
}
