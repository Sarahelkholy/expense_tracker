import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyChart extends StatelessWidget {
  final List<Expense> expenses;
  final int days;

  const MyChart({super.key, required this.expenses, this.days = 7});

  @override
  Widget build(BuildContext context) {
    final buckets = _aggregateLastNDays(expenses, days);

    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 4000,
        barTouchData: BarTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final b = buckets[group.x.toInt()];
              final value = b['value'] as double;
              final label = b['label'] as String;
              return BarTooltipItem(
                '$label\n${value.toInt()} EGP',
                TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) =>
                  _bottomTitle(value, meta, buckets),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 56,
              interval: 1000,
              getTitlesWidget: (value, meta) => _leftTitle(value, meta),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false), // removed grid lines
        barGroups: List.generate(buckets.length, (i) {
          final val = buckets[i]['value'] as double;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: val,
                width: 14,
                borderRadius: BorderRadius.circular(6),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  transform: GradientRotation(pi / 40),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 4000,
                  color: Colors.grey.shade200,
                ),
              ),
            ],
          );
        }),
      ),
      swapAnimationDuration: const Duration(milliseconds: 600),
      swapAnimationCurve: Curves.easeOutCubic,
    );
  }

  List<Map<String, Object>> _aggregateLastNDays(List<Expense> expenses, int n) {
    final now = DateTime.now();
    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: n - 1));
    final List<Map<String, Object>> buckets = List.generate(n, (i) {
      final day = start.add(Duration(days: i));
      final label = _weekdayLabel(day.weekday);
      return {'date': day, 'label': label, 'value': 0.0};
    });

    for (final e in expenses) {
      final date = DateTime(e.date.year, e.date.month, e.date.day);
      final idx = date.difference(start).inDays;
      if (idx >= 0 && idx < n) {
        final current = buckets[idx]['value'] as double;
        buckets[idx]['value'] = current + e.amount;
      }
    }
    return buckets;
  }

  String _weekdayLabel(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  Widget _bottomTitle(
    double value,
    TitleMeta meta,
    List<Map<String, Object>> buckets,
  ) {
    final i = value.toInt();
    if (i < 0 || i >= buckets.length) return const SizedBox.shrink();
    final label = buckets[i]['label'] as String;
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _leftTitle(double value, TitleMeta meta) {
    if (value < 0) return const SizedBox.shrink();
    return SideTitleWidget(
      meta: meta,
      child: Text(
        '\$${value.toInt()}',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
    );
  }
}
