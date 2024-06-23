import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/api/eshkol/get_eshkols.dart';
import 'package:hadar_program/src/services/api/export_import/upload_file.dart';
import 'package:hadar_program/src/services/api/onboarding_form/city_list.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/general_dropdown_button.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/dialogs/missing_details_dialog.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hadar_program/src/views/widgets/states/loading_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _kEmptyFieldErrorMessage = 'נא למלא';

class NewOrEditInstitutionScreen extends HookConsumerWidget {
  const NewOrEditInstitutionScreen({
    super.key,
    this.id = '',
  });

  final String id;

  @override
  Widget build(BuildContext context, ref) {
    final institution =
        (ref.watch(institutionsControllerProvider).valueOrNull ?? [])
            .singleWhere(
      (element) => element.id == id,
      orElse: () => const InstitutionDto(),
    );
    final name = useTextEditingController(text: institution.name);
    final rakazPhone =
        useTextEditingController(text: institution.rakazContactPhoneNumber);
    final institutionPhoneNumber =
        useTextEditingController(text: institution.phoneNumber);
    final city = useState(institution.address.city);
    final citySearchController = useTextEditingController();
    final rakazName =
        useTextEditingController(text: institution.rakazFirstName);
    // final rakazLastName =
    //     useTextEditingController(text: institution.rakazLastName);
    final eshkol = useState(institution.eshkol);
    final roshMehina =
        useTextEditingController(text: institution.roshMehinaName);
    final roshPhoneNumber =
        useTextEditingController(text: institution.roshYeshivaPhoneNumber);
    final menahelAdministrativi =
        useTextEditingController(text: institution.adminName);
    final menahelAdministrativiPhone = useTextEditingController(
      text: institution.adminPhoneNumber,
    );
    final logo = useState(institution.logo);

    final children = [
      InputFieldContainer(
        label: 'שם מוסד',
        isRequired: true,
        child: TextFormField(
          controller: name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return _kEmptyFieldErrorMessage;
            }

            return null;
          },
          decoration: const InputDecoration(
            hintText: 'הזן את שם המוסד',
            hintStyle: TextStyles.s16w400cGrey5,
          ),
        ),
      ),
      InputFieldContainer(
        label: 'שם רכז מוסד',
        isRequired: true,
        child: TextFormField(
          controller: rakazName,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return _kEmptyFieldErrorMessage;
            }

            return null;
          },
          decoration: const InputDecoration(
            hintText: 'הזן את שם רכז המוסד',
            hintStyle: TextStyles.s16w400cGrey5,
          ),
        ),
      ),
      // InputFieldContainer(
      //   label: 'שם משפחה רכז מוסד',
      //   isRequired: true,
      //   child: TextFormField(
      //     controller: rakazLastName,
      //     validator: (value) {
      //       if (value == null || value.isEmpty) {
      //         return _kEmptyFieldErrorMessage;
      //       }

      //       return null;
      //     },
      //     decoration: const InputDecoration(
      //       hintText: 'הזן את שם המשפחה של רכז המוסד',
      //       hintStyle: TextStyles.s16w400cGrey5,
      //     ),
      //   ),
      // ),
      InputFieldContainer(
        label: 'מספר טלפון של רכז המוסד',
        isRequired: true,
        child: Column(
          children: [
            TextField(
              controller: rakazPhone,
              decoration: const InputDecoration(
                hintText: 'הזן מספר טלפון',
                hintStyle: TextStyles.s16w400cGrey5,
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
        label: 'מיקום',
        // isRequired: true,
        child: ref.watch(getCitiesListProvider).when(
              loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              error: (error, stack) => Center(
                child: Text(error.toString()),
              ),
              data: (cities) => GeneralDropdownButton<String>(
                value: city.value.isEmpty ? 'עיר/יישוב' : city.value,
                items: cities,
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    citySearchController.clear();
                  }
                },
                onChanged: (value) => city.value = value ?? '',
                searchController: citySearchController,
                searchMatchFunction: (item, searchValue) =>
                    item.value.toString().toLowerCase().trim().contains(
                          searchValue.toLowerCase().trim(),
                        ),
              ),
            ),
      ),
      InputFieldContainer(
        label: 'שלוחה/אשכול',
        isRequired: true,
        child: ref.watch(getEshkolListProvider).when(
              loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              error: (error, stack) => Center(
                child: Text(error.toString()),
              ),
              data: (eshkols) => GeneralDropdownButton<String>(
                value: eshkol.value.isEmpty ? 'שלוחה' : eshkol.value,
                items: eshkols,
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    citySearchController.clear();
                  }
                },
                onChanged: (value) => eshkol.value = value ?? '',
              ),
            ),
      ),
      InputFieldContainer(
        label: 'טלפון מוסד',
        // isRequired: true,
        child: TextField(
          controller: institutionPhoneNumber,
          decoration: const InputDecoration(
            hintText: 'הזן מספר טלפון',
            hintStyle: TextStyles.s16w400cGrey5,
          ),
          buildCounter: (
            context, {
            required currentLength,
            required isFocused,
            maxLength,
          }) =>
              const Row(
            children: [
              Text(
                'הזן מספרים בלבד, ללא רווחים',
                style: TextStyles.s12w500cGray5,
              ),
            ],
          ),
        ),
      ),
      InputFieldContainer(
        label: 'שם ראש מכינה',
        // isRequired: true,
        child: TextFormField(
          controller: roshMehina,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return _kEmptyFieldErrorMessage;
            }

            return null;
          },
          decoration: const InputDecoration(
            hintText: 'הזן את שם ושם המשפחה של ראש המכינה',
            hintStyle: TextStyles.s16w400cGrey5,
          ),
        ),
      ),
      InputFieldContainer(
        label: 'טלפון ראש מכינה',
        // isRequired: true,
        child: TextFormField(
          controller: roshPhoneNumber,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return _kEmptyFieldErrorMessage;
            }

            return null;
          },
          decoration: const InputDecoration(
            hintText: 'הזן מספר טלפון',
            hintStyle: TextStyles.s16w400cGrey5,
          ),
        ),
      ),
      InputFieldContainer(
        label: 'מנהל אדמינסטרטיבי',
        // isRequired: true,
        child: TextFormField(
          controller: menahelAdministrativi,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return _kEmptyFieldErrorMessage;
            }

            return null;
          },
          decoration: const InputDecoration(
            hintText: 'הזן את שם ושם המשפחה של מנהל אדמינסטרטיבי',
            hintStyle: TextStyles.s16w400cGrey5,
          ),
        ),
      ),
      InputFieldContainer(
        label: 'טלפון מנהל אדמינסטרטיבי',
        // isRequired: true,
        child: TextFormField(
          controller: menahelAdministrativiPhone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return _kEmptyFieldErrorMessage;
            }

            return null;
          },
          decoration: const InputDecoration(
            hintText: 'הזן מספר טלפון',
            hintStyle: TextStyles.s16w400cGrey5,
          ),
        ),
      ),
      InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            withData: true,
          );

          if (result == null) {
            return;
          }

          final uploadFileLocation = await ref.read(
            uploadFileProvider(result.files.first).future,
          );

          logo.value = uploadFileLocation;
        },
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          color: AppColors.gray5,
          child: SizedBox(
            height: 200,
            child: Center(
              child: logo.value.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FluentIcons.arrow_upload_24_regular),
                        SizedBox(height: 12),
                        Text(
                          'הוסף קובץ לוגו',
                          style: TextStyles.s14w500,
                        ),
                      ],
                    )
                  : CachedNetworkImage(
                      imageUrl: logo.value,
                      progressIndicatorBuilder: (context, url, progress) =>
                          const LoadingState(),
                    ),
            ),
          ),
        ),
      ),
      Builder(
        builder: (context) {
          return LargeFilledRoundedButton(
            label: 'שמירה',
            onPressed: () async {
              // final isValid = Form.of(context).validate();

              // if (!isValid) {
              //   Toaster.warning('יש למלא את כל השדות');

              //   return;
              // }

              if (name.text.isEmpty ||
                  rakazName.text.isEmpty ||
                  rakazPhone.text.isEmpty ||
                  eshkol.value.isEmpty) {
                showDialog(
                  context: context,
                  builder: (_) => const MissingInformationDialog(),
                );

                return;
              }

              final navContext = Navigator.of(context);

              final result = await ref
                  .read(institutionsControllerProvider.notifier)
                  .create(
                    institution.copyWith(
                      name: name.text,
                      rakazContactPhoneNumber: rakazPhone.text,
                      adminName: rakazName.text,
                      adminPhoneNumber: rakazPhone.text,
                      roshMehinaName: roshMehina.text,
                      phoneNumber: institutionPhoneNumber.text,
                      roshYeshivaPhoneNumber: roshPhoneNumber.text,
                      address: institution.address.copyWith(city: city.value),
                      rakazFirstName: rakazName.text,
                      // rakazLastName: rakazLastName.text,
                      eshkol: eshkol.value,
                      logo: logo.value,
                    ),
                  );

              if (result) {
                Toaster.show('Success');
                navContext.pop();
              }
            },
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('הוספת מוסד'),
        actions: const [
          CloseButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: e,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
