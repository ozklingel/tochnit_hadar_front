import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/users_controller.dart';
import 'package:hadar_program/src/views/secondary/import/import_data_from_excel_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ImportNewUsersFromExcel extends ConsumerWidget {
  const ImportNewUsersFromExcel({
    super.key,
    required this.userType,
  });

  final UserRole userType;

  @override
  Widget build(BuildContext context, ref) {
    return ImportDataFromExcelScreen(
      title: 'הוספת משתמשים',
      subtitle: 'העלאת קובץ נתוני חניכים',
      uploadExcel: (file) async => await ref
          .read(
            usersControllerProvider.notifier,
          )
          .importFromExcel(
            file: file,
            userType: userType,
          ),
    );
  }
}
