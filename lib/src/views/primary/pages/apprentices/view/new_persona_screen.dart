import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_user_pages/import_new_users_from_excel.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_user_pages/new_ahrai_tohnit_page.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_user_pages/new_apprentice_page.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_user_pages/new_melave_page.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_user_pages/new_persona_appbar.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_user_pages/new_rakaz_eshkol_page.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_user_pages/new_rakaz_mosad_page.dart';
import 'package:hadar_program/src/views/widgets/buttons/accept_cancel_buttons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class NewPersonaScreen extends HookConsumerWidget {
  const NewPersonaScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider).valueOrNull ?? const AuthDto();
    final selectedUserType = useState(UserRole.apprentice);

    return Scaffold(
      appBar: const NewPersonaAppbar(
        title: 'הוספת משתמש',
      ),
      body: Padding(
        padding: Consts.defaultBodyPadding,
        child: Column(
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
                items: [
                  const DropdownMenuItem(
                    value: UserRole.apprentice,
                    child: Text('חניך'),
                  ),
                  if (![
                    UserRole.melave,
                  ].contains(auth.role))
                    const DropdownMenuItem(
                      value: UserRole.melave,
                      child: Text('מלווה'),
                    ),
                  if (![
                    UserRole.melave,
                    UserRole.rakazMosad,
                  ].contains(auth.role))
                    const DropdownMenuItem(
                      value: UserRole.rakazMosad,
                      child: Text('רכז מוסד'),
                    ),
                  if (![
                    UserRole.melave,
                    UserRole.rakazMosad,
                    UserRole.rakazEshkol,
                  ].contains(auth.role))
                    const DropdownMenuItem(
                      value: UserRole.rakazEshkol,
                      child: Text('רכז אשכול'),
                    ),
                  if (auth.role == UserRole.ahraiTohnit)
                    const DropdownMenuItem(
                      value: UserRole.ahraiTohnit,
                      child: Text('אחראי תוכנית'),
                    ),
                  if (auth.role == UserRole.ahraiTohnit)
                    const DropdownMenuItem(
                      value: UserRole.other,
                      child: Text('מוסד'),
                    ),
                ],
              ),
            ),
            const Spacer(),
            AcceptCancelButtons(
              onPressedOk: () => selectedUserType.value == UserRole.other
                  ? const InstitutionTypePickerRouteData().push(context)
                  : Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => _SelectDataFillTypeScreen(
                          userType: selectedUserType.value,
                        ),
                      ),
                    ),
              onPressedCancel: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectDataFillTypeScreen extends HookWidget {
  const _SelectDataFillTypeScreen({
    required this.userType,
  });

  final UserRole userType;

  @override
  Widget build(BuildContext context) {
    final isManual = useState(true);

    Logger().d(userType);

    return Scaffold(
      appBar: NewPersonaAppbar(
        title: switch (userType) {
          UserRole.apprentice => 'הוספת חניך',
          UserRole.melave => 'הוספת מלווה',
          UserRole.rakazMosad => 'הוספת רכז מוסד',
          UserRole.rakazEshkol => 'הוספת רכז אשכול',
          UserRole.ahraiTohnit => 'הוספת אחראי תכנית',
          _ => throw UnimplementedError(),
        },
      ),
      body: Padding(
        padding: Consts.defaultBodyPadding,
        child: Column(
          children: [
            const Text(
              'בחר את סוג הפעולה',
              style: TextStyles.s12w500cGray5,
            ),
            RadioListTile.adaptive(
              value: true,
              groupValue: isManual.value,
              onChanged: (val) => isManual.value = val!,
              title: const Text('הזנה ידנית'),
            ),
            RadioListTile.adaptive(
              value: false,
              groupValue: isManual.value,
              onChanged: (val) => isManual.value = val!,
              title: const Text('ייבוא נתונים מאקסל'),
            ),
            const Spacer(),
            AcceptCancelButtons(
              onPressedOk: () => isManual.value
                  ? Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => switch (userType) {
                          UserRole.apprentice => const NewApprenticePage(),
                          UserRole.melave => const NewMelavePage(),
                          UserRole.rakazMosad => const NewRakazMosadPage(),
                          UserRole.rakazEshkol => const NewRakazEshkolPage(),
                          UserRole.ahraiTohnit => const NewAhraiTohnitPage(),
                          _ => throw UnimplementedError(),
                        },
                      ),
                    )
                  : Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImportNewUsersFromExcel(
                          userType: userType,
                        ),
                      ),
                    ),
              onPressedCancel: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
