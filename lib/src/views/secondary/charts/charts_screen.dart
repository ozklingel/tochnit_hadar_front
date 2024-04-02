import 'package:flutter/material.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/views/secondary/charts/ahrai_tohnit/views/ahrai_tohnit_dashboard.dart';
import 'package:hadar_program/src/views/secondary/charts/melave/views/melave_charts_dashboard.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_eshkol/views/rakaz_eshkol_dashboard.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_mosad/views/rakaz_mosad_charts_dashboard.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChartsScreen extends ConsumerWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);

    switch (auth.valueOrNull?.role) {
      case UserRole.melave:
        return const MelaveChartsDashboardScreen();
      case UserRole.rakazMosad:
        return const RakazMosadChartsDashboardScreen();
      case UserRole.rakazEshkol:
        return const RakazEshkolChartsDashboardScreen();
      case UserRole.ahraiTohnit:
        return const AhraiTohnitChartsDashboardScreen();
      default:
        return ErrorWidget.withDetails(message: 'bad role');
    }
  }
}
