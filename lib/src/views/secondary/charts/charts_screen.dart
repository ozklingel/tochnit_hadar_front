import 'package:flutter/material.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/views/secondary/charts/ahrai_tohnit/views/ahrai_tohnit_dashboard.dart';
import 'package:hadar_program/src/views/secondary/charts/melave/views/melave_charts_dashboard.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChartsScreen extends ConsumerWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);

    switch (user.valueOrNull?.role) {
      case UserRole.melave:
        return const MelaveChartsDashboardScreen();
      case UserRole.ahraiTohnit:
        return const AhraiTohnitChartsDashboardScreen();
      default:
        return ErrorWidget.withDetails(message: 'bad role');
    }
  }
}
