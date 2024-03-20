import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

enum _DataFillType {
  manual,
  import,
}

class NewUserScreen extends HookWidget {
  const NewUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final title = useState('הוספת משתמש');
    final selectedUserType = useState(UserRole.apprentice);
    final selectedDataFillType = useState(_DataFillType.manual);
    final selectedInstitution = useState(const InstitutionDto());
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final selectedFiles = useState<List<File>>([]);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    useListenable(firstNameController);
    useListenable(lastNameController);
    useListenable(phoneController);

    final pages = [
      _SelectUserTypePage(
        selectedUserType: selectedUserType,
      ),
      _SelectDataFillType(
        selecteDataType: selectedDataFillType,
      ),
      _FormOrImportPage(
        selectedInstitution: selectedInstitution,
        selectedDataType: selectedDataFillType.value,
        selectedUserType: selectedUserType.value,
        files: selectedFiles,
        formKey: formKey,
        firstNameController: firstNameController,
        lastNameController: lastNameController,
        phoneController: phoneController,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(title.value),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: pages,
              ),
            ),
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  if ((pageController.hasClients &&
                          pageController.page == pages.length - 1) ||
                      selectedFiles.value.isNotEmpty)
                    Expanded(
                      child: LargeFilledRoundedButton(
                        label: 'שמירה',
                        onPressed: firstNameController.text.isEmpty ||
                                lastNameController.text.isEmpty ||
                                phoneController.text.isEmpty ||
                                selectedInstitution.value.isEmpty
                            ? null
                            : () {
                                final isValidForm =
                                    formKey.currentState?.validate() ?? false;
                                if (!isValidForm) {
                                  return;
                                }

                                Toaster.unimplemented();
                              },
                      ),
                    )
                  else ...[
                    Expanded(
                      child: LargeFilledRoundedButton(
                        label: 'הבא',
                        onPressed: () => pageController.nextPage(
                          duration: Consts.defaultDurationM,
                          curve: Curves.linear,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: LargeFilledRoundedButton.cancel(
                        label: 'ביטול',
                        onPressed: () {
                          if ((pageController.page ?? 0) > 0) {
                            pageController.previousPage(
                              duration: Consts.defaultDurationM,
                              curve: Curves.linear,
                            );
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormOrImportPage extends ConsumerWidget {
  const _FormOrImportPage({
    required this.selectedUserType,
    required this.selectedDataType,
    required this.selectedInstitution,
    required this.files,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
  });

  final UserRole selectedUserType;
  final _DataFillType selectedDataType;
  final ValueNotifier<List<File>> files;
  final ValueNotifier<InstitutionDto> selectedInstitution;
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context, ref) {
    switch (selectedDataType) {
      case _DataFillType.manual:
        return Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
                InputFieldContainer(
                  label: 'מספר טלפון',
                  isRequired: true,
                  child: TextFormField(
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
                ),
                const SizedBox(height: 24),
                InputFieldContainer(
                  label: 'שיוך למוסד',
                  isRequired: true,
                  child: ref.watch(getInstitutionsProvider).when(
                        loading: () => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        error: (error, stack) =>
                            Center(child: Text(error.toString())),
                        data: (institutions) => DropdownButtonHideUnderline(
                          child: DropdownButton2<InstitutionDto>(
                            hint: Text(
                              selectedInstitution.value.isEmpty
                                  ? 'מוסד'
                                  : selectedInstitution.value.name,
                              style: selectedInstitution.value.isEmpty
                                  ? TextStyles.s16w400cGrey5
                                  : null,
                            ),
                            onMenuStateChange: (isOpen) {},
                            dropdownSearchData: const DropdownSearchData(
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: TextField(
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(),
                                  enabledBorder: InputBorder.none,
                                  prefixIcon: Icon(Icons.search),
                                  hintText: 'חיפוש',
                                  hintStyle: TextStyles.s14w400,
                                ),
                              ),
                            ),
                            style: TextStyles.s16w400cGrey5,
                            buttonStyleData: ButtonStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                border: Border.all(
                                  color: AppColors.shades300,
                                ),
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.only(right: 8),
                            ),
                            onChanged: (value) {
                              selectedInstitution.value =
                                  value ?? selectedInstitution.value;
                            },
                            dropdownStyleData: const DropdownStyleData(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: AppColors.grey6,
                                  ),
                                ),
                              ),
                              openMenuIcon: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: AppColors.grey6,
                                  ),
                                ),
                              ),
                            ),
                            items: institutions
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                ),
                if (selectedUserType != UserRole.apprentice) ...[
                  const SizedBox(height: 24),
                  InputFieldContainer(
                    label: 'תפקיד',
                    isRequired: true,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'empty';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'בחר תפקיד',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        );
      case _DataFillType.import:
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'העלאת קובץ נתוני חניכים',
              style: TextStyles.s16w400cGrey5,
            ),
            const SizedBox(height: 24),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                final result =
                    await FilePicker.platform.pickFiles(allowMultiple: true);

                if (result == null) {
                  return;
                }

                // TODO(noga-dev): upload files to backend storage then save the urls in the report
                try {
                  files.value = [
                    ...result.paths.map((path) => File(path!)).toList(),
                  ];
                } catch (e) {
                  Logger().e('file upload error', error: e);
                }
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                color: AppColors.gray5,
                child: const SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FluentIcons.arrow_upload_24_regular),
                        SizedBox(height: 12),
                        Text(
                          'הוסף קובץ',
                          style: TextStyles.s14w500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (files.value.isNotEmpty) ...[
              const SizedBox(height: 12),
              Card(
                color: AppColors.blue08,
                elevation: 0,
                child: ListTile(
                  leading: const Icon(FluentIcons.document_pdf_24_regular),
                  title: Text(
                    files.value.isEmpty
                        ? '[Empty]'
                        : files.value.first.uri.toString().split('/').last,
                  ),
                  subtitle: const LinearProgressIndicator(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  trailing: const Icon(Icons.close),
                ),
              ),
            ],
          ],
        );
    }
  }
}

class _SelectDataFillType extends StatelessWidget {
  const _SelectDataFillType({
    required this.selecteDataType,
  });

  final ValueNotifier<_DataFillType> selecteDataType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'בחר את סוג הפעולה',
          style: TextStyles.s12w500cGray5,
        ),
        RadioListTile.adaptive(
          value: _DataFillType.manual,
          groupValue: selecteDataType.value,
          onChanged: (val) => selecteDataType.value = val!,
          title: const Text('הזנה ידנית'),
        ),
        RadioListTile.adaptive(
          value: _DataFillType.import,
          groupValue: selecteDataType.value,
          onChanged: (val) => selecteDataType.value = val!,
          title: const Text('ייבוא נתונים מאקסל'),
        ),
      ],
    );
  }
}

class _SelectUserTypePage extends StatelessWidget {
  const _SelectUserTypePage({
    required this.selectedUserType,
  });

  final ValueNotifier<UserRole> selectedUserType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'בחירת סוג המשתמש'),
              TextSpan(text: ' '),
              TextSpan(
                text: '*',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
          style: TextStyles.s12w500cGray5,
        ),
        const SizedBox(height: 6),
        DropdownButtonHideUnderline(
          child: DropdownButton2<UserRole>(
            value: selectedUserType.value,
            hint: const Text('בחירת סוג המשתמש'),
            onMenuStateChange: (isOpen) {},
            dropdownSearchData: const DropdownSearchData(
              searchInnerWidgetHeight: 50,
              searchInnerWidget: TextField(
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(),
                  enabledBorder: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'חיפוש',
                  hintStyle: TextStyles.s14w400,
                ),
              ),
            ),
            style: TextStyles.s16w400cGrey5,
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: AppColors.shades300,
                ),
              ),
              elevation: 0,
              padding: const EdgeInsets.only(right: 8),
            ),
            onChanged: (value) {
              selectedUserType.value = value ?? selectedUserType.value;
            },
            dropdownStyleData: const DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            iconStyleData: const IconStyleData(
              icon: Padding(
                padding: EdgeInsets.only(left: 16),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.chevron_left,
                    color: AppColors.grey6,
                  ),
                ),
              ),
              openMenuIcon: Padding(
                padding: EdgeInsets.only(left: 16),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Icon(
                    Icons.chevron_left,
                    color: AppColors.grey6,
                  ),
                ),
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: UserRole.apprentice,
                child: Text('חניך'),
              ),
              DropdownMenuItem(
                value: UserRole.rakazMosad,
                child: Text('רכז'),
              ),
              DropdownMenuItem(
                value: UserRole.melave,
                child: Text('מלווה'),
              ),
              DropdownMenuItem(
                value: UserRole.rakazEshkol,
                child: Text('רכז אשכול'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
