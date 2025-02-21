import 'package:flutter/material.dart';
import 'package:petroflow/constants/my_colors.dart';
import 'package:petroflow/constants/my_typography.dart';
import 'package:petroflow/pages/home/home_controller.dart';
import 'package:petroflow/pages/home/home_page.dart';
import 'package:petroflow/pages/login_page.dart';
import 'package:petroflow/pages/page_not_found.dart';
import 'package:petroflow/screens/otp_screen.dart';
import 'package:petroflow/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const PetroFlow());
}

class PetroFlow extends StatelessWidget {
  const PetroFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetroFlow',
      themeMode: ThemeMode.system,
      // Automatically use the system theme
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: kLightBackgroundColor,
        // Light theme background
        primaryColor: kLightPrimaryColor,
        highlightColor: kLightTextHighlightColor,
        dividerColor: kLightDividerColor,
        disabledColor: kLightMutedColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: kLightSecondaryColor,
          centerTitle: true,
          foregroundColor: kLightTextColor, // Text and icon color
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: kTransparentColor,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: TextTheme(
          headlineLarge: AppTypography.heading1(context),
          headlineMedium: AppTypography.heading2(context),
          headlineSmall: AppTypography.heading3(context),
          bodySmall: AppTypography.paragraph_small(context),
          bodyMedium: AppTypography.paragraph_medium(context),
          bodyLarge: AppTypography.paragraph_large(context),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: kDarkPrimaryColor,
        highlightColor: kDarkTextHighlightColor,
        dividerColor: kDarkDividerColor,
        disabledColor: kDarkMutedColor,
        scaffoldBackgroundColor: kDarkBackgroundColor,
        // Dark theme background
        appBarTheme: const AppBarTheme(
          backgroundColor: kDarkSecondaryColor,
          centerTitle: true,
          foregroundColor: kDarkTextColor, // Text and icon color
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: kTransparentColor,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: TextTheme(
          headlineLarge: AppTypography.heading1(context),
          headlineMedium: AppTypography.heading2(context),
          headlineSmall: AppTypography.heading3(context),
          bodySmall: AppTypography.paragraph_small(context),
          bodyMedium: AppTypography.paragraph_medium(context),
          bodyLarge: AppTypography.paragraph_large(context),
        ),
      ),

      initialRoute: '/splash',
      // Set LoginPage as the initial route
      onGenerateRoute: (settings) {
        // if (settings.name == '/reset-password') {
        //    final args = settings.arguments as Map<String, String>;
        //    return MaterialPageRoute(
        //      builder: (context) {
        //        return ResetPasswordScreen(
        //          email: args['email']!,
        //        );
        //      },
        //    );
        // }
        return null; // Return null for undefined routes
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => const PageNotFound());
      },
      routes: {
        '/login': (context) => const LoginPage(),
        '/': (context) => ChangeNotifierProvider(
              create: (context) => HomeController(),
              child: const HomePage(),
            ),
        '/otp': (context) => OtpScreen(),
        // '/register': (context) => const RegistrationPage(),
        '/splash': (context) => const SplashScreen(),
        // '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
