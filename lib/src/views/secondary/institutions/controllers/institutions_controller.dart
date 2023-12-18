import 'package:collection/collection.dart';
import 'package:faker/faker.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'institutions_controller.g.dart';

enum SortInstitutionBy {
  fromA2Z,
  scoreLow2High,
  scoreHigh2Low,
}

@Riverpod(
  dependencies: [
    dio,
  ],
)
class InstitutionsController extends _$InstitutionsController {
  @override
  FutureOr<List<InstitutionDto>> build() async {
    // ignore: unused_local_variable
    final request =
        ref.watch(dioProvider).get('userProfile_form/myApprentices');

    await Future.delayed(const Duration(milliseconds: 400));

    return List.generate(
      Consts.mockInstitutionsGuids.length,
      (index) => InstitutionDto(
        id: Consts.mockInstitutionsGuids[index],
        name: faker.company.name(),
        rakaz: faker.person.name(),
        rakazPhoneNumber: faker.phoneNumber.de(),
        address: AddressDto(
          city: faker.address.city(),
          apartment: faker.randomGenerator.integer(99999, min: 1).toString(),
          street: faker.address.streetName(),
          houseNumber: faker.randomGenerator.integer(999, min: 1).toString(),
          postalCode: faker.address.zipCode(),
          floor: faker.randomGenerator.integer(99, min: 1).toString(),
          entrance: faker.lorem.word()[0],
          region: faker.address.state(),
        ),
        shluha: faker.lorem.word(),
        phoneNumber: faker.phoneNumber.de(),
        roshMehinaName: faker.person.name(),
        roshMehinaPhoneNumber: faker.phoneNumber.us(),
        menahelAdministrativiName: faker.person.name(),
        menahelAdministrativiPhoneNumber: faker.phoneNumber.de(),
        hanihim: Consts.mockApprenticeGuids
            .take(
              faker.randomGenerator.integer(Consts.mockApprenticeGuids.length),
            )
            .toList(),
        melavim: Consts.mockApprenticeGuids
            .take(
              faker.randomGenerator.integer(Consts.mockApprenticeGuids.length),
            )
            .toList(),
        score: faker.randomGenerator.integer(100).toDouble(),
      ),
    );
  }

  void sortBy(SortInstitutionBy sortBy) {
    if (state.valueOrNull == null) {
      return;
    }

    switch (sortBy) {
      case SortInstitutionBy.fromA2Z:
        final result = state.value!;
        final sorted = result.sortedBy((element) => element.name);
        state = AsyncData(sorted);
        return;
      case SortInstitutionBy.scoreLow2High:
        final result = state.value!;
        final sorted = result.sortedBy<num>((e) => e.score);
        state = AsyncData(sorted);
        return;
      case SortInstitutionBy.scoreHigh2Low:
        final result = state.value!;
        final sorted = result.sortedBy<num>((element) => element.score);
        final reversed = sorted.reversed.toList();
        state = AsyncData(reversed);
        return;
    }
  }
}
