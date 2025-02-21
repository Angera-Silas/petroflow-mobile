import 'package:flutter/material.dart';
import 'package:petroflow/components/buttons/bottom_button.dart';
import 'package:petroflow/components/inputs/custom_text_form_field.dart';
import 'package:petroflow/components/popups/notification_popup.dart';
import 'package:petroflow/constants/my_typography.dart';
import 'package:petroflow/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void showMessage(String title, String message, String type) {
    NotificationPopup.show(
      context,
      title: title,
      message: message,
      type: type, // Uses predefined colors for error, success, etc.
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      try {
        final response = await _apiService.postData('users/login', {
          'username': email,
          'password': password,
        });

        if (response.containsKey('token')) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', response['token']);
          await prefs.setString('authUser', email);
          await prefs.setString('authRole', response['role'] ?? 'user');

          if (_rememberMe) {
            await prefs.setString('savedEmail', email);
            await prefs.setString('savedPassword', password);
            await prefs.setInt('loginExpiry',
                DateTime.now().add(Duration(days: 7)).millisecondsSinceEpoch);
          }

          showMessage("Success", "Login successful!", "success");
          Navigator.pushReplacementNamed(context, '/');
        } else {
          showMessage(
              "Error", response['message'] ?? 'Invalid credentials', "error");
        }
      } catch (error) {
        showMessage("Error", "Login failed: $error", "error");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome Back!', style: AppTypography.heading1(context)),
                Text('Please log in to your account',
                    style: AppTypography.paragraph_medium(context)),
                const SizedBox(height: 30),
                CustomTextFormField(
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter your email' : null,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (value) =>
                      value!.length < 6 ? 'Password too short' : null,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: !_obscurePassword,
                      onChanged: (value) =>
                          setState(() => _obscurePassword = !value!),
                    ),
                    Text('Show Password',
                        style: AppTypography.paragraph_small(context)),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) =>
                          setState(() => _rememberMe = value!),
                    ),
                    Text('Remember Me for 7 days',
                        style: AppTypography.paragraph_small(context)),
                  ],
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: BottomButton(
                          buttonTitle: 'Login',
                          onTap: _login,
                          bradius: BorderRadius.circular(20),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
