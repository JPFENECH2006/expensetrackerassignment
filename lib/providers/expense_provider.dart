import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/hive_service.dart';

class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  double get totalBalance {
    double total = 0;
    for (var e in _expenses) {
      total += e.isIncome ? e.amount : -e.amount;
    }
    return total;
  }

  void loadExpenses() {
    _expenses.clear();
    _expenses.addAll(HiveService.loadExpenses());
    notifyListeners();
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    HiveService.saveExpense(expense);
    notifyListeners();
  }

  void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    HiveService.deleteExpense(id);
    notifyListeners();
  }
}
