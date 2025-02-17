import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/string.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/users_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_user_pages/new_persona_appbar.dart';
import 'package:hadar_program/src/views/widgets/buttons/accept_cancel_buttons.dart';
import 'package:hadar_program/src/views/widgets/buttons/general_dropdown_button.dart';
import 'package:hadar_program/src/views/widgets/dialogs/missing_details_dialog.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewRakazMosadPage extends HookConsumerWidget {
  const NewRakazMosadPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final institutionController = useState(const InstitutionDto());
    final thInstitutionSearch = useTextEditingController();

    final children = [
      InputFieldContainer(
        label: 'שם פרטי',
        isRequired: true,
        child: TextFormField(
          controller: firstNameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'empty';
            }

            return null;
          },
          decoration: const InputDecoration(
            hintText: 'הזן את השם הפרטי המשתמש',
          ),
        ),
      ),
      InputFieldContainer(
        label: 'שם משפחה',
        isRequired: true,
        child: TextFormField(
          controller: lastNameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'empty';
            }

            return null;
          },
          decoration: const InputDecoration(
            hintText: 'הזן את שם המשפחה של המשתמש',
          ),
        ),
      ),
      InputFieldContainer(
        label: 'מספר טלפון',
        isRequired: true,
        child: Column(
          children: [
            TextFormField(
              controller: phoneController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'empty';
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: 'הזן מספר טלפון',
              ),
            ),
            const SizedBox(height: 6),
            const Row(
              children: [
                Text(
                  'הזן מספרים בלבד, ללא רווחים',
                  style: TextStyles.s12w500cGray5,
                ),
              ],
            ),
          ],
        ),
      ),
      InputFieldContainer(
        label: 'מוסד לימודים',
        isRequired: true,
        child: ref.watch(getInstitutionsProvider).when(
              loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              error: (error, stack) => Center(child: Text(error.toString())),
              data: (institutions) => GeneralDropdownButton<InstitutionDto>(
                stringMapper: (p0) => p0.name,
                value: institutionController.value.name.ifEmpty ??
                    'בחר מוסד לימודים',
                onChanged: (value) => institutionController.value =
                    value ?? const InstitutionDto(),
                items: institutions,
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    thInstitutionSearch.clear();
                  }
                },
                searchController: thInstitutionSearch,
                searchMatchFunction: (item, searchValue) =>
                    item.value.toString().toLowerCase().trim().contains(
                          searchValue.toLowerCase().trim(),
                        ),
              ),
            ),
      ),
    ];

    return Scaffold(
      appBar: const NewPersonaAppbar(title: 'הוספת רכז מוסד'),
      body: Padding(
        padding: Consts.defaultBodyPadding,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (_, __) => const SizedBox(height: 24),
                itemCount: children.length,
                itemBuilder: (context, index) => children[index],
              ),
            ),
            AcceptCancelButtons(
              showCancelButton: false,
              okText: 'שמירה',
              onPressedOk: () async {
                if (firstNameController.text.isEmpty ||
                    lastNameController.text.isEmpty ||
                    phoneController.text.isEmpty ||
                    institutionController.value.isEmpty) {
                  showMissingInfoDialog(context);

                  return;
                }

                final navContext = Navigator.of(context);

                final result = await ref
                    .read(
                      usersControllerProvider.notifier,
                    )
                    .createManual(
                      persona: PersonaDto(
                        roles: [UserRole.rakazMosad],
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        phone: phoneController.text,
                      ),
                    );

                if (result) {
                  // ignore: use_build_context_synchronously
                  const HomeRouteData().go(navContext.context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
