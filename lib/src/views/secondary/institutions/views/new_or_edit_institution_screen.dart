import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/api/impor_export/upload_file.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    final phone = useTextEditingController(text: institution.adminPhoneNumber);
    final address =
        useTextEditingController(text: institution.address.fullAddress.trim());
    final rakazName = useTextEditingController(text: institution.rakazId);
    final rakazPhone =
        useTextEditingController(text: institution.rakazPhoneNumber);
    final roshMehina =
        useTextEditingController(text: institution.roshMehinaName);
    final roshPhoneNumber =
        useTextEditingController(text: institution.roshMehinaPhoneNumber);
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
        child: TextField(
          controller: name,
          decoration: const InputDecoration(
            hintText: 'הזן את השם הפרטי המשתמש',
            hintStyle: TextStyles.s16w400cGrey5,
          ),
        ),
      ),
      InputFieldContainer(
        label: 'טלפון מוסד',
        child: TextField(
          controller: phone,
          decoration: const InputDecoration(
            hintText: 'מוסד',
            hintStyle: TextStyles.s16w400cGrey5,
          ),
        ),
      ),
      InputFieldContainer(
        label: 'מיקום',
        isRequired: true,
        child: TextField(
          controller: address,
          decoration: const InputDecoration(
            hintText: 'מוסד',
            hintStyle: TextStyles.s16w400cGrey5,
          ),
        ),
      ),
      InputFieldContainer(
        label: 'שם רכז מוסד',
        isRequired: true,
        child: TextField(
          controller: rakazName,
          decoration: const InputDecoration(
            hintText: 'הזן את שם המשפחה של המשתמש',
            hintStyle: TextStyles.s16w400cGrey5,
          ),
        ),
      ),
      InputFieldContainer(
        label: 'מספר טלפון של רכז המוסד',
        isRequired: true,
        child: TextField(
          controller: rakazPhone,
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
        isRequired: true,
        child: TextField(
          controller: roshMehina,
          decoration: const InputDecoration(
            hintText: 'מוסד',
            hintStyle: TextStyles.s16w400cGrey5,
          ),
        ),
      ),
      InputFieldContainer(
        label: 'טלפון ראש מכינה',
        isRequired: true,
        child: TextField(
          controller: roshPhoneNumber,
          decoration: const InputDecoration(
            hintText: 'מוסד',
            hintStyle: TextStyles.s16w400cGrey5,
          ),
        ),
      ),
      InputFieldContainer(
        label: 'מנהל אדמינסטרטיבי',
        isRequired: true,
        child: TextField(
          controller: menahelAdministrativi,
          decoration: const InputDecoration(
            hintText: 'שם',
            hintStyle: TextStyles.s16w400cGrey5,
          ),
        ),
      ),
      InputFieldContainer(
        label: 'טלפון מנהל אדמינסטרטיבי',
        isRequired: true,
        child: TextField(
          controller: menahelAdministrativiPhone,
          decoration: const InputDecoration(
            hintText: 'שם',
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
                  : CachedNetworkImage(imageUrl: logo.value),
            ),
          ),
        ),
      ),
      LargeFilledRoundedButton(
        label: 'שמירה',
        onPressed: () async {
          final navContext = Navigator.of(context);

          final result = await ref
              .read(institutionsControllerProvider.notifier)
              .create(institution);

          if (result) {
            Toaster.show('Success');
            navContext.pop();
          }
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
        child: ListView.separated(
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
          separatorBuilder: (context, index) => const SizedBox(height: 24),
        ),
      ),
    );
  }
}
