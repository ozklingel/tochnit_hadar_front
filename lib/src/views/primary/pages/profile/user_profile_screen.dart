import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/controllers/subordinate_scroll_controller.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/cards/details_card.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hadar_program/src/views/widgets/headers/details_page_header.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    null,
  ];

  @override
  void dispose() {
    super.dispose();
    for (final scrollController in scrollControllers) {
      scrollController?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userServiceProvider);

    final tabController = useTabController(
      initialLength: 3,
    );

    final views = [
      const _TohnitHadarTabView(),
      const _MilitaryServiceTabView(),
      const _PersonalInfoTabView(),
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
                      avatar: user.valueOrNull!.avatar,
                      name: user.valueOrNull!.fullName,
                      phone: user.valueOrNull!.phone,
                      onTapEditAvatar: () => Toaster.unimplemented(),
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
                      Tab(text: 'שירות צבאי'),
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
}

class _MilitaryServiceTabView extends HookConsumerWidget {
  const _MilitaryServiceTabView();

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);

    final isEditMode = useState(false);
    final baseController = useTextEditingController(
      text: user.valueOrNull!.avatar,
      keys: [user],
    );
    final unitController = useTextEditingController(
      text: user.valueOrNull!.avatar,
      keys: [user],
    );
    final positionNewController = useTextEditingController(
      text: user.valueOrNull!.avatar,
      keys: [user],
    );
    final positionOldController = useTextEditingController(
      text: user.valueOrNull!.avatar,
      keys: [user],
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
                        'צבא',
                        style: TextStyles.s20w400.copyWith(
                          color: AppColors.gray1,
                        ),
                      ),
                      const SizedBox(height: 32),
                      InputFieldContainer(
                        label: 'שם הבסיס',
                        isRequired: true,
                        child: TextField(
                          controller: baseController,
                        ),
                      ),
                      const SizedBox(height: 32),
                      InputFieldContainer(
                        label: 'שיוך יחידתי',
                        isRequired: true,
                        child: TextField(
                          controller: unitController,
                        ),
                      ),
                      const SizedBox(height: 32),
                      InputFieldContainer(
                        label: 'תפקיד נוכחי',
                        isRequired: true,
                        child: TextField(
                          controller: positionNewController,
                        ),
                      ),
                      const SizedBox(height: 32),
                      InputFieldContainer(
                        label: 'תפקיד קודם',
                        isRequired: true,
                        child: TextField(
                          controller: positionOldController,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: LargeFilledRoundedButton(
                              label: 'שמירה',
                              onPressed: () async {
                                // final result = await ref
                                //     .read(
                                //       usersControllerProvider.notifier,
                                //     )
                                //     .editApprentice(
                                //       user: apprentice.copyWith(
                                //         militaryCompoundId:
                                //             apprentice.militaryCompoundId,
                                //         militaryUnit: unitController.text,
                                //         militaryPositionNew:
                                //             positionNewController.text,
                                //         militaryPositionOld:
                                //             positionOldController.text,
                                //       ),
                                //     );

                                // if (result) {
                                //   isEditMode.value = false;
                                // } else {
                                //   Toaster.show(
                                //     'שגיאה בעת שמירת השינויים',
                                //   );
                                // }
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
                        data: user.valueOrNull!.avatar,
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: ' שם משפחה',
                        data: user.valueOrNull!.avatar,
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: ' כתובת מייל',
                        data: user.valueOrNull!.avatar,
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: ' תאריך יומהולדת',
                        data: user.valueOrNull!.avatar,
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: 'תאריך גיוס',
                        data: user.valueOrNull!.avatar,
                      ),
                      const SizedBox(height: 12),
                      DetailsRowItem(
                        label: 'תאריך שחרור',
                        data: user.valueOrNull!.avatar,
                      ),
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
    final user = ref.watch(userServiceProvider);
    final institution =
        ref.watch(institutionsControllerProvider).valueOrNull?.singleWhere(
                  (element) => element.id == user.valueOrNull!.institution,
                  orElse: () => const InstitutionDto(),
                ) ??
            const InstitutionDto();

    return Column(
      children: [
        DetailsCard(
          title: 'תוכנית הדר',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DetailsRowItem(
                label: 'מקום לימודים',
                data: institution.name,
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 12),
              const SizedBox(height: 12),
              const SizedBox(height: 12),
            ],
          ),
        ),
        if (user.valueOrNull?.role == UserRole.ahraiTohnit) ...[],
      ],
    );
  }
}

class _PersonalInfoTabView extends ConsumerWidget {
  const _PersonalInfoTabView();

  @override
  Widget build(BuildContext context, ref) {
    return const Column(
      children: [
        DetailsCard(
          title: 'כללי',
          child: Column(
            children: [
              SizedBox(height: 12),
              SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
