import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/views/secondary/onboarding/controller/onboarding_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/consts.dart';

class OnboardingPage4PersonalDetails extends HookConsumerWidget {
  const OnboardingPage4PersonalDetails({
    super.key,
    required this.onSuccess,
  });

  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context, ref) {
    final emailController = useTextEditingController();
    final selectedDateOfBirth = useState(DateTime.now());
    final selectedCity = useState('');
    final selectedRegion = useState(AddressRegion.none);
    final isTermsOfServiceAccepted = useState(false);

    return FocusTraversalGroup(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Assets.images.logomark.image(),
          Text(
            'פרטים אישיים',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
          Text(
            'עוד כמה פרטים חשובים עלייך',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium!,
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              hintText: 'כתובת דוא”ל',
            ),
          ),
          InkWell(
            onTap: () async {
              final newDate = await showDatePicker(
                context: context,
                initialDate: selectedDateOfBirth.value,
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: DateTime.now(),
              );

              if (newDate == null) {
                return;
              }

              selectedDateOfBirth.value = newDate;
            },
            borderRadius: BorderRadius.circular(36),
            child: IgnorePointer(
              child: TextField(
                controller: TextEditingController(
                  text: selectedDateOfBirth.value.asDayMonthYearShortSlash,
                ),
                decoration: InputDecoration(
                  hintText: 'תאריך לידה',
                  hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(
                      Icons.calendar_month,
                      color: AppColors.grey6,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ref.watch(getCitiesListProvider).when(
                loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                error: (error, stack) => TextField(
                  onChanged: (value) => selectedCity.value = value,
                  decoration: const InputDecoration(
                    hintText: 'יישוב / עיר',
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.chevron_left,
                          color: AppColors.grey6,
                        ),
                      ),
                    ),
                  ),
                ),
                data: (citiesList) => DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    value:
                        selectedCity.value.isEmpty ? null : selectedCity.value,
                    hint: const Text('יישוב / עיר'),
                    style: Theme.of(context).inputDecorationTheme.hintStyle,
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(
                          color: AppColors.shade03,
                        ),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.only(right: 8),
                    ),
                    onChanged: (value) => selectedCity.value = value.toString(),
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
                    items: citiesList
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
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              value: selectedRegion.value == AddressRegion.none
                  ? null
                  : selectedRegion.value,
              hint: const Text('אזור מגורים'),
              style: Theme.of(context).inputDecorationTheme.hintStyle,
              buttonStyleData: ButtonStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(
                    color: AppColors.shade03,
                  ),
                ),
                elevation: 0,
                padding: const EdgeInsets.only(right: 8),
              ),
              onChanged: (value) =>
                  selectedRegion.value = value ?? AddressRegion.none,
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
              items: [
                DropdownMenuItem(
                  value: AddressRegion.center,
                  child: Text(AddressRegion.center.name),
                ),
                DropdownMenuItem(
                  value: AddressRegion.jerusalem,
                  child: Text(AddressRegion.jerusalem.name),
                ),
                DropdownMenuItem(
                  value: AddressRegion.north,
                  child: Text(AddressRegion.north.name),
                ),
                DropdownMenuItem(
                  value: AddressRegion.south,
                  child: Text(AddressRegion.south.name),
                ),
                DropdownMenuItem(
                  value: AddressRegion.yehuda,
                  child: Text(AddressRegion.yehuda.name),
                ),
              ],
            ),
          ),
          CheckboxListTile.adaptive(
            focusNode: FocusNode(skipTraversal: true),
            controlAffinity: ListTileControlAffinity.leading,
            value: isTermsOfServiceAccepted.value,
            onChanged: (val) => isTermsOfServiceAccepted.value =
                !isTermsOfServiceAccepted.value,
            title: Row(
              children: [
                const Text(
                  'אני מאשר את',
                  style: TextStyles.s11w400,
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          automaticallyImplyLeading: true,
                          centerTitle: true,
                          title: Text(
                            'תנאי שימוש באפליקציה',
                            style: Theme.of(context).textTheme.titleMedium!,
                          ),
                        ),
                        body: const SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(Consts.termsOfService),
                          ),
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    'תנאי השימוש ומדיניות הפרטיות',
                    style: TextStyles.s11w500.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          LargeFilledRoundedButton(
            label: 'המשך',
            onPressed: isTermsOfServiceAccepted.value
                ? () async {
                    final result = await ref
                        .read(onboardingControllerProvider.notifier)
                        .onboardingFillUserInfo(
                          email: emailController.text,
                          dateOfBirth: selectedDateOfBirth.value,
                          city: selectedCity.value,
                        );

                    if (result) {
                      onSuccess();
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
