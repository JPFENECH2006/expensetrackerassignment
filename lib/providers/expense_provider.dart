import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/hive_service.dart';

class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [];

  // 🔒 FIXED balance
  double _balance = 0.0; // you can set default or load later

  List<Expense> get expenses => List.unmodifiable(_expenses);
  double get totalBalance => _balance;

  void loadExpenses() {
    _expenses.clear();
    _expenses.addAll(HiveService.loadExpenses());
    notifyListeners();
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    HiveService.saveExpense(expense);

    // 🔁 Balance ONLY changes on ADD
    if (expense.isIncome) {
      _balance += expense.amount;
    } else {
      _balance -= expense.amount;
    }

    notifyListeners();
  }

  void deleteExpense(String id) {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index == -1) return;

    // ❌ DO NOT touch balance here
    HiveService.deleteExpense(id);
    _expenses.removeAt(index);

    notifyListeners();
  }
}
