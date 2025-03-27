import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:petroflow/constants/my_colors.dart';
import 'package:petroflow/constants/my_typography.dart';
import 'package:petroflow/firebase_options.dart' show DefaultFirebaseOptions;
import 'package:petroflow/pages/home/home_controller.dart';
import 'package:petroflow/pages/home/home_page.dart';
import 'package:petroflow/pages/login_page.dart';
import 'package:petroflow/pages/page_not_found.dart';
import 'package:petroflow/pages/sales/sales_controller.dart';
import 'package:petroflow/screens/otp_screen.dart';
import 'package:petroflow/screens/splash_screen.dart';
import 'package:petroflow/services/background_sync.dart';
import 'package:petroflow/services/connectivity_service.dart';
import 'package:petroflow/services/db_service.dart';
import 'package:petroflow/services/notification_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase(); // Singleton database instance
  BackgroundSync.initialize(database); // Initialize background sync
  ConnectivityService.initBackgroundSync(database); // Start auto-sync

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationService.initNotifications(); // Setup notifications

  runApp(PetroFlow(database)); // Pass database instance
}

class PetroFlow extends StatelessWidget {
  final AppDatabase _database; // Database instance for the app

  const PetroFlow(this._database, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeController(_database)),
        ChangeNotifierProvider(create: (_) => SalesController(_database)),
        // Pass database
      ],
      child: MaterialApp(
        title: 'PetroFlow',
        themeMode: ThemeMode.system,
        // Automatically use the system theme
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: kLightBackgroundColor,
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
        // Set SplashScreen as the initial route
        onGenerateRoute: (settings) {
          return null; // Return null for undefined routes
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (_) => const PageNotFound());
        },
        routes: {
          '/login': (context) => const LoginPage(),
          '/': (context) => const HomePage(),
          '/otp': (context) => OtpScreen(),
          '/splash': (context) => const SplashScreen(),
        },
      ),
    );
  }
}
