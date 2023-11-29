import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';

enum _DataFillType {
  manual,
  import,
}

enum _UserType {
  hanih,
  rakaz,
  melave,
}

class NewUserScreen extends HookWidget {
  const NewUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final title = useState('הוספת משתמש');
    final selectedUserType = useState(_UserType.hanih);
    final selectedDataFillType = useState(_DataFillType.manual);

    final pages = [
      _SelectUserTypePage(
        selectedUserType: selectedUserType,
      ),
      _SelectDataFillType(
        selecteDataType: selectedDataFillType,
      ),
      _FormOrImportPage(
        selectedDataType: selectedDataFillType.value,
        selectedUserType: selectedUserType.value,
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
                  if (pageController.hasClients &&
                      pageController.page == pages.length - 1)
                    Expanded(
                      child: LargeFilledRoundedButton(
                        label: 'שמירה',
                        onPressed: () {},
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

class _FormOrImportPage extends StatelessWidget {
  const _FormOrImportPage({
    super.key,
    required this.selectedUserType,
    required this.selectedDataType,
  });

  final _UserType selectedUserType;
  final _DataFillType selectedDataType;

  @override
  Widget build(BuildContext context) {
    switch (selectedDataType) {
      case _DataFillType.manual:
        return SingleChildScrollView(
          child: Column(
            children: [
              const _FormField(
                label: 'שם פרטי',
                hint: 'הזן את השם הפרטי המשתמש',
              ),
              const SizedBox(height: 24),
              const _FormField(
                label: 'שם משפחה',
                hint: 'הזן את שם המשפחה של המשתמש',
              ),
              const SizedBox(height: 24),
              const _FormField(
                label: 'מספר טלפון',
                hint: 'הזן מספר טלפון',
              ),
              const SizedBox(height: 24),
              const _FormField(
                label: 'שיוך למוסד',
                hint: 'מוסד',
              ),
              if (selectedUserType != _UserType.hanih) ...[
                const SizedBox(height: 24),
                const _FormField(
                  label: 'תפקיד',
                  hint: 'בחר תפקיד',
                ),
              ],
            ],
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
            DottedBorder(
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
          ],
        );
    }
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    super.key,
    required this.label,
    required this.hint,
  });

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            style: TextStyles.s12w500,
            children: [
              TextSpan(
                text: label,
                style: TextStyles.s12w500cGray5,
              ),
              const TextSpan(text: ' '),
              const TextSpan(
                text: '*',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyles.s16w400cGrey5,
          ),
        ),
      ],
    );
  }
}

class _SelectDataFillType extends StatelessWidget {
  const _SelectDataFillType({
    super.key,
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
    super.key,
    required this.selectedUserType,
  });

  final ValueNotifier<_UserType> selectedUserType;

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
          child: DropdownButton2<_UserType>(
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
                value: _UserType.hanih,
                child: Text('חניך'),
              ),
              DropdownMenuItem(
                value: _UserType.rakaz,
                child: Text('רכז'),
              ),
              DropdownMenuItem(
                value: _UserType.melave,
                child: Text('מלווה'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
