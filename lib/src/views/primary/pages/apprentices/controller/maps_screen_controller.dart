import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/apprentice/get_maps_apprentices.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'maps_screen_controller.g.dart';

@Riverpod(
  dependencies: [
    GetMapsApprentices,
  ],
)
class MapsScreenController extends _$MapsScreenController {
  @override
  FutureOr<List<PersonaDto>> build() async {
    final personas = await ref.watch(getMapsApprenticesProvider.future);

    ref.keepAlive();

    return personas;
  }
}
