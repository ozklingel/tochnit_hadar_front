import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/controllers/subordinate_scroll_controller.dart';
import 'package:hadar_program/src/core/utils/functions/launch_url.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/widgets/military_service_tab.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/widgets/persona_image_selector.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/widgets/personal_info_tab.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/widgets/tohnit_hadar_tab.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/headers/details_page_header.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonaDetailsScreen extends StatefulHookConsumerWidget {
  const PersonaDetailsScreen({
    super.key,
    required this.apprenticeId,
  });

  final String apprenticeId;

  @override
  ConsumerState<PersonaDetailsScreen> createState() =>
      _ApprenticeDetailsScreenState();
}

class _ApprenticeDetailsScreenState
    extends ConsumerState<PersonaDetailsScreen> {
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
    final auth = ref.watch(authServiceProvider);

    final controller = ref.watch(personasControllerProvider);

    final persona = (controller.valueOrNull ?? []).singleWhere(
      (element) => element.id == widget.apprenticeId,
      orElse: () => const PersonaDto(),
    );

    final tabController = useTabController(
      initialLength: 3,
    );

    // Logger().d(apprentice.militaryUnit, error: apprentice.id);

    final views = <Widget>[
      TohnitHadarTabView(persona: persona),
      PersonalInfoTabView(persona: persona),
      MilitaryServiceTabView(persona: persona),
    ];

    if (controller.isLoading) {
      return const CircularProgressIndicator.adaptive();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('כרטיס חניך'),
        actions: [
          if (auth.valueOrNull?.role == UserRole.ahraiTohnit)
            PopupMenuButton(
              offset: const Offset(0, 32),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return _DeletePersonaDialog(
                        apprenticeId: persona.id,
                      );
                    },
                  ),
                  child: const Text('מחיקה מהמערכת'),
                ),
              ],
              icon: const Icon(FluentIcons.more_vertical_24_regular),
            ),
          const SizedBox(width: 6),
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
                      avatar: persona.avatar,
                      name: '${persona.firstName} ${persona.lastName}',
                      phone: persona.phone.format,
                      onTapEditAvatar: () async => showModalBottomSheet(
                        context: context,
                        builder: (context) => PersonaImageSelector(persona),
                      ),
                      bottom: Column(
                        children: [
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _ActionButton(
                                text: 'שיחה',
                                icon: const Icon(FluentIcons.call_24_regular),
                                onPressed: () async {
                                  if (persona.phone.isEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (_) =>
                                          const _MissingInformationDialog(),
                                    );

                                    return;
                                  }

                                  final url =
                                      Uri.tryParse('tel:${persona.phone}') ??
                                          Uri.parse('');

                                  if (!await launchUrl(url)) {
                                    throw Exception('לא ניתן להתקשר למספר זה');
                                  }
                                },
                              ),
                              _ActionButton(
                                text: 'וואטסאפ',
                                icon: Assets.icons.whatsapp.svg(height: 20),
                                onPressed: () =>
                                    launchWhatsapp(phone: persona.phone),
                              ),
                              _ActionButton(
                                text: 'SMS',
                                icon: const Icon(FluentIcons.chat_24_regular),
                                onPressed: () =>
                                    launchSms(phone: [persona.phone]),
                              ),
                              _ActionButton(
                                text: 'דיווח',
                                icon: const Icon(
                                  FluentIcons.clipboard_task_24_regular,
                                ),
                                onPressed: () => ReportNewRouteData(
                                  initRecipients: [persona.id],
                                ).push(context),
                              ),
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

class _DeletePersonaDialog extends ConsumerWidget {
  const _DeletePersonaDialog({
    required this.apprenticeId,
  });

  final String apprenticeId;

  @override
  Widget build(BuildContext context, ref) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0) + const EdgeInsets.only(bottom: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CloseButton(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('מחיקת חניך', style: TextStyles.s24w400),
                    const SizedBox(height: 16),
                    const Text(
                      'פעולה זו תסיר את החניך מהמערכת.'
                      '\n\n'
                      'האם אתה בטוח שברצונך למחוק את החניך?',
                      style: TextStyles.s16w400cGrey3,
                    ),
                    const SizedBox(height: 48),
                    LargeFilledRoundedButton(
                      label: 'לא, השאר',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 16),
                    LargeFilledRoundedButton.cancel(
                      label: 'מחק',
                      onPressed: () async {
                        final navContext = Navigator.of(context);

                        final result = await ref
                            .read(personasControllerProvider.notifier)
                            .deletePersona(apprenticeId);

                        if (result) {
                          navContext.pop();
                          ref.read(goRouterServiceProvider).go('/personas');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
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
