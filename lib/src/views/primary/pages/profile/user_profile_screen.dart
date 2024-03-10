import 'package:collection/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/controllers/subordinate_scroll_controller.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/core/utils/functions/launch_url.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/users_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/events_controller.dart';
import 'package:hadar_program/src/views/primary/pages/report/controller/reports_controller.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/cards/details_card.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hadar_program/src/views/widgets/headers/details_page_header.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileScreen extends StatefulHookConsumerWidget {
  const UserProfileScreen({
    super.key,
  });


  @override
  ConsumerState<UserProfileScreen> createState() =>
      _ApprenticeDetailsScreenState();
}

class _ApprenticeDetailsScreenState
    extends ConsumerState<UserProfileScreen> {
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
      _TohnitHadarTabView(),
      _MilitaryServiceTabView(),
      _PersonalInfoTabView(),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('פרופיל אישי '),
        actions: [
     
        ],
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
                      bottom: Column(
                        children: [
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                         
                            ],
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
                        data:  user.valueOrNull!.avatar,
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
    final reports = ref.watch(reportsControllerProvider).valueOrNull?.where(
              (element) => element.recipients.contains(user.valueOrNull!.id),
            ) ??
        [];
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
          trailing: TextButton.icon(
            onPressed: null,
            style: TextButton.styleFrom(
              disabledForegroundColor: AppColors.success600,
            ),
            icon: const Icon(Icons.check),
            label: const Text('משלם'),
          ),
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
        if (user.valueOrNull?.role == UserRole.ahraiTohnit) ...[
        
      
        ],
      
      ],
    );
  }
}





class _PersonalInfoTabView extends ConsumerWidget {
  const _PersonalInfoTabView();


  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);

    return Column(
      children: [
        DetailsCard(
          title: 'כללי',
          child: Column(
            children: [
             
              const SizedBox(height: 12),
            
           
              const SizedBox(height: 12),
             
            ],
          ),
        ),
      
   
    
    
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.relationship,
    required this.phone,
    required this.fullName,
    required this.email,
  });

  final String relationship;
  final String phone;
  final String fullName;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            style: TextStyles.s14w400,
            children: [
              TextSpan(
                text: relationship,
                style: const TextStyle(
                  color: AppColors.gray5,
                ),
              ),
              const TextSpan(text: '\t'),
              TextSpan(text: fullName),
            ],
          ),
        ),
        _ContactButtons(
          phone: phone,
          email: email,
        ),
      ],
    );
  }
}

class _ContactButtons extends ConsumerWidget {
  const _ContactButtons({
    required this.phone,
    required this.email,
  });

  final String phone;
  final String email;

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);

    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            phone,
            style: TextStyles.s14w400.copyWith(
              color: AppColors.gray2,
            ),
          ),
        ),
        const Spacer(),
        if (user.valueOrNull?.role == UserRole.ahraiTohnit) ...[
          _RowIconButton(
            onPressed: () => Toaster.unimplemented(),
            icon: const Icon(FluentIcons.edit_24_regular),
          ),
          _RowIconButton(
            onPressed: () => Toaster.unimplemented(),
            icon: const Icon(FluentIcons.delete_24_regular),
          ),
        ] else ...[
          _RowIconButton(
            onPressed: () => launchSms(phone: phone),
            icon: const Icon(FluentIcons.chat_24_regular),
          ),
          const SizedBox(width: 4),
          _RowIconButton(
            icon: Assets.icons.whatsapp.svg(
              height: 20,
            ),
            onPressed: () => launchWhatsapp(phone: phone),
          ),
          const SizedBox(width: 4),
          _RowIconButton(
            onPressed: () => launchPhone(phone: phone),
            icon: const Icon(FluentIcons.call_24_regular),
          ),
          const SizedBox(width: 4),
          _RowIconButton(
            onPressed: () => launchEmail(email: email),
            icon: const Icon(FluentIcons.mail_24_regular),
          ),
        ],
      ],
    );
  }
}

class _RowIconButton extends StatelessWidget {
  const _RowIconButton({
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(36),
      child: InkWell(
        borderRadius: BorderRadius.circular(36),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: icon,
        ),
      ),
    );
  }
}

class _MissingInformationDialog extends StatelessWidget {
  const _MissingInformationDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 320,
        child: ColoredBox(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close),
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'חסרים פרטים',
                        style: TextStyles.s24w400,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'מספר הטלפון לא מוזן במערכת,'
                        '\n'
                        'ולכן אין אפשרות להתקשר.',
                        style: TextStyles.s16w400cGrey2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                LargeFilledRoundedButton(
                  label: 'אישור',
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final Widget icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          style: IconButton.styleFrom(
            side: const BorderSide(
              color: AppColors.gray7,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          icon: icon,
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyles.s12w300cGray2,
        ),
      ],
    );
  }
}
