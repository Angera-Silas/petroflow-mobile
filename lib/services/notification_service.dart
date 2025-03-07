import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static void initNotifications() {
    messaging.getToken().then((token) {
      print("Firebase Token: $token");
    });

    FirebaseMessaging.onMessage.listen((message) {
      print("New Notification: ${message.notification?.title}");
    });
  }
}
