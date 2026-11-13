import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/theme/app_theme.dart';
import 'core/services/fcm_notification_service.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/attendance/attendance_screen.dart';
import 'features/leave/leave_screen.dart';
import 'features/work/work_screen.dart';
import 'features/notifications/notifications_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await FcmNotificationService().initialize();
  } catch (e) {
    debugPrint('Firebase init notice: $e');
  }

  runApp(const AayupOnesApp());
}

class AayupOnesApp extends StatelessWidget {
  const AayupOnesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AayupOnes',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/attendance': (context) => const AttendanceScreen(),
        '/leave': (context) => const LeaveScreen(),
        '/work': (context) => const WorkManagementScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
    );
  }
}
