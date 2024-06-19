import 'package:flutter/material.dart';
import 'package:hadar_program/src/views/secondary/import/import_data_from_excel_screen.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddInstitutionFromExcel extends HookConsumerWidget {
  const AddInstitutionFromExcel({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return ImportDataFromExcelScreen(
      title: 'הוספת מוסד',
      subtitle: 'העלאת קובץ נתוני מוסדות',
      uploadExcel: (file) async => await ref
          .read(institutionsControllerProvider.notifier)
          .addFromExcel(file),
    );
  }
}
