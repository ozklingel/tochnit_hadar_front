import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_details_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_header.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/circular_progress_gauge.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/linear_progress_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AhraiTohnitChartsDashboardScreen extends HookConsumerWidget {
  const AhraiTohnitChartsDashboardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    var children = [
      const ChartHeader(),
      const CircularProgressGauge(val: .4),
      LinearProgressCard.dashboard(
        label: 'שיחות',
        val: 5,
        total: 20,
        onTap: () => Toaster.unimplemented(),
      ),
      LinearProgressCard.dashboard(
        label: 'מפגשים',
        val: 8,
        total: 16,
        onTap: () => Toaster.unimplemented(),
      ),
      ChartDetailsCard.percentage(
        label: 'מפגש מלווים מקצועי',
        details: 'מפגשים שבוצעו ברבעון הנוכחי',
        timestamp: '2 רבעונים',
        val: 2,
        total: 2,
        onTap: () => Toaster.unimplemented(),
      ),
      ChartDetailsCard.percentage(
        label: 'כנס מלווים שנתי',
        details: 'מפגשים שבוצעו ברבעון הנוכחי',
        timestamp: '2 שנים',
        val: 1,
        total: 2,
        onTap: () => Toaster.unimplemented(),
      ),
      LinearProgressCard.dashboard(
        label: 'שיחות היכרות הורים',
        val: 15,
        total: 18,
        onTap: () => Toaster.unimplemented(),
      ),
      ChartDetailsCard.absolute(
        label: 'חניכים ‘נשכחים’',
        details: 'מספר חניכים שלא נוצר איתם קשר מעל 100 יום',
        val: 2,
        total: 43,
        onTap: () => Toaster.unimplemented(),
      ),
      const LinearProgressCard.dashboard(
        label: 'ביקורים בבסיס',
        val: 60,
        total: 100,
        timestamp: 'עברו 2 רבעונים',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('מדדים'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FluentIcons.search_24_regular),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
    );
  }
}
