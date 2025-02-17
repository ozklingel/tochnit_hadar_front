import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/core/utils/functions/launch_url.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/home_page/get_closest_events.dart';
import 'package:hadar_program/src/services/api/user_profile_form/get_personas.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/networking/http_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/primary/pages/chat_box/error_dialog.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/success_dialog.dart';
import 'package:hadar_program/src/views/widgets/buttons/delete_button.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/dialogs/success_dialog.dart';
import 'package:hadar_program/src/views/widgets/dialogs/upload_excel_dialog.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hadar_program/src/views/widgets/states/error_state.dart';
import 'package:hadar_program/src/views/widgets/states/loading_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
    return ref.watch(authServiceProvider).when(
          loading: () => const LoadingState(),
          error: (error, stack) => ErrorState(error),
          data: (auth) => switch (auth.role) {
            UserRole.melave => _MelaveBody(eventId: eventId),
            UserRole.ahraiTohnit => const _AhraiTohnitBody(),
            _ => throw ArgumentError(),
          },
        );
  }
}

class _AhraiTohnitBody extends HookConsumerWidget {
  const _AhraiTohnitBody();

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);
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
    final someRecordsFail = useState('');

    final pages = [
      _FormOrImportPage(
        someRecordsFail: someRecordsFail,
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
                    child: FutureBuilder(
                      future: HttpService.getUsedGifts(
                        auth.valueOrNull!.phone,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data.toString());
                        } else {
                          return const Text('Loading...');
                        }
                      },
                    ),
                  ),
                  const DeleteButton(
                    label: 'מחיקה',
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
                        File f = File(pages.first.files.value.first.path!);

                        var result = await HttpService.addGiftCodeExcel(f);
                        Logger().d("Result: $result");

                        if (!context.mounted) {
                          return;
                        }

                        if (result["result"] == 'success') {
                          // TODO(yam): make this properly strongly typed pls
                          someRecordsFail.value =
                              result["not_commited"].toString();
                          showFancyCustomDialogUploadExcel(
                            context: context,
                            apiResponse:
                                result["not_commited"].toString() == "[]"
                                    ? ApiResponse.success
                                    : ApiResponse.failure,
                            error: 'קודי מתנה הוזנו בהצלחה',
                          );
                        } else {
                          showAlertDialog(context);
                        }
                      },
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
}

class _MelaveBody extends HookConsumerWidget {
  const _MelaveBody({
    required this.eventId,
  });

  final String eventId;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);
    final event =
        (ref.watch(getClosestEventsProvider).valueOrNull ?? []).singleWhere(
      (element) {
        return element.id == eventId;
      },
      orElse: () => const EventDto(),
    );
    final couponCode = useState('');
    final apprentice =
        (ref.watch(getPersonasProvider).valueOrNull ?? []).firstWhere(
      (element) {
        return element.id == event.subject;
      },
      orElse: () => const PersonaDto(),
    );
    final compound =
        (ref.watch(compoundControllerProvider).valueOrNull ?? []).singleWhere(
      (element) => element.id == apprentice.militaryCompoundId,
      orElse: () => const CompoundDto(),
    );

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
                  Assets.images.gift.image(
                    height: 200,
                  ),
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [Consts.defaultBoxShadow],
                    ),
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
                              Expanded(
                                child: DetailsRowItem(
                                  label: 'בסיס',
                                  data: compound.name,
                                  dataWidth: 80,
                                  dataWrapperWidth: 100,
                                ),
                              ),
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
                              Expanded(
                                child: DetailsRowItem(
                                  label: 'ת”ז',
                                  data: apprentice.teudatZehut,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(FluentIcons.copy_24_regular),
                                color: AppColors.blue03,
                                onPressed: () async {
                                  await Clipboard.setData(
                                    ClipboardData(
                                      text: apprentice.teudatZehut,
                                    ),
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
                                dataWrapperWidth: 0,
                              ),
                              if (couponCode.value.isNotEmpty) ...[
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      await Clipboard.setData(
                                        const ClipboardData(text: ""),
                                      );

                                      Toaster.show(
                                        'הקוד הועתק',
                                        align: const Alignment(0, -0.8),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(couponCode.value),
                                        const Spacer(),
                                        const Icon(
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
                                    Toaster.isLoading(true);
                                    try {
                                      couponCode.value =
                                          await HttpService.getGift(
                                        auth.valueOrNull!.phone,
                                        compound.id,
                                        apprentice.teudatZehut,
                                      );
                                    } catch (e) {
                                      Logger()
                                          .e('failed get gift code', error: e);
                                      Sentry.captureException(e);
                                      Toaster.error(e);
                                    } finally {
                                      Toaster.isLoading(false);
                                    }
                                    Logger()
                                        .d("gift code : ${couponCode.value}");
                                  },
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
                        String result = await HttpService.deleteGift(
                          apprentice.id,
                          couponCode.value,
                        );
                        if (!context.mounted) return;
                        if (result == "success") {
                          showFancyCustomDialog(context);
                        } else {
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
                  label: 'מעבר לאתר כוורת',
                  onPressed: () async {
                    await launchGiftStore();
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const SuccessDialog(msg: 'המתנה סומנה כנשלחה'),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
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
    required this.someRecordsFail,
  });

  final UserRole selectedUserType;
  final ValueNotifier<List<PlatformFile>> files;
  final ValueNotifier<InstitutionDto> selectedInstitution;
  final ValueNotifier<bool> isLoading;
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final ValueNotifier<String> someRecordsFail;

  @override
  Widget build(BuildContext context, ref) {
    var selectedDataType = _DataFillType.import;
    switch (selectedDataType) {
      case _DataFillType.manual:
        return Form(
          key: formKey,
          child: const SingleChildScrollView(
            child: Column(
              children: [],
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
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    withData: true,
                    type: FileType.custom,
                    allowedExtensions: [
                      'xlsx',
                    ],
                  );

                  if (result != null) {
                    //Logger().d("request image: $result");

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
            if (someRecordsFail.value == '[]') ...[
              const SizedBox(height: 12),
              Card(
                color: AppColors.blue08,
                elevation: 0,
                child: ListTile(
                  leading: const Icon(FluentIcons.document_pdf_24_regular),
                  title: Text(
                    someRecordsFail.value,
                  ),
                ),
              ),
            ],
            if (someRecordsFail.value != '[]' &&
                someRecordsFail.value != '') ...[
              const SizedBox(height: 12),
              Card(
                color: AppColors.red1,
                elevation: 0,
                child: ListTile(
                  leading: const Icon(FluentIcons.document_pdf_24_regular),
                  title: Text(
                    "${someRecordsFail.value}לא הוכנס בשל שגיאה",
                  ),
                ),
              ),
            ],
          ],
        );
    }
  }
}

// class _SelectDataFillType extends StatelessWidget {
//   const _SelectDataFillType({
//     required this.selecteDataType,
//   });

//   final ValueNotifier<_DataFillType> selecteDataType;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Text(
//           'בחר את סוג הפעולה',
//           style: TextStyles.s12w500cGray5,
//         ),
//         RadioListTile.adaptive(
//           value: _DataFillType.manual,
//           groupValue: selecteDataType.value,
//           onChanged: (val) => selecteDataType.value = val!,
//           title: const Text('הזנה ידנית'),
//         ),
//         RadioListTile.adaptive(
//           value: _DataFillType.import,
//           groupValue: selecteDataType.value,
//           onChanged: (val) => selecteDataType.value = val!,
//           title: const Text('ייבוא נתונים מאקסל'),
//         ),
//       ],
//     );
//   }
// }

// class _SelectUserTypePage extends StatelessWidget {
//   const _SelectUserTypePage({
//     required this.selectedUserType,
//   });

//   final ValueNotifier<UserRole> selectedUserType;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         const Text.rich(
//           TextSpan(
//             children: [
//               TextSpan(text: 'בחירת סוג המשתמש'),
//               TextSpan(text: ' '),
//               TextSpan(
//                 text: '*',
//                 style: TextStyle(
//                   color: Colors.red,
//                 ),
//               ),
//             ],
//           ),
//           style: TextStyles.s12w500cGray5,
//         ),
//         const SizedBox(height: 6),
//         DropdownButtonHideUnderline(
//           child: DropdownButton2<UserRole>(
//             value: selectedUserType.value,
//             hint: const Text('בחירת סוג המשתמש'),
//             onMenuStateChange: (isOpen) {},
//             dropdownSearchData: const DropdownSearchData(
//               searchInnerWidgetHeight: 50,
//               searchInnerWidget: TextField(
//                 decoration: InputDecoration(
//                   focusedBorder: UnderlineInputBorder(),
//                   enabledBorder: InputBorder.none,
//                   prefixIcon: Icon(Icons.search),
//                   hintText: 'חיפוש',
//                   hintStyle: TextStyles.s14w400,
//                 ),
//               ),
//             ),
//             style: TextStyles.s16w400cGrey5,
//             buttonStyleData: ButtonStyleData(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(36),
//                 border: Border.all(
//                   color: AppColors.shades300,
//                 ),
//               ),
//               elevation: 0,
//               padding: const EdgeInsets.only(right: 8),
//             ),
//             onChanged: (value) {
//               selectedUserType.value = value ?? selectedUserType.value;
//             },
//             dropdownStyleData: const DropdownStyleData(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(16)),
//               ),
//             ),
//             iconStyleData: const IconStyleData(
//               icon: Padding(
//                 padding: EdgeInsets.only(left: 16),
//                 child: Icon(
//                   Icons.keyboard_arrow_down,
//                   color: AppColors.grey6,
//                 ),
//               ),
//               openMenuIcon: Padding(
//                 padding: EdgeInsets.only(left: 16),
//                 child: Icon(
//                   Icons.keyboard_arrow_up,
//                   color: AppColors.grey6,
//                 ),
//               ),
//             ),
//             items: const [
//               DropdownMenuItem(
//                 value: UserRole.apprentice,
//                 child: Text('חניך'),
//               ),
//               DropdownMenuItem(
//                 value: UserRole.rakazMosad,
//                 child: Text('רכז'),
//               ),
//               DropdownMenuItem(
//                 value: UserRole.melave,
//                 child: Text('מלווה'),
//               ),
//               DropdownMenuItem(
//                 value: UserRole.rakazEshkol,
//                 child: Text('רכז אשכול'),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
