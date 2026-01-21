class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String imagePath;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.imagePath,
  });
}
