import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/controllers/subordinate_scroll_controller.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/models/filter.dto.dart';
import 'package:hadar_program/src/views/secondary/filter/filters_screen.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/cards/details_card.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hadar_program/src/views/widgets/headers/details_page_header.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InstitutionDetailsScreen extends StatefulHookConsumerWidget {
  const InstitutionDetailsScreen({
    super.key,
    this.id = '',
  });

  final String id;

  @override
  ConsumerState<InstitutionDetailsScreen> createState() =>
      _InstitutionDetailsScreenState();
}

class _InstitutionDetailsScreenState
    extends ConsumerState<InstitutionDetailsScreen> {
  final scrollControllers = <SubordinateScrollController?>[
    null,
    null,
  ];

  @override
  Widget build(BuildContext context) {
    final institution =
        (ref.watch(institutionsControllerProvider).valueOrNull ?? [])
            .singleWhere(
      (element) => element.id == widget.id,
      orElse: () => const InstitutionDto(),
    );
    final tabController = useTabController(initialLength: 2);

    final views = [
      _GeneralTab(institution: institution),
      _UsersTab(id: institution.id),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(institution.name),
        actions: [
          PopupMenuButton(
            offset: const Offset(0, 32),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => Toaster.unimplemented(),
                child: const Text('מחיקה מהמערכת'),
              ),
            ],
            icon: const Icon(FluentIcons.more_vertical_24_regular),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 320,
                collapsedHeight: 60,
                forceElevated: false,
                floating: false,
                snap: false,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DetailsPageHeader(
                      name: institution.name,
                      phone: institution.adminPhoneNumber,
                      onTapEditAvatar: () => Toaster.unimplemented(),
                    ),
                  ),
                ),
                bottom: TabBar(
                  controller: tabController,
                  tabs: const [
                    Tab(text: 'כללי'),
                    Tab(text: 'משתמשים'),
                  ],
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
                    'institution-${views[index].key}${views[index].toString()}',
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

class _UsersTab extends HookConsumerWidget {
  const _UsersTab({
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, ref) {
    final apprentices =
        ref.watch(apprenticesControllerProvider).valueOrNull?.where(
                  (element) => element.institutionId == id,
                ) ??
            [];
    final compounds = ref.watch(compoundControllerProvider).valueOrNull ?? [];
    final institutions =
        ref.watch(institutionsControllerProvider).valueOrNull ?? [];
    final filters = useState(const FilterDto());

    final children = [
      ...filters.value.roles.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => Toaster.unimplemented(),
        ),
      ),
      ...filters.value.years.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => Toaster.unimplemented(),
        ),
      ),
      ...filters.value.institutions.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => Toaster.unimplemented(),
        ),
      ),
      ...filters.value.periods.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => Toaster.unimplemented(),
        ),
      ),
      ...filters.value.eshkols.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => Toaster.unimplemented(),
        ),
      ),
      ...filters.value.statuses.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => Toaster.unimplemented(),
        ),
      ),
      ...filters.value.bases.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => Toaster.unimplemented(),
        ),
      ),
      ...filters.value.hativot.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => Toaster.unimplemented(),
        ),
      ),
      ...filters.value.regions.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => Toaster.unimplemented(),
        ),
      ),
      ...filters.value.regions.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => Toaster.unimplemented(),
        ),
      ),
      ...filters.value.cities.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => Toaster.unimplemented(),
        ),
      ),
    ];

    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 32,
          child: Row(
            children: [
              const SizedBox(width: 8),
              Stack(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FiltersScreen.institutions(
                          initFilters: filters.value,
                        ),
                      ),
                    ),
                    icon: const Icon(
                      FluentIcons.filter_add_20_regular,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: IgnorePointer(
                      child: CircleAvatar(
                        backgroundColor: AppColors.red1,
                        radius: 7,
                        child: Text(
                          filters.value.length.toString(),
                          style: TextStyles.s11w500fRoboto,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: children.length,
                  itemBuilder: (context, index) => Transform.scale(
                    scale: 0.9,
                    child: children[index],
                  ),
                  separatorBuilder: (context, index) => const SizedBox(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          child: ListView(
            shrinkWrap: true,
            children: apprentices.map(
              (e) {
                final compound = compounds.singleWhere(
                  (element) => element.id == e.militaryCompoundId,
                  orElse: () => const CompoundDto(),
                );

                final institution = institutions.singleWhere(
                  (element) => element.id == e.institutionId,
                  orElse: () => const InstitutionDto(),
                );

                return ListTileWithTagsCard(
                  avatar: e.avatar,
                  name: e.fullName,
                  onlineStatus: e.callStatus,
                  tags: [
                    ...e.tags,
                    institution.name,
                    compound.name,
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}

class _GeneralTab extends StatelessWidget {
  const _GeneralTab({
    required this.institution,
  });

  final InstitutionDto institution;

  @override
  Widget build(BuildContext context) {
    return DetailsCard(
      title: 'פרטי מוסד',
      trailing: IconButton(
        onPressed: () => Toaster.unimplemented(),
        icon: const Icon(FluentIcons.edit_24_regular),
      ),
      child: Column(
        children: [
          DetailsRowItem(
            label: 'שם מוסד',
            data: institution.name,
          ),
          const SizedBox(height: 12),
          DetailsRowItem(
            label: 'רכז מוסד',
            data: institution.rakazId,
          ),
          const SizedBox(height: 12),
          DetailsRowItem(
            label: 'טלפון רכז מוסד',
            data: institution.rakazPhoneNumber,
          ),
          const SizedBox(height: 12),
          DetailsRowItem(
            label: 'מיקום',
            data: institution.address.fullAddress,
          ),
          const SizedBox(height: 12),
          DetailsRowItem(
            label: 'שלוחה',
            data: institution.shluha,
          ),
          const SizedBox(height: 12),
          DetailsRowItem(
            label: 'טלפון',
            data: institution.adminPhoneNumber,
          ),
          const SizedBox(height: 12),
          DetailsRowItem(
            label: 'שם ראש מכינה',
            data: institution.roshMehinaName,
          ),
          const SizedBox(height: 12),
          DetailsRowItem(
            label: 'טלפון ראש מכינה',
            data: institution.roshMehinaPhoneNumber,
          ),
          const SizedBox(height: 12),
          DetailsRowItem(
            label: 'שם מנהל אדמינסטרטיבי',
            data: institution.adminName,
          ),
          const SizedBox(height: 12),
          DetailsRowItem(
            label: 'טלפון מנהל אדמינסטרטיבי',
            data: institution.adminPhoneNumber,
          ),
        ],
      ),
    );
  }
}
