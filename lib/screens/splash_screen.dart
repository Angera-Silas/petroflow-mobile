import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petroflow/constants/my_typography.dart';
import 'package:petroflow/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _logoAnimationController;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Check auto-login after 5 seconds
    Future.delayed(const Duration(seconds: 5), _checkAutoLogin);
  }

  Future<void> _checkAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('savedEmail');
    String? password = prefs.getString('savedPassword');
    int? expiryTime = prefs.getInt('loginExpiry');

    if (email != null && password != null && expiryTime != null) {
      DateTime expiryDate = DateTime.fromMillisecondsSinceEpoch(expiryTime);

      if (DateTime.now().isBefore(expiryDate)) {
        _loginWithSavedCredentials(email, password);
        return;
      } else {
        await prefs.clear();
      }
    }
    _navigateToLogin();
  }

  Future<void> _loginWithSavedCredentials(String email, String password) async {
    try {
      final response = await _apiService.postData('users/login', {
        'username': email,
        'password': password,
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.containsKey('token')) {
        await prefs.setString('authToken', response['token']);
        await prefs.setString('authUser', email);
        await prefs.setString('authRole', response['role'] ?? 'user');

        _navigateToHome();
      } else {
        await prefs.clear();
        _navigateToLogin();
      }
    } catch (error) {
      _navigateToLogin();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/');
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Animated Text at the Top
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Column(
              children: [
                AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      'Welcome to PetroFlow!',
                      textStyle: const TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      speed: const Duration(milliseconds: 120),
                    ),
                    FadeAnimatedText(
                      'Streamlining Your Petrol Station Operations.',
                      textStyle: AppTypography.heading3(context),
                      textAlign: TextAlign.center,
                      duration: const Duration(seconds: 4),
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
              ],
            ),
          ),

          // Animated SVG Logo at the Center
          Center(
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.2).animate(
                CurvedAnimation(
                  parent: _logoAnimationController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: SvgPicture.asset(
                'images/logo.svg',
              ),
            ),
          ),

          // Circular Progress Bar at the Bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 4.0,
            ),
          ),
        ],
      ),
    );
  }
}
