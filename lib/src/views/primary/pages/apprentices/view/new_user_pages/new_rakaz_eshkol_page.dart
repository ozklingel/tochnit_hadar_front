import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/api/eshkol/get_eshkols.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_user_pages/new_persona_common_fields.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewRakazEshkolPage extends HookConsumerWidget {
  const NewRakazEshkolPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final institutionController = useState(const InstitutionDto());
    final selectedEshkol = useState('');

    return Column(
      children: [
        NewPersonaCommonFields(
          firstName: firstNameController,
          lastName: lastNameController,
          phone: phoneController,
          institution: institutionController,
        ),
        const SizedBox(height: 24),
        InputFieldContainer(
          label: 'שיוך לאשכול',
          isRequired: true,
          child: ref.watch(getEshkolListProvider).when(
                loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                error: (error, stack) => Center(child: Text(error.toString())),
                data: (eshkols) => DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    hint: Text(
                      selectedEshkol.value.isEmpty
                          ? 'אשכול'
                          : selectedEshkol.value,
                      style: selectedEshkol.value.isEmpty
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
                      selectedEshkol.value = value ?? selectedEshkol.value;
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
                    items: eshkols
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
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
