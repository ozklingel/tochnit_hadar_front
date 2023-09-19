import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/secondary/onboarding/widgets/large_filled_rounded_button.dart';

import '../../../../core/constants/consts.dart';

enum _Region {
  none,
  center,
  jerusalem,
  north,
  south,
  yehuda,
}

class OnboardingPersonalDetails extends HookWidget {
  const OnboardingPersonalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final selectedDatetime = useState(DateTime.now());
    final cityController = useTextEditingController();
    final selectedRegion = useState(_Region.none);
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
                initialDate: selectedDatetime.value,
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: DateTime.now(),
              );

              if (newDate == null) {
                return;
              }

              selectedDatetime.value = newDate;
            },
            borderRadius: BorderRadius.circular(36),
            child: IgnorePointer(
              child: TextField(
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
          TextField(
            controller: cityController,
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
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              value: selectedRegion.value == _Region.none
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
                  selectedRegion.value = value ?? _Region.none,
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
                  value: _Region.center,
                  child: Text('אזור המרכז'),
                ),
                DropdownMenuItem(
                  value: _Region.jerusalem,
                  child: Text('ירושלים והסביבה'),
                ),
                DropdownMenuItem(
                  value: _Region.north,
                  child: Text('אזור הצפון'),
                ),
                DropdownMenuItem(
                  value: _Region.south,
                  child: Text('אזור הדרום'),
                ),
                DropdownMenuItem(
                  value: _Region.yehuda,
                  child: Text('יהודה ושומרון'),
                ),
              ],
            ),
          ),
          CheckboxListTile.adaptive(
            focusNode: FocusNode(skipTraversal: true),
            value: isTermsOfServiceAccepted.value,
            onChanged: (val) => isTermsOfServiceAccepted.value =
                !isTermsOfServiceAccepted.value,
            title: Row(
              children: [
                Text(
                  'אני מאשר את',
                  style: Theme.of(context).textTheme.bodyMedium!,
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
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      decoration: TextDecoration.underline,
                      fontVariations: const [
                        FontVariation('wght', 500),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          LargeFilledRoundedButton(
            label: 'המשך',
            onPressed: isTermsOfServiceAccepted.value
                ? () => Toaster.unimplemented()
                : null,
          ),
        ],
      ),
    );
  }
}
