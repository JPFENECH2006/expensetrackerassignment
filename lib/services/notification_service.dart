import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidInit);

    await _notifications.initialize(settings);
  }

  
  static Future<void> showAddNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'expense_channel',
      'Expenses',
      channelDescription: 'Expense notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      'Transaction Added',
      'Your transaction was added successfully',
      details,
    );
  }

  
  static Future<void> showDeleteNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'expense_channel',
      'Expenses',
      channelDescription: 'Expense notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _notifications.show(
      1,
      'Transaction Deleted',
      'The transaction was removed',
      details,
    );
  }
}
