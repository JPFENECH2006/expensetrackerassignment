import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/hive_service.dart';

class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  double get totalBalance =>
      _expenses.fold(0, (sum, e) => sum - e.amount);

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
}
