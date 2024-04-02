import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/success_dialog.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/dialogs/success_dialog.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../../core/constants/consts.dart';
import '../../../../../models/institution/institution.dto.dart';
import '../../../../../models/user/user.dto.dart';
import '../../../../../services/api/institutions/get_institutions.dart';
import '../../../../../services/auth/user_service.dart';
import '../../../../../services/networking/http_service.dart';
import '../../../../widgets/buttons/delete_button.dart';
import '../../../../widgets/fields/input_label.dart';
import '../../apprentices/controller/users_controller.dart';
import '../../chat_box/error_dialog.dart';
import 'widgets/success_dialog_addGift.dart';
enum _DataFillType {
  manual,
  import,
}
class GiftScreen extends HookConsumerWidget {

  const GiftScreen({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);
if (user.valueOrNull?.role == UserRole.melave) {
      var res=useState("");
    final apprentice =
        ref.watch(apprenticesControllerProvider).valueOrNull?.firstWhere(
                  (element) => element.events.any((e) => e.id == eventId),
                  orElse: () => const ApprenticeDto(),
                ) ??
            const ApprenticeDto();
    final compound =
        ref.watch(compoundControllerProvider).valueOrNull?.singleWhere(
                  (element) => element.id == apprentice.militaryCompoundId,
                  orElse: () => const CompoundDto(),
                ) ??
            const CompoundDto();

    final isShowCouponCode = useState(false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('שליחת מתנה'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    FluentIcons.gift_24_regular,
                    color: AppColors.blue05,
                    size: 40,
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          DetailsRowItem(
                            label: 'חניך',
                            data: apprentice.fullName,
                          ),
                          const SizedBox(height: 12),
                          DetailsRowItem(
                            label: 'תאריך יום הולדת',
                            data: apprentice.dateOfBirth.asDateTime.he,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              DetailsRowItem(
                                label: 'בסיס',
                                data: compound.name,
                                dataWidth: 100,
                              ),
                              const Spacer(),
                              Text.rich(
                                TextSpan(
                                  style: TextStyles.s14w400.copyWith(
                                    color: AppColors.gray6,
                                  ),
                                  children: [
                                    const TextSpan(text: 'עודכן'),
                                    const TextSpan(text: ' '),
                                    TextSpan(
                                      text: apprentice.militaryUpdatedDateTime
                                          .asDateTime.asDayMonthYearShortDot,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              DetailsRowItem(
                                label: 'ת”ז',
                                data: apprentice.teudatZehut,
                                dataWidth: 100,
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(FluentIcons.copy_24_regular),
                                color: AppColors.blue03,
                                onPressed: () async {
                                  await Clipboard.setData(
                                    ClipboardData(text: apprentice.teudatZehut),
                                  );

                                  Toaster.show(
                                    'הקוד הועתק',
                                    align: const Alignment(0, -0.8),
                                  );
                                },
                              ),
                              const SizedBox(width: 4),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const DetailsRowItem(
                                label: 'קוד קופון למתנה',
                                data: '',
                                dataWidth: 0,
                              ),
                              if (isShowCouponCode.value) ...[
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                        await Clipboard.setData(
                                         ClipboardData(text:  ""),
                                      );

                                      Toaster.show(
                                        'הקוד הועתק',
                                        align: const Alignment(0, -0.8),
                                      );
                                    },
                                    child:  Row(
                                      children: [
                                        Text(res.value),
                                        Spacer(),
                                        Icon(
                                          FluentIcons.copy_24_regular,
                                          color: AppColors.blue03,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ] else
                                TextButton(
                                  child: Text(
                                    'לחץ כאן לקבל קוד קופון למתנה',
                                    style: TextStyles.s14w400.copyWith(
                                      color: AppColors.blue03,
                                    ),
                                  ),
                                  onPressed: () async {
                                        res.value = await HttpService.getGift(user.valueOrNull!.phone,compound,apprentice.teudatZehut); 
                                            Logger().d("gift code : $res");
            
                                      isShowCouponCode.value = true;
                                      }
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'על מנת להשלים את תהליך שליחת המתנה לחניך, יש לעבור לקישור חיצוני של אתר כוורת.'
                    '\n\n'
                    'באתר תידרש להזין:'
                    '\n'
                    '1. פרטים אישיים שלך'
                    '\n'
                    '2. פרטים אישיים של החניך (כולל ת”ז ובסיס)'
                    '\n'
                    '3. ברכת יום הולדת'
                    '\n'
                    '4. הזנה של קוד הקופון למתנה',
                  ),
                  const SizedBox(height: 16),
                  const Text('כבר שלחת לחניך את המתנה? מעולה!'),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: () async { 
                       String result =await HttpService.delete_gift(apprentice.id,res.value);
                if (result == "success") {
                  // print("in");
                  // ignore: use_build_context_synchronously
                  showFancyCustomDialog(context);
                } else {
                  // print("in");

                  // ignore: use_build_context_synchronously
                  showAlertDialog(context);
                }
                      },
                      child: const Text('לחץ כאן לביטול ההתראות הבאות'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: LargeFilledRoundedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const SuccessDialog(msg: 'המתנה סומנה כנשלחה'),
                    );
                  },
                  label: 'מעבר לאתר כוורת',
                ),
              ),
            ),
          ),
        ],
      ),
    );
}    else if (user.valueOrNull?.role == UserRole.ahraiTohnit) {
        final pageController = usePageController();
    final selectedUserType = useState(UserRole.apprentice);
    final selectedInstitution = useState(const InstitutionDto());
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final selectedFiles = useState<List<PlatformFile>>([]);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final isLoading = useState(false);
    useListenable(firstNameController);
    useListenable(lastNameController);
    useListenable(phoneController);

    final pages = [
    
  
      _FormOrImportPage(
        selectedInstitution: selectedInstitution,
        selectedUserType: selectedUserType.value,
        isLoading: isLoading,
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
        title: const Text(' ניהול קודי מתנה'),
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
                        SizedBox(
              height: 80,
              child: Row(
                children: [
               
                             Expanded(
                      child: Text(
                         'מןמשו 2 מתוך 45 קודים',
                            
                      ),
                    ), 
                    
                      
                     delete_button(
                        label: 'מחיקה',
                            onPressed: () async {
                              print("object");
 String result =await HttpService.delete_gift_all(user.valueOrNull?.id);
                if (result == "success") {
                  // print("in");
                  // ignore: use_build_context_synchronously
                  showFancyCustomDialog(context);
                } else {
                  // print("in");

                  // ignore: use_build_context_synchronously
                  
                                }}
                      ),
                  
                
                  
                ],
              ),
            ),
          
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
               
                  
                    Expanded(
                      child: LargeFilledRoundedButton(
                        label: 'שמירה',
                            onPressed: () async {
                                        File f= File(pages.first.files.value.first.path!);

                                        var res = await HttpService.add_giftCode_excel(f ); 
                                            Logger().d("gift code : $res");
                                                   if (res == "success") {
     
                  showFancyCustomDialog_addGift(context);
                } else {

                  showAlertDialog(context);
                }
                                      }
                      ),
                    ),
                
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
    }
else return Text("data");}
}



class _FormOrImportPage extends HookConsumerWidget {
  const _FormOrImportPage({
    required this.selectedUserType,
    required this.selectedInstitution,
    required this.isLoading,
    required this.files,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
  });

  final UserRole selectedUserType;
  final ValueNotifier<List<PlatformFile>> files;
  final ValueNotifier<InstitutionDto> selectedInstitution;
  final ValueNotifier<bool> isLoading;
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;


  @override
  Widget build(BuildContext context, ref) {
    var selectedDataType=_DataFillType.import;
    switch (selectedDataType) {
      case _DataFillType.manual:
        return Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
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
              'העלאת קובץ קודי מתנה',
              style: TextStyles.s16w400cGrey5,
            ),
            const SizedBox(height: 24),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                isLoading.value = true;

                try {
                  var result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    withData: true,
                    type: FileType.custom,
                    allowedExtensions: [
                      'xlsx',
                    ],
                  );

                  if (result != null) {
                        Logger().d("request image: $result");

                    files.value = [
                      ...result.files,
                    ];
                  }
                } catch (e) {
                  Logger().e('file upload error', error: e);
                  Sentry.captureException(e);
                  Toaster.error(e);
                }

                isLoading.value = false;
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                color: AppColors.gray5,
                child: SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (files.value.isEmpty) ...[
                          const Icon(FluentIcons.arrow_upload_24_regular),
                          const SizedBox(height: 12),
                          const Text(
                            'הוסף קובץ',
                            style: TextStyles.s14w500,
                          ),
                        ] else ...[
                          Text(
                            files.value.first.name,
                            style: TextStyles.s14w500,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isLoading.value) ...[
              const SizedBox(height: 12),
              Card(
                color: AppColors.blue08,
                elevation: 0,
                child: ListTile(
                  leading: const Icon(FluentIcons.document_pdf_24_regular),
                  title: Text(
                    files.value.isEmpty
                        ? '[Empty]'
                        : files.value.first.name.toString().split('/').last,
                  ),
                  subtitle: const LinearProgressIndicator(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      files.value = [];
                      isLoading.value = false;
                    },
                  ),
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
