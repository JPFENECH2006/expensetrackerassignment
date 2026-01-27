import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/expense_provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseProvider>().expenses;

    double income = 0;
    double expense = 0;

    final categoryTotals = {
      'Food': 0.0,
      'Transport': 0.0,
      'Bills': 0.0,
    };

    for (var e in expenses) {
      if (e.isIncome) {
        income += e.amount;
      } else {
        expense += e.amount;
        categoryTotals[e.category] =
            (categoryTotals[e.category] ?? 0) + e.amount;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Report')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total income: \$${income.toStringAsFixed(2)}'),
            Text('Total spent: \$${expense.toStringAsFixed(2)}'),
            const SizedBox(height: 20),

            const Text('Income vs Expense'),
            SizedBox(height: 200, child: _BarChart(income, expense)),

            const SizedBox(height: 20),
            const Text('Expenses by Category'),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    _section('Food', categoryTotals['Food']!, Colors.green),
                    _section('Transport', categoryTotals['Transport']!, Colors.blue),
                    _section('Bills', categoryTotals['Bills']!, Colors.red),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static PieChartSectionData _section(
      String title, double value, Color color) {
    return PieChartSectionData(
      value: value,
      title: value == 0 ? '' : title,
      color: color,
      radius: 60,
    );
  }
}

class _BarChart extends StatelessWidget {
  final double income;
  final double expense;

  const _BarChart(this.income, this.expense);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: income, color: Colors.green)
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: expense, color: Colors.red)
          ]),
        ],
      ),
    );
  }
}
