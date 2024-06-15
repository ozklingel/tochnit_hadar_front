import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewPersonaCommonFields extends ConsumerWidget {
  const NewPersonaCommonFields({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.institution,
  });

  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController phone;
  final ValueNotifier<InstitutionDto> institution;

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        InputFieldContainer(
          label: 'שם פרטי',
          isRequired: true,
          child: TextFormField(
            controller: firstName,
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
            controller: lastName,
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
            controller: phone,
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
                error: (error, stack) => Center(child: Text(error.toString())),
                data: (institutions) => DropdownButtonHideUnderline(
                  child: DropdownButton2<InstitutionDto>(
                    hint: Text(
                      institution.value.isEmpty
                          ? 'מוסד'
                          : institution.value.name,
                      style: institution.value.isEmpty
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
                      institution.value = value ?? institution.value;
                    },
                    dropdownStyleData: const DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.grey6,
                        ),
                      ),
                      openMenuIcon: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          color: AppColors.grey6,
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
      ],
    );
  }
}
