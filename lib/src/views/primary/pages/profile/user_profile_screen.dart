import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/controllers/subordinate_scroll_controller.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/cards/details_card.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hadar_program/src/views/widgets/headers/details_page_header.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../core/enums/address_region.dart';
import '../../../../models/persona/persona.dto.dart';
import '../../../../services/api/impor_export/upload_file.dart';
import '../../../../services/api/onboarding_form/city_list.dart';
import '../../../../services/routing/go_router_provider.dart';
import '../apprentices/controller/personas_controller.dart';

class UserProfileScreen extends StatefulHookConsumerWidget {
  const UserProfileScreen({
    super.key,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends ConsumerState<UserProfileScreen> {
  final scrollControllers = <SubordinateScrollController?>[
    null,
    null,
  ];

  File? galleryFile;
  final picker = ImagePicker();
  ImageProvider<Object>? profileimg;

  @override
  void dispose() {
    for (final scrollController in scrollControllers) {
      scrollController?.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authServiceProvider);

    final tabController = useTabController(
      initialLength: 2,
    );

    final views = [
      const _TohnitHadarTabView(),
      const _MilitaryServiceTabView(),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('פרופיל אישי '),
        actions: const [],
      ),
      // https://api.flutter.dev/flutter/widgets/NestedScrollView-class.html
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 380,
                  collapsedHeight: 60,
                  forceElevated: false,
                  floating: false,
                  snap: false,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: DetailsPageHeader(
                      avatar: auth.valueOrNull!.avatar,
                      name: auth.valueOrNull!.fullName,
                      phone: "0${auth.valueOrNull!.phone}",
                      onTapEditAvatar: () async {
                        final result = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          withData: true,
                        );

                        if (result == null) {
                          return;
                        }

                        final uploadUrl = await ref.read(
                          uploadFileProvider(result.files.first).future,
                        );

                        final user = auth.valueOrNull ?? const AuthDto();

                        final result2 = await ref.read(dioServiceProvider).put(
                              Consts.updateUser,
                              queryParameters: {
                                'userId': user.id,
                              },
                              data: jsonEncode({
                                'photo_path': uploadUrl,
                              }),
                            );

                        if (result2.data['result'] == 'success') {
                          Logger().d("success upload");
                          setState(() {});
                        }
                      },
                      bottom: const Column(
                        children: [
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [],
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    controller: tabController,
                    tabs: const [
                      Tab(text: 'תוכנית הדר'),
                      Tab(text: 'פרטים אישיים'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: List.generate(
            views.length,
            (index) => Builder(
              builder: (context) {
                final parentController = PrimaryScrollController.of(context);
                if (scrollControllers[index]?.parent != parentController) {
                  scrollControllers[index]?.dispose();
                  scrollControllers[index] =
                      SubordinateScrollController(parentController);
                }

                return CustomScrollView(
                  key: PageStorageKey<String>(
                    'apprentice-${views[index].key}${views[index].toString()}',
                  ),
                  controller: scrollControllers[index],
                  slivers: [
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: views[index],
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.only(bottom: 20),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future getImage(ImageSource img, user) async {
    final pickedFile = await picker.pickImage(source: img);

    XFile? xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);

          //HttpService.uploadPhoto(galleryFile!, user.valueOrNull!.phone);
          setState(() {
            var profileimg = FileImage(galleryFile!);
            Logger().d(profileimg);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            // is this context <<<
            const SnackBar(content: Text('Nothing is selected')),
          );
        }
      },
    );
  }
}

class _MilitaryServiceTabView extends HookConsumerWidget {
  const _MilitaryServiceTabView();

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);
    final user = auth.valueOrNull ?? const AuthDto();
    final selectedCity = useState('');
    final citySearchController = useTextEditingController();
    final selectedRegion = useState(AddressRegion.none);

    final institution =
        ref.watch(institutionsControllerProvider).valueOrNull?.singleWhere(
                  (element) => element.id == auth.valueOrNull!.institution,
                  orElse: () => const InstitutionDto(),
                ) ??
            const InstitutionDto();
    final isEditMode = useState(false);
    final firstNController = useTextEditingController(
      text: auth.valueOrNull!.firstName,
      keys: [auth],
    );
    final lastNController = useTextEditingController(
      text: auth.valueOrNull!.lastName,
      keys: [auth],
    );
    final emailController = useTextEditingController(
      text: auth.valueOrNull!.email,
      keys: [auth],
    );
    final mosadController = useTextEditingController(
      text: institution.name,
      keys: [auth],
    );
    final datOfBirthController = useTextEditingController(
      text: auth.valueOrNull!.dateOfBirth.substring(0, 10),
      keys: [auth],
    );
    final cityController = useTextEditingController(
      text: auth.valueOrNull!.city,
      keys: [auth],
    );
    final regionController = useTextEditingController(
      text: auth.valueOrNull!.region,
      keys: [auth],
    );
        final eshcolController = useTextEditingController(
      text: auth.valueOrNull!.cluster,
      keys: [auth],
    );

    return AnimatedSwitcher(
      duration: Consts.defaultDurationM,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          axis: Axis.horizontal,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        ),
      ),
      child: isEditMode.value
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(36)),
                        borderSide: BorderSide(
                          color: AppColors.gray5,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'פרטים אישיים',
                        style: TextStyles.s20w400.copyWith(
                          color: AppColors.gray1,
                        ),
                      ),
                      const SizedBox(height: 32),
                      InputFieldContainer(
                        label: 'שם פרטי',
                        isRequired: true,
                        child: TextField(
                          controller: firstNController,
                        ),
                      ),
                      const SizedBox(height: 32),
                      InputFieldContainer(
                        label: 'שפ משפחה',
                        isRequired: true,
                        child: TextField(
                          controller: lastNController,
                        ),
                      ),
                      const SizedBox(height: 32),
                      InputFieldContainer(
                        label: ' כתובת מייל',
                        isRequired: true,
                        child: TextField(
                          controller: emailController,
                        ),
                      ),
                      const SizedBox(height: 32),
                      InputFieldContainer(
                        label: ' תאריך יום הולדת',
                        isRequired: true,
                        child: TextField(
                          controller: datOfBirthController,
                        ),
                      ),
                      const SizedBox(height: 32),
                             InputFieldContainer(
                        label: '  עיר',
                        isRequired: true,
                        child:     ref.watch(getCitiesListProvider).when(
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
                                    ? auth.valueOrNull!.city
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
                                border: Border.all(color: Colors.black),
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
                  
                     
                      ),
              const SizedBox(height: 32),
                      if (auth.valueOrNull?.role == UserRole.melave||auth.valueOrNull?.role == UserRole.rakazMosad) ...[      InputFieldContainer(
                        label: '  מוסד',
                        isRequired: true,
                        child: TextField(
                        
                          readOnly: true,
                          controller: mosadController,
                        ),
                      ),],
             if (auth.valueOrNull?.role == UserRole.rakazEshkol) ...[      InputFieldContainer(
                        label: '  מוסד',
                        isRequired: true,
                        child: TextField(
                        
                          readOnly: true,
                          controller: eshcolController,
                        ),
                      ),],
                
                      const SizedBox(height: 32),

                      InputFieldContainer(
                        label: '  אזור',
                        isRequired: true,
                        child:           DropdownButtonHideUnderline(
                    child: DropdownButton2<AddressRegion>(
                      value: selectedRegion.value == AddressRegion.none
                          ? null
                          : selectedRegion.value,
                      hint: SizedBox(
                              width: 240,
                              child: Text(
                                selectedCity.value.isEmpty
                                    ? auth.valueOrNull!.region
                                    : selectedCity.value,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                      style: Theme.of(context).inputDecorationTheme.hintStyle,
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          border: Border.all(
                            color: const Color.fromARGB(255, 15, 7, 7),
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
                  
                      ),
               
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: LargeFilledRoundedButton(
                              label: 'שמירה',
                              onPressed: () async {
                                try {
                                  final result =
                                      await ref.read(dioServiceProvider).put(
                                            Consts.updateUser,
                                            queryParameters: {
                                              'userId': user.id,
                                            },
                                            data: jsonEncode({
                                              'city': cityController.text,
                                              'birthday':
                                                  datOfBirthController.text,
                                              'email': emailController.text,
                                              'last_name': lastNController.text,
                                              'name': firstNController.text,
                                            }),
                                          );

                                  if (result.data['result'] == 'success') {
                                    isEditMode.value = false;
                                  }
                                } catch (e) {
                                  Logger().e(
                                    'failed to update user',
                                    error: e,
                                  );
                                  Sentry.captureException(e);
                                  Toaster.error(e);
                                }
                              },
                              textStyle: TextStyles.s14w500,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: LargeFilledRoundedButton(
                              label: 'ביטול',
                              onPressed: () => isEditMode.value = false,
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.blue02,
                              textStyle: TextStyles.s14w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Column(
              children: [
                DetailsCard(
                  title: 'פרטים אישיים',
                  trailing: IconButton(
                    onPressed: () => isEditMode.value = true,
                    icon: const Icon(FluentIcons.edit_24_regular),
                  ),
                  child: Column(
                    children: [
                      DetailsRowItem(
                        label: 'שם פרטי',
                        data: auth.valueOrNull?.firstName ?? "אין",
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: ' שם משפחה',
                        data: auth.valueOrNull?.lastName ?? "אין",
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: ' כתובת מייל',
                        data: auth.valueOrNull?.email ?? "אין",
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: ' תאריך יומהולדת',
                        data: auth.valueOrNull?.dateOfBirth.substring(0, 10) ??
                            "אין",
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: ' עיר',
                        data: auth.valueOrNull!.city,
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: ' מוסד',
                        data: institution.name,
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: ' אזור',
                        data: auth.valueOrNull!.region,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _TohnitHadarTabView extends ConsumerWidget {
  const _TohnitHadarTabView();

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);

    final institution =
        ref.watch(institutionsControllerProvider).valueOrNull?.singleWhere(
                  (element) => element.id == auth.valueOrNull!.institution,
                  orElse: () => const InstitutionDto(),
                ) ??
            const InstitutionDto();

    return Column(
      children: [
        DetailsCard(
          title: ' כללי',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DetailsRowItem(
                label: 'סיווג משתמש',
                data: auth.valueOrNull?.role.index == 0 ? "מלווה" : "אין תפקיד",
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: ' שיוך מוסדי',
                data: institution.name,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: ' אשכול',
                data: auth.valueOrNull?.cluster ?? "לא משוייך",
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        
       if (auth.valueOrNull?.role == UserRole.melave) ...[
             DetailsCard(
          title: ' רשימת חניכים',
          child: Builder(
            builder: (context) {
              return Column(
                children: <Widget>[
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: auth.valueOrNull!.apprentices.length,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                    ) {
                      final apprentice = ref.watch(
                            personasControllerProvider.select(
                              (value) => value.value?.singleWhere(
                                (element) =>
                                    element.id ==
                                    auth.valueOrNull!.apprentices[index],
                                orElse: () => const PersonaDto(),
                              ),
                            ),
                          ) ??
                          const PersonaDto();
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          backgroundImage: AssetImage(
                            'assets/images/person.png',
                          ),
                        ),
                        title: Text(
                          apprentice.fullName,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => PersonaDetailsRouteData(id: apprentice.id)
                            .go(context),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              );
            },
          ),
        ),
        
        ],
      ],
    );
  }
}
