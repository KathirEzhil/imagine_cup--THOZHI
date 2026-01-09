import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'providers/user_provider.dart';
import 'providers/burnout_provider.dart';
import 'services/notification_service.dart';
import 'screens/splash/splash_screen.dart';

class App extends StatefulWidget {
  const App({super.key});
  
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final NotificationService _notificationService = NotificationService();
  bool _initialized = false;
  
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    try {
      // Initialize Firebase
      // Note: For production, use flutterfire configure to auto-generate firebase_options.dart
      // Then update the import and use: await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      
      // For MVP/demo without full Firebase setup:
      // This will work if Firebase is configured, or fail gracefully if not
      try {
        // Try to initialize Firebase - will work if google-services.json/GoogleService-Info.plist exists
        await Firebase.initializeApp();
        debugPrint('Firebase initialized successfully');
      } on FirebaseException catch (e) {
        debugPrint('Firebase initialization error: ${e.message}');
        debugPrint('Note: Firebase setup required for full functionality. See SETUP_FIREBASE.md');
      } catch (e) {
        debugPrint('Firebase initialization skipped (use flutterfire configure for full setup): $e');
      }
      
      // Initialize notification service
      try {
        await _notificationService.initialize();
        debugPrint('Notification service initialized');
      } catch (e) {
        debugPrint('Notification service initialization skipped: $e');
      }
      
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Handle initialization error
      debugPrint('Error initializing app: $e');
      setState(() {
        _initialized = true; // Still show app even if services fail
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          backgroundColor: AppTheme.lightPink,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Initializing...',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      );
    }
    
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
          '/login': (context) => const SplashScreen(), // Will redirect based on auth state
        },
      ),
    );
  }
}
