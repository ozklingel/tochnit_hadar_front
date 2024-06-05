import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/user_profile_form/get_personas.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'maps_screen_controller.g.dart';

@Riverpod(
  dependencies: [
    GetPersonas,
  ],
)
class MapsScreenController extends _$MapsScreenController {
  @override
  FutureOr<List<PersonaDto>> build() async {
    final personas = await ref.watch(getPersonasProvider.future);

    ref.keepAlive();

    return personas;
  }
}
