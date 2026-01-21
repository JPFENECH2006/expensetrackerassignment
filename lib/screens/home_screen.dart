import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import 'add_expense_screen.dart';
import 'report_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ExpenseMate'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Balance: \$${provider.totalBalance.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.expenses.length,
              itemBuilder: (ctx, i) {
                final e = provider.expenses[i];
                return ListTile(
                  leading: Image.file(File(e.imagePath), width: 50),
                  title: Text(e.title),
                  subtitle: Text(
                    '${e.category} • ${e.date.day}/${e.date.month}/${e.date.year}',
                  ),
                  trailing:
                      Text('-\$${e.amount.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
