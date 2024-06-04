import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/controllers/subordinate_scroll_controller.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
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
import 'package:syncfusion_flutter_charts/charts.dart';

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

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => _PdfExport(
                        institution: institution,
                        startDate: DateTime.now(),
                        endDate: DateTime.now(),
                      ),
                    ),
                  );

                  // import 'package:pdf/pdf.dart';
                  // import 'package:pdf/widgets.dart' as pw;
                  // final pdf = pw.Document();

                  // pdf.addPage(pw.Page(
                  //     pageFormat: PdfPageFormat.a4,
                  //     build: (pw.Context context) {
                  //       return pw.Center(
                  //         child: pw.Text('Hello World', style: pw.TextStyle(font: ttf, fontSize: 40)),
                  //       ); // Center
                  //     })); // Page

                  // final name = '${DateTime.now().toIso8601String()}.pdf';
                  // final output = await getTemporaryDirectory();
                  // final file = File("${output.path}/${name}");
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
                              newOrEditInstitutionControllerProvider(widget.id)
                                  .notifier,
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

class _PdfExport extends StatelessWidget {
  const _PdfExport({
    required this.institution,
    required this.startDate,
    required this.endDate,
  });

  final InstitutionDto institution;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColoredBox(
          color: AppColors.blue08,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      institution.name,
                      style: TextStyles.s20w500,
                    ),
                    Text(
                      'תאריכים: '
                      '${startDate.asDayMonthYearShortDot}'
                      ' - '
                      '${endDate.asDayMonthYearShortDot}',
                      style: TextStyles.s12w400cGrey2,
                    ),
                    Text(
                      'שם רכז: '
                      '${institution.rakazFirstName + institution.rakazLastName}',
                      style: TextStyles.s12w400cGrey2,
                    ),
                    Text(
                      'כמות חניכים: '
                      '${institution.apprentices.length}',
                      style: TextStyles.s12w400cGrey2,
                    ),
                  ]
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: e,
                        ),
                      )
                      .toList(),
                ),
                const Spacer(),
                if (institution.logo.isNotEmpty) ...[
                  const SizedBox(width: 20),
                  CachedNetworkImage(
                    imageUrl: institution.logo,
                    height: 40,
                  ),
                ],
                Assets.images.logo.image(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'כללי',
                    style: TextStyles.s16w500,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          border: Border.all(
                            color: AppColors.shades200,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: SfCircularChart(
                            backgroundColor: Colors.transparent,
                            title: const ChartTitle(
                              text: 'title',
                              alignment: ChartAlignment.center,
                              textStyle: TextStyles.s11w500,
                            ),
                            legend: Legend(
                              isVisible: true,
                              itemPadding: 0,
                              alignment: ChartAlignment.center,
                              position: LegendPosition.left,
                              overflowMode: LegendItemOverflowMode.wrap,
                              legendItemBuilder: (
                                legendText,
                                series,
                                point,
                                seriesIndex,
                              ) =>
                                  Padding(
                                padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ) +
                                    const EdgeInsets.only(right: 12),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 6,
                                      backgroundColor: seriesIndex == 0
                                          ? AppColors.chartRed
                                          : seriesIndex == 1
                                              ? AppColors.chartOrange
                                              : AppColors.chartGreen,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      legendText.split(':').first,
                                      style: TextStyles.s12w400cGrey2,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      legendText.split(':').last,
                                      style: TextStyles.s12w400cGrey4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            series: [
                              DoughnutSeries<({String x, double y}), String>(
                                explode: true,
                                radius: '100%',
                                innerRadius: '70%',
                                dataSource: const [],
                                xValueMapper: (datum, _) =>
                                    '${datum.x}:${datum.y.toInt()}',
                                yValueMapper: (datum, _) => datum.y,
                                legendIconType: LegendIconType.circle,
                                pointColorMapper: (datum, index) => index == 0
                                    ? AppColors.chartRed
                                    : index == 1
                                        ? AppColors.chartOrange
                                        : AppColors.chartGreen,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
