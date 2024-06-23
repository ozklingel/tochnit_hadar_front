import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/export_excel_bar.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/percentage_list_tile_with_tags_widget.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/performance_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PersonaPerformanceByInstitutionScreen extends HookConsumerWidget {
  const PersonaPerformanceByInstitutionScreen({
    super.key,
    this.title = '',
    this.institutionId = '',
  });

  final String title;
  final String institutionId;

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          title,
          style: TextStyles.s20w500,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            // TODO(noga)
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const Column(
        children: [
          ExportToExcelBar(),
          Expanded(
            child: AnimatedSwitcher(
              duration: Consts.defaultDurationXL,
              child: PerformanceBody(
                children: [PercentageListTileWithTagsWidget()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
