import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../providers/theme_provider.dart';
import 'add_expense_screen.dart';
import 'report_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Color _categoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.green;
      case 'Transport':
        return Colors.blue;
      case 'Bills':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();

    return Scaffold(
      /// 🔵 APP BAR
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('ExpenseMate'),
        actions: [
          /// 🌙 DARK MODE TOGGLE
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),

          /// 📊 REPORT BUTTON
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

      /// ➕ ADD BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
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
          /// 🟢 BALANCE CARD
          Card(
            color: Colors.green.shade100,
            margin: const EdgeInsets.all(16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Balance: \$${provider.totalBalance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // ✅ ALWAYS BLACK (FIX)
                ),
              ),
            ),
          ),

          /// 📋 TRANSACTION LIST
          Expanded(
            child: provider.expenses.isEmpty
                ? const Center(child: Text('No transactions yet'))
                : ListView.builder(
                    itemCount: provider.expenses.length,
                    itemBuilder: (ctx, i) {
                      final e = provider.expenses[i];
                      final categoryColor = _categoryColor(e.category);

                      return Dismissible(
                        key: ValueKey(e.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          provider.deleteExpense(e.id);
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            /// 📸 IMAGE OR ICON
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: e.imagePath.isNotEmpty &&
                                      File(e.imagePath).existsSync()
                                  ? Image.file(
                                      File(e.imagePath),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 50,
                                      height: 50,
                                      color: e.isIncome
                                          ? Colors.green
                                          : categoryColor,
                                      child: Icon(
                                        e.isIncome
                                            ? Icons.arrow_downward
                                            : Icons.arrow_upward,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),

                            title: Text(
                              e.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            subtitle: Text(
                              '${e.category} • ${e.date.day}/${e.date.month}/${e.date.year}',
                            ),

                            /// 💰 AMOUNT
                            trailing: Text(
                              e.isIncome
                                  ? '+\$${e.amount.toStringAsFixed(2)}'
                                  : '-\$${e.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color:
                                    e.isIncome ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
