import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/controllers/subordinate_scroll_controller.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/user_profile_form/get_personas.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/secondary/filter/filters_screen.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institution_details_controller.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/cards/details_card.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hadar_program/src/views/widgets/headers/details_page_header.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hadar_program/src/views/widgets/sheets/__image_selector_sheet.dart';
import 'package:hadar_program/src/views/widgets/states/loading_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
    final screenController =
        ref.watch(institutionDetailsControllerProvider(id: widget.id));
    final institution = screenController.valueOrNull ?? const InstitutionDto();
    final tabController = useTabController(initialLength: 2);

    final views = [
      _GeneralTab(institution: institution),
      _UsersTab(institution: institution),
    ];

    if (screenController.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(institution.name),
        actions: [
          PopupMenuButton(
            offset: const Offset(0, 32),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () async {
                  final result = await ref
                      .read(institutionsControllerProvider.notifier)
                      .getPdf(id: institution.id);

                  if (result.isEmpty) {
                    Toaster.warning('unknown error');

                    return;
                  }

                  try {
                    final name =
                        'institution-id-${institution.id}-report-${DateTime.now().toIso8601String().replaceAll(':', '-')}';
                    final file = Platform.isAndroid || Platform.isIOS
                        ? await FileSaver.instance.saveAs(
                            name: name,
                            bytes: Uint8List.fromList(result),
                            ext: 'pdf',
                            mimeType: MimeType.pdf,
                          )
                        : await FileSaver.instance.saveFile(
                            name: name,
                            bytes: Uint8List.fromList(result),
                            ext: 'pdf',
                            mimeType: MimeType.pdf,
                          );

                    Toaster.success('saved $file');
                  } catch (e) {
                    Logger()
                        .e('failed to save institution pdf to disk', error: e);
                    Sentry.captureException(e);
                    Toaster.error(e);
                  }
                },
                child: const Text('ייצוא דו"ח מוסד'),
              ),
              PopupMenuItem(
                onTap: () async {
                  final navContext = Navigator.of(context);
                  final result = await ref
                      .read(institutionsControllerProvider.notifier)
                      .delete(institution.id);
                  if (result) {
                    navContext.pop();
                  }
                },
                child: const Text('מחיקה מהמערכת'),
              ),
            ],
            icon: const Icon(FluentIcons.more_vertical_24_regular),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Stack(
        children: [
          NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
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
                          avatar: institution.logo,
                          onTapEditAvatar: () => showImageSelector(
                            context: context,
                            onImageUploaded: (url) async {
                              final result = await ref
                                  .read(
                                    institutionDetailsControllerProvider(
                                      id: widget.id,
                                    ).notifier,
                                  )
                                  .updateLogo(url);

                              return result;
                            },
                          ),
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
                    final parentController =
                        PrimaryScrollController.of(context);
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
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
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
        ],
      ),
    );
  }
}

class _UsersTab extends HookConsumerWidget {
  const _UsersTab({
    required this.institution,
  });

  final InstitutionDto institution;

  @override
  Widget build(BuildContext context, ref) {
    useAutomaticKeepAlive();

    final institutionController =
        ref.watch(institutionDetailsControllerProvider(id: institution.id));

    final compoundsController = ref.watch(compoundControllerProvider);
    final compounds = compoundsController.valueOrNull ?? [];
    final filter = useState(const FilterDto());
    final filteredUsers = useState<List<String>>([]);
    final usersController = ref.watch(getPersonasProvider);
    final users = (usersController.valueOrNull ?? [])
        .where(
          (element) => element.institutionId == institution.id,
        )
        .where(
          (element) => filter.value.isEmpty
              ? true
              : filteredUsers.value.contains(element.id),
        );

    Logger().d(ref.watch(getPersonasProvider).valueOrNull?.length);

    if (compoundsController.isLoading || institutionController.isLoading) {
      return const CircularProgressIndicator.adaptive();
    }

    // Logger().d(apprentices.length, error: institutionId);
    // Logger().d(institution.apprentices.length, error: institutionId);

    final filters = [
      ...filter.value.roles.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => filterResults(
            ref: ref,
            filter: filter,
            newFilter: filter.value.copyWith(
              roles:
                  filter.value.roles.where((element) => element != e).toList(),
            ),
            users: filteredUsers,
          ),
        ),
      ),
      ...filter.value.years.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => filterResults(
            ref: ref,
            filter: filter,
            newFilter: filter.value.copyWith(
              years:
                  filter.value.years.where((element) => element != e).toList(),
            ),
            users: filteredUsers,
          ),
        ),
      ),
      ...filter.value.institutions.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => filterResults(
            ref: ref,
            filter: filter,
            newFilter: filter.value.copyWith(
              institutions: filter.value.institutions
                  .where((element) => element != e)
                  .toList(),
            ),
            users: filteredUsers,
          ),
        ),
      ),
      ...filter.value.periods.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => filterResults(
            ref: ref,
            filter: filter,
            newFilter: filter.value.copyWith(
              periods: filter.value.periods
                  .where((element) => element != e)
                  .toList(),
            ),
            users: filteredUsers,
          ),
        ),
      ),
      ...filter.value.eshkols.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => filterResults(
            ref: ref,
            filter: filter,
            newFilter: filter.value.copyWith(
              eshkols: filter.value.eshkols
                  .where((element) => element != e)
                  .toList(),
            ),
            users: filteredUsers,
          ),
        ),
      ),
      ...filter.value.statuses.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => filterResults(
            ref: ref,
            filter: filter,
            newFilter: filter.value.copyWith(
              statuses: filter.value.statuses
                  .where((element) => element != e)
                  .toList(),
            ),
            users: filteredUsers,
          ),
        ),
      ),
      ...filter.value.bases.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => filterResults(
            ref: ref,
            filter: filter,
            newFilter: filter.value.copyWith(
              bases:
                  filter.value.bases.where((element) => element != e).toList(),
            ),
            users: filteredUsers,
          ),
        ),
      ),
      ...filter.value.hativot.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => filterResults(
            ref: ref,
            filter: filter,
            newFilter: filter.value.copyWith(
              hativot: filter.value.hativot
                  .where((element) => element != e)
                  .toList(),
            ),
            users: filteredUsers,
          ),
        ),
      ),
      ...filter.value.regions.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => filterResults(
            ref: ref,
            filter: filter,
            newFilter: filter.value.copyWith(
              regions: filter.value.regions
                  .where((element) => element != e)
                  .toList(),
            ),
            users: filteredUsers,
          ),
        ),
      ),
      ...filter.value.cities.map(
        (e) => FilterChip(
          label: Text(e),
          onSelected: (val) => filterResults(
            ref: ref,
            filter: filter,
            newFilter: filter.value.copyWith(
              cities:
                  filter.value.cities.where((element) => element != e).toList(),
            ),
            users: filteredUsers,
          ),
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
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                            MaterialPageRoute<FilterDto>(
                              builder: (context) {
                                return FiltersScreen.institutionUsers(
                                  initFilters: filter.value,
                                );
                              },
                            ),
                          ) ??
                          const FilterDto();

                      final request = await ref
                          .read(
                            institutionDetailsControllerProvider(
                              id: institution.id,
                            ).notifier,
                          )
                          .filterUsers(result);

                      if (request != null) {
                        // TODO(nogadev): should consolidate these
                        filter.value = result;
                        filteredUsers.value = request;
                      }
                    },
                    icon: const Icon(
                      FluentIcons.filter_add_20_regular,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: IgnorePointer(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 7.5,
                        child: filters.isEmpty
                            ? const CircleAvatar(
                                backgroundColor: AppColors.grey2,
                                radius: 6.5,
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: AppColors.red1,
                                radius: 7.6,
                                child: Text(
                                  filter.value.length.toString(),
                                  style: TextStyles.s11w500fRoboto,
                                ),
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
                  itemCount: filters.length,
                  itemBuilder: (context, index) => Transform.scale(
                    scale: 0.9,
                    child: filters[index],
                  ),
                  separatorBuilder: (context, index) => const SizedBox(),
                ),
              ),
            ],
          ),
        ),
        usersController.isLoading
            ? const LoadingState()
            : users.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('ריק'),
                  )
                : ListView(
                    shrinkWrap: true,
                    children: users.map(
                      (e) {
                        final compound = compounds.singleWhere(
                          (element) => element.id == e.militaryCompoundId,
                          orElse: () => const CompoundDto(),
                        );

                        return ListTileWithTagsCard(
                          avatar: e.avatar,
                          name: e.fullName,
                          onlineStatus: e.callStatus,
                          onTap: () =>
                              PersonaDetailsRouteData(id: e.id).push(context),
                          tags: [
                            ...e.tags,
                            institution.name,
                            compound.name,
                          ],
                        );
                      },
                    ).toList(),
                  ),
      ],
    );
  }

  void filterResults({
    required WidgetRef ref,
    required ValueNotifier<FilterDto> filter,
    required ValueNotifier<List<String>> users,
    required FilterDto newFilter,
  }) async {
    final request = await ref
        .read(
          institutionDetailsControllerProvider(
            id: institution.id,
          ).notifier,
        )
        .filterUsers(newFilter);

    if (request != null) {
      users.value = request;
      filter.value = newFilter;
    }
  }
}

class _GeneralTab extends ConsumerWidget {
  const _GeneralTab({
    required this.institution,
  });

  final InstitutionDto institution;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);

    return Column(
      children: [
        DetailsCard(
          title: 'פרטי מוסד',
          trailing: auth.valueOrNull?.role != UserRole.ahraiTohnit
              ? null
              : IconButton(
                  onPressed: () => EditInstitutionRouteData(id: institution.id)
                      .push(context),
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
        ),
        DetailsCard(
          title: '',
          child: TextButton(
            onPressed: () =>
                ChartsInstitutionRouteData(id: institution.id).push(context),
            child: const Text(
              'מדדים',
              style: TextStyles.s20w400cGrey1,
            ),
          ),
        ),
      ],
    );
  }
}
