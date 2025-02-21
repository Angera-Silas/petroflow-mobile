import 'package:flutter/material.dart';

class NotificationPopup {
  static void show(BuildContext context,
      {required String title, required String message, required String type}) {
    Color bgColor;
    IconData icon;

    switch (type.toLowerCase()) {
      case "error":
        bgColor = Colors.red;
        icon = Icons.error;
        break;
      case "success":
        bgColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case "info":
        bgColor = Colors.blue;
        icon = Icons.info;
        break;
      case "warning":
        bgColor = Colors.orange;
        icon = Icons.warning;
        break;
      default:
        bgColor = Colors.grey;
        icon = Icons.notifications;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
