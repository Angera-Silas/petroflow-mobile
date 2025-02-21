import 'package:flutter/material.dart';
import 'package:petroflow/components/inputs/text_input_field.dart';
import 'package:petroflow/components/popups/notification_popup.dart';
import 'package:petroflow/pages/reset_password.dart';
import 'package:petroflow/services/api_service.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int step = 1; // Step 1: Enter email, Step 2: Verify OTP
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String generatedOtp = "";
  final ApiService _apiService = ApiService();
  bool isLoading = false;

  Future<void> sendOtp() async {
    if (emailController.text.isEmpty) {
      showMessage("Error", "Please enter your email.", "error");
      return;
    }

    setState(() => isLoading = true);

    try {
      var response = await _apiService.sendOtp(emailController.text);

      setState(() {
        generatedOtp = response as String; // OTP is returned as a plain string
        step = 2;
      });

      showMessage("Success", "OTP sent! Check your email.", "success");
    } catch (e) {
      showMessage("Error", "Failed to send OTP.", "error");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void verifyOtp() {
    if (otpController.text != generatedOtp) {
      showMessage("Error", "Invalid verification code.", "error");
      return;
    }

    showMessage(
        "Success", "OTP Verified! Proceed to reset password.", "success");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResetPasswordScreen(email: emailController.text),
      ),
    );
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
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (step == 1) ...[
              const Text("Enter your email to receive OTP:"),
              TextInputField(
                controller: emailController,
                labelText: "Email",
              ),
              const SizedBox(height: 10),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: sendOtp, child: const Text("Send OTP")),
            ],
            if (step == 2) ...[
              const Text("Enter the OTP sent to your email:"),
              TextInputField(
                controller: otpController,
                labelText: "OTP",
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: verifyOtp, child: const Text("Verify OTP")),
            ],
          ],
        ),
      ),
    );
  }
}
