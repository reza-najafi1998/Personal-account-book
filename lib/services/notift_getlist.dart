import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  // Create a FlutterLocalNotificationsPlugin instance
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize FlutterLocalNotificationsPlugin
  Future<void> initialize() async {
    // Get initialization settings
    final InitializationSettings initializationSettings =
    await _getInitializationSettings();
    // Initialize FlutterLocalNotificationsPlugin with the obtained settings
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Get initialization settings
  Future<InitializationSettings> _getInitializationSettings() async {
    // Define Android initialization settings
    final AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    // Combine Android initialization settings into one InitializationSettings object
    final InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);
    return initializationSettings;
  }

  // Get pending notification requests
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    // Retrieve pending notification requests from FlutterLocalNotificationsPlugin
    final List<PendingNotificationRequest> pendingNotifications =
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications;
  }

  // Delete a scheduled notification by id
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

}
