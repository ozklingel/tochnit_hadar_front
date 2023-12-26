import 'package:flutter/material.dart';
import 'package:hadar_program/src/views/secondary/charts/melave/views/melave_charts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChartsScreen extends ConsumerWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return const MelaveChartsScreen();
  }
}
