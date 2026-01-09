import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/user_provider.dart';
import 'providers/burnout_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/signup/signup_screen.dart';
import 'screens/profiling/profiling_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/daily_checkin/daily_checkin_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BurnoutProvider()),
      ],
      child: MaterialApp(
        title: 'Thozhi',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/profiling': (context) => const ProfilingScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/checkin': (context) => const DailyCheckInScreen(),
        },
      ),
    );
  }
}
