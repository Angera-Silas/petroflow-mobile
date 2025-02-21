import 'package:flutter/material.dart';
import 'package:petroflow/components/inputs/text_input_field.dart';
import 'package:petroflow/components/popups/notification_popup.dart';
import 'package:petroflow/services/api_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({required this.email, Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ApiService _apiService = ApiService();
  bool isLoading = false; // State to track loading

  Future<void> resetPassword() async {
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.length < 6) {
      showMessage("Error", "Password must be at least 6 characters.", "error");
      return;
    }

    if (newPassword != confirmPassword) {
      showMessage("Error", "Passwords do not match.", "error");
      return;
    }

    setState(() {
      isLoading = true; // Show loading spinner
    });

    try {
      Map<String, dynamic> response =
          await _apiService.resetPassword(widget.email, newPassword);

      if (response['status'] == "success") {
        showMessage("Success", "Password reset successful!", "success");
        Navigator.pop(context); // Go back to login screen
      } else {
        showMessage("Error", response['message'] ?? "Failed to reset password.",
            "error");
      }
    } catch (e) {
      showMessage("Error", "Something went wrong. Please try again.", "error");
    } finally {
      setState(() {
        isLoading = false; // Hide loading spinner
      });
    }
  }

  void showMessage(String title, String message, String type) {
    NotificationPopup.show(
      context,
      title: title,
      message: message,
      type: type, // Uses predefined colors for error, success, etc.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter your new password:"),
            const SizedBox(height: 10),
            TextInputField(
              controller: newPasswordController,
              labelText: "New Password",
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextInputField(
              controller: confirmPasswordController,
              labelText: "Confirm Password",
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Center(
              child: isLoading
                  ? const CircularProgressIndicator() // Show loader when processing
                  : ElevatedButton(
                      onPressed: resetPassword,
                      child: const Text("Save Password"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
