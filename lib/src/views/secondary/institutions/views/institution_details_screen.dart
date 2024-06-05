import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/controllers/subordinate_scroll_controller.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/export_import/upload_file.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/secondary/filter/filters_screen.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institution_details_controller.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/new_or_edit_institution_controller.dart';
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
    final screenController = ref.watch(getInstitutionsProvider);
    final institutions = screenController.valueOrNull ?? [];
    final institution = institutions.singleWhere(
      (element) => element.id == widget.id,
      orElse: () => const InstitutionDto(),
    );
    final tabController = useTabController(initialLength: 2);

    final views = [
      _GeneralTab(institution: institution),
      _UsersTab(institutionId: institution.id),
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
                  // TODO(oz): add api
                  Toaster.backend();

                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => InstitutionPdfExport(
                  //       institution: institution,
                  //       startDate: DateTime.now(),
                  //       endDate: DateTime.now(),
                  //     ),
                  //   ),
                  // );

                  // final exportDelegate = ExportDelegate(
                  //   options: const ExportOptions(
                  //     pageFormatOptions: PageFormatOptions.a4(),
                  //   ),
                  // );

                  // const frameId = 'someFrameId';

                  // final uniqKey = UniqueKey();

                  // // needs to be rendered in the tree and offstage/visibility hacks don't work
                  // ExportFrame(
                  //   frameId: frameId,
                  //   exportDelegate: exportDelegate,
                  //   child: CaptureWrapper(
                  //     key: uniqKey,
                  //     child: InstitutionPdfExport(
                  //       institution: institution,
                  //       startDate: DateTime.now(),
                  //       endDate: DateTime.now(),
                  //     ),
                  //   ),
                  // );

                  // try {
                  //   final pdf =
                  //       await exportDelegate.exportToPdfDocument(frameId);

                  //   final path = await FileSaver.instance.saveAs(
                  //     name: DateTime.now().toIso8601String(),
                  //     ext: '.pdf',
                  //     mimeType: MimeType.pdf,
                  //     bytes: await pdf.save(),
                  //   );

                  //   Logger().d(path);
                  // } catch (e) {
                  //   Logger().e(e);
                  // }

                  // final page =
                  //     await exportDelegate.exportToPdfPage('someFrameId');

                  // final widget =
                  //     await exportDelegate.exportToPdfWidget('someFrameId');

                  // final pdf = pw.Document();

                  // pdf.addPage(
                  //   pw.Page(
                  //     pageFormat: PdfPageFormat.a4,
                  //     orientation: pw.PageOrientation.landscape,
                  //     build: (pw.Context context) {
                  //       return InstitutionPdfExport(
                  //         institution: institution,
                  //         startDate: DateTime.now(),
                  //         endDate: DateTime.now(),
                  //       ) as pw.Widget;
                  //     },
                  //   ),
                  // );

                  // final name = '${DateTime.now().toIso8601String()}.pdf';
                  // final output = await getDownloadsDirectory() ??
                  //     await getTemporaryDirectory();
                  // final file = File("${output.path}/$name");
                  // await file.writeAsBytes(await pdf.save());
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
                          onTapEditAvatar: () async {
                            final result = await FilePicker.platform.pickFiles(
                              allowMultiple: true,
                              withData: true,
                            );

                            if (result == null) {
                              return;
                            }

                            final uploadFileLocation = await ref.read(
                              uploadFileProvider(result.files.first).future,
                            );

                            final request = await ref
                                .read(
                                  newOrEditInstitutionControllerProvider(
                                    widget.id,
                                  ).notifier,
                                )
                                .updateLogo(uploadFileLocation);

                            if (request) {}
                          },
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
    required this.institutionId,
  });

  final String institutionId;

  @override
  Widget build(BuildContext context, ref) {
    useAutomaticKeepAlive();

    final users = ref
            .watch(institutionDetailsControllerProvider(id: institutionId))
            .valueOrNull
            ?.where(
              (element) => element.institutionId == institutionId,
            ) ??
        [];
    final compounds = ref.watch(compoundControllerProvider).valueOrNull ?? [];
    final institutions =
        ref.watch(institutionsControllerProvider).valueOrNull ?? [];
    final institution = institutions.singleWhere(
      (element) => element.id == institutionId,
      orElse: () => const InstitutionDto(),
    );
    final filters = useState(const FilterDto());

    // Logger().d(apprentices.length, error: institutionId);
    // Logger().d(institution.apprentices.length, error: institutionId);

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
          onSelected: (val) async {
            final newFilter = filters.value.copyWith(
              years:
                  filters.value.years.where((element) => element != e).toList(),
            );

            final request = await ref
                .read(
                  institutionDetailsControllerProvider(id: institutionId)
                      .notifier,
                )
                .filterUsers(newFilter);

            if (request) {
              filters.value = newFilter;
            }
          },
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
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                            MaterialPageRoute<FilterDto>(
                              builder: (context) {
                                return FiltersScreen.institutionUsers(
                                  initFilters: filters.value,
                                );
                              },
                            ),
                          ) ??
                          const FilterDto();

                      final request = await ref
                          .read(
                            institutionDetailsControllerProvider(
                              id: institutionId,
                            ).notifier,
                          )
                          .filterUsers(result);

                      if (request) {
                        filters.value = result;
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
        users.isEmpty
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
}

class _GeneralTab extends ConsumerWidget {
  const _GeneralTab({
    required this.institution,
  });

  final InstitutionDto institution;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);

    return DetailsCard(
      title: 'פרטי מוסד',
      trailing: auth.valueOrNull?.role != UserRole.ahraiTohnit
          ? null
          : IconButton(
              onPressed: () =>
                  EditInstitutionRouteData(id: institution.id).push(context),
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
