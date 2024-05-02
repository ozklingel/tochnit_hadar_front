import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/enums/address_region.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/services/api/onboarding_form/city_list.dart';
import 'package:hadar_program/src/views/secondary/onboarding/controller/onboarding_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnboardingPagePersonalDetails extends HookConsumerWidget {
  const OnboardingPagePersonalDetails({
    super.key,
    required this.onSuccess,
  });

  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final selectedDateOfBirth = useState<DateTime?>(null);
    final selectedCity = useState('');
    final selectedRegion = useState(AddressRegion.none);
    final isTermsOfServiceAccepted = useState(false);
    // final isTermsOfServiceAccepted = useState(false);
    // final isTermsOfServiceAccepted = useState(false);
    // final isTermsOfServiceAccepted = useState(false);

    final citySearchController = useTextEditingController();
    return FutureBuilder<bool>(
      future:
          ref.read(onboardingControllerProvider.notifier).verifyRegistered(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(height: 100, child: Assets.images.loader.image()),
          );
        } else if (!snapshot.hasError && snapshot.hasData && snapshot.data!) {
          onSuccess();
          return Container(); // Return an empty container or your desired next screen widget
        } else {
          return FocusTraversalGroup(
            child: SingleChildScrollView(
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
                  const SizedBox(height: 12),
                  Text(
                    'עוד כמה פרטים חשובים עלייך',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium!,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null) {
                        return null;
                      }

                      if (RegExp(
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                      ).hasMatch(value)) {
                        return 'אימייל לא תקין';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'כתובת דוא”ל',
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      final newDate = await showDatePicker(
                        context: context,
                        initialDate:
                            selectedDateOfBirth.value ?? DateTime.now(),
                        firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Colors.white,
                                onPrimary: AppColors.blue01,
                                surface: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
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
                          text: selectedDateOfBirth
                              .value?.asDayMonthYearShortSlash,
                        ),
                        decoration: InputDecoration(
                          hintText: 'תאריך לידה',
                          hintStyle:
                              Theme.of(context).inputDecorationTheme.hintStyle,
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
                  const SizedBox(height: 12),
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
                        data: (cities) => DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            hint: SizedBox(
                              width: 240,
                              child: Text(
                                selectedCity.value.isEmpty
                                    ? 'יישוב / עיר'
                                    : selectedCity.value,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            style: Theme.of(context)
                                .inputDecorationTheme
                                .hintStyle,
                            buttonStyleData: ButtonStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                border: Border.all(color: AppColors.shade04),
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.only(right: 8),
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController: citySearchController,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: TextField(
                                controller: citySearchController,
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(),
                                  enabledBorder: InputBorder.none,
                                  prefixIcon: Icon(Icons.search),
                                  hintText: 'חיפוש',
                                  hintStyle: TextStyles.s14w400,
                                ),
                              ),
                              searchMatchFn: (item, searchValue) {
                                return item.value
                                    .toString()
                                    .toLowerCase()
                                    .trim()
                                    .contains(searchValue.toLowerCase().trim());
                              },
                            ),
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                citySearchController.clear();
                              }
                            },
                            onChanged: (value) {
                              selectedCity.value = value!;
                            },
                            dropdownStyleData: const DropdownStyleData(
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                            items: cities
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
                  const SizedBox(height: 12),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<AddressRegion>(
                      value: selectedRegion.value == AddressRegion.none
                          ? null
                          : selectedRegion.value,
                      hint: const Text('אזור מגורים'),
                      style: Theme.of(context)
                          .inputDecorationTheme
                          .hintStyle!
                          .copyWith(color: Theme.of(context).hintColor),
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          border: Border.all(
                            color: AppColors.shade04,
                          ),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.only(right: 8),
                      ),
                      onChanged: (value) =>
                          selectedRegion.value = value ?? AddressRegion.none,
                      dropdownStyleData: const DropdownStyleData(
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                  ListTile(
                    focusNode: FocusNode(skipTraversal: true),
                    leading: Checkbox(
                      value: isTermsOfServiceAccepted.value,
                      onChanged: (val) => isTermsOfServiceAccepted.value =
                          !isTermsOfServiceAccepted.value,
                    ),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!,
                                  ),
                                ),
                                body: const SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.all(24),
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
                                  dateOfBirth: selectedDateOfBirth.value ??
                                      DateTime.now(),
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
            ),
          );
        }
      },
    );
  }
}
