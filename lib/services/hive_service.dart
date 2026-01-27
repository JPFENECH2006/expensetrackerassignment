import 'package:hive/hive.dart';
import '../models/expense.dart';

class HiveService {
  static const String boxName = 'expenses';

  static Future<void> init() async {
    await Hive.openBox(boxName);
  }

  static void saveExpense(Expense expense) {
    final box = Hive.box(boxName);
    box.add({
      'id': expense.id,
      'title': expense.title,
      'amount': expense.amount,
      'date': expense.date.toIso8601String(),
      'category': expense.category,
      'imagePath': expense.imagePath,
      'isIncome': expense.isIncome,
    });
  }

  static List<Expense> loadExpenses() {
    final box = Hive.box(boxName);
    return box.values.map<Expense>((e) {
      return Expense(
        id: e['id'],
        title: e['title'],
        amount: e['amount'],
        date: DateTime.parse(e['date']),
        category: e['category'],
        imagePath: e['imagePath'],
        isIncome: e['isIncome'] ?? false,
      );
    }).toList();
  }

  static void deleteExpense(String id) {
    final box = Hive.box(boxName);
    final key = box.keys.firstWhere(
      (k) => box.get(k)['id'] == id,
      orElse: () => null,
    );
    if (key != null) box.delete(key);
  }
}
