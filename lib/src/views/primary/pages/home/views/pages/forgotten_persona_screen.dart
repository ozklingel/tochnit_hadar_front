import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/export_excel_bar.dart';

class ForgottenApprenticesScreen extends StatelessWidget {
  const ForgottenApprenticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text(
          'חניכים נשכחים',
          style: TextStyles.s20w500,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const Column(
        children: [
          Text('חניכים שעברו מעל 100 יום מיצירת קשר איתם'),
          ExportToExcelBar(),
        ],
      ),
    );
  }
}
