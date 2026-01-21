import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _notifications.initialize(settings);
  }

  static Future<void> showSavedNotification() async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'expense_channel',
        'Expenses',
        importance: Importance.high,
      ),
    );

    await _notifications.show(
      0,
      'Expense Saved',
      'Your expense was saved successfully',
      details,
    );
  }
}
