import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker_assignment/main.dart';

void main() {
  testWidgets('App loads', (tester) async {
    await tester.pumpWidget(const ExpenseMateApp());
    expect(find.text('ExpenseMate'), findsOneWidget);
  });
}
