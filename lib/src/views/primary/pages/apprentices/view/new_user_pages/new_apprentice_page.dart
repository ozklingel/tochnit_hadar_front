import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/users_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_user_pages/new_persona_appbar.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_user_pages/new_persona_common_fields.dart';
import 'package:hadar_program/src/views/widgets/buttons/accept_cancel_buttons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewApprenticePage extends HookConsumerWidget {
  const NewApprenticePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    // general section
    final firstName = useTextEditingController();
    final lastName = useTextEditingController();
    final phone = useTextEditingController();
    final institution = useState(const InstitutionDto());
    final teudatZehutController = useTextEditingController();
    final emailController = useTextEditingController();
    final addressController = useTextEditingController();
    final selectedRegion = useState('');
    final selectedCity = useState('');
    final selectedMaritalStatus = useState('');
    // tohnit hadar section
    final selectedPeriod = useState('');
    final selectedMelave = useState('');
    final selectedMatsbar = useState('');
    final selectedIsPaying = useState('');
    final roshMosadYearAController = useTextEditingController();
    final roshMosadYearAPhone = useTextEditingController();
    final roshMosadYearBController = useTextEditingController();
    final roshMosadYearBPhone = useTextEditingController();
    // army section
    final selectedArmyBase = useState('');
    final selectedArmyServiceType = useState('');
    final selectedArmyPreviousRole = useState('');
    final selectedArmyCurrentRole = useState('');
    final selectedArmyEnlistmentDate = useState(DateTime.now());
    final selectedArmyReleaseDate = useState(DateTime.now());
    // dates
    final selectedDateOfBirth = useState(DateTime.now());
    final selectedDateOfMarriage = useState(DateTime.now());
    // family
    final contact1Relationship = useState(Relationship.other);
    final contact1FirstName = useTextEditingController();
    final contact1LastName = useTextEditingController();
    final contact1Phone = useTextEditingController();
    final contact1Email = useTextEditingController();
    final contact2Relationship = useState(Relationship.other);
    final contact2FirstName = useTextEditingController();
    final contact2LastName = useTextEditingController();
    final contact2Phone = useTextEditingController();
    final contact2Email = useTextEditingController();
    final contact3Relationship = useState(Relationship.other);
    final contact3FirstName = useTextEditingController();
    final contact3LastName = useTextEditingController();
    final contact3Phone = useTextEditingController();
    final contact3Email = useTextEditingController();
    // high school
    final educationalInstitutionName = useTextEditingController();
    final educationalInstitutionRoshMosadName = useTextEditingController();
    final educationalInstitutionRoshMosadPhone = useTextEditingController();
    // work
    final workStatus = useState('');
    final work = useTextEditingController();
    final workLocation = useTextEditingController();
    final workType = useTextEditingController();

    return Scaffold(
      appBar: const NewPersonaAppbar(title: 'הוספת חניך'),
      body: Padding(
        padding: Consts.defaultBodyPadding,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // https://trello.com/c/wGLVPUva/86-%D7%91%D7%90%D7%92-%D7%94%D7%95%D7%A1%D7%A4%D7%AA-%D7%9E%D7%A9%D7%AA%D7%9E%D7%A9
                    // if (selectedUserType != UserRole.apprentice) ...[
                    //   const SizedBox(height: 24),
                    //   InputFieldContainer(
                    //     label: 'תפקיד',
                    //     isRequired: true,
                    //     child: TextFormField(
                    //       validator: (value) {
                    //         if (value == null || value.isEmpty) {
                    //           return 'empty';
                    //         }

                    //         return null;
                    //       },
                    //       decoration: const InputDecoration(
                    //         hintText: 'בחר תפקיד',
                    //       ),
                    //     ),
                    //   ),
                    //   const SizedBox(height: 24),
                    // ],
                    NewPersonaCommonFields(
                      firstName: firstName,
                      lastName: lastName,
                      phone: phone,
                      institution: institution,
                    ),
                  ],
                ),
              ),
            ),
            AcceptCancelButtons(
              onPressedOk: () async {
                final result = await ref
                    .read(
                      usersControllerProvider.notifier,
                    )
                    .createManual(
                      persona: PersonaDto(
                        roles: [UserRole.apprentice],
                        firstName: firstName.text,
                        lastName: lastName.text,
                        phone: phone.text,
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
