import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import '../network/api_endpoints.dart';
import 'auth_service.dart';

// Global Navigation Key for deep linking
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Top-level background message handler required by FirebaseMessaging
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('🌙 Background FCM Notification Received: ${message.messageId}');
}

class FcmNotificationService {
  static final FcmNotificationService _instance = FcmNotificationService._internal();
  factory FcmNotificationService() => _instance;
  FcmNotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 1. Request notification permission (Android 13+ & iOS)
      final settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('🔔 FCM Notification Permission Status: ${settings.authorizationStatus}');

      // 2. Setup Local Notification Channel for Android
      const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initSettings = InitializationSettings(android: androidInit);

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          if (response.payload != null && response.payload!.isNotEmpty) {
            _handleNotificationRoute(response.payload!);
          }
        },
      );

      // Create Android Notification Channel with custom sound
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'aayup_ones_high_importance_v2',
        'Corporate Announcements & Updates',
        description: 'Receives high-priority superadmin announcements and notifications',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // 3. Foreground Message Listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('🔔 Foreground FCM Message: ${message.notification?.title}');
        final notif = message.notification;
        if (notif != null) {
          _localNotifications.show(
            notif.hashCode,
            notif.title,
            notif.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                importance: Importance.max,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
                playSound: true,
                sound: const RawResourceAndroidNotificationSound('notification_sound'),
              ),
            ),
            payload: message.data['route'] ?? 'home',
          );
        }
      });

      // 4. Background Notification Tap Listener
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('👆 User tapped notification from background: ${message.data}');
        final route = message.data['route'] ?? 'home';
        _handleNotificationRoute(route);
      });

      // 5. Terminated / Closed App Notification Tap Listener
      final initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('🚀 App opened from Terminated state via notification: ${initialMessage.data}');
        final route = initialMessage.data['route'] ?? 'home';
        Future.delayed(const Duration(milliseconds: 1000), () {
          _handleNotificationRoute(route);
        });
      }

      // 6. Get device token and register with backend
      final token = await _fcm.getToken();
      if (token != null) {
        debugPrint('📱 FCM Device Token generated: ${token.substring(0, 15)}...');
        await registerTokenWithBackend(token);
      }

      // Token refresh listener
      _fcm.onTokenRefresh.listen((newToken) {
        registerTokenWithBackend(newToken);
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint('⚠️ FCM Notification Service Initialization Warning: $e');
    }
  }

  /// Force re-sync device FCM token (called on login or token refresh)
  Future<void> syncDeviceToken() async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        debugPrint('📱 Syncing device FCM token with backend...');
        await registerTokenWithBackend(token);
      }
    } catch (e) {
      debugPrint('FCM sync error: $e');
    }
  }

  /// Register FCM Token with backend for logged in user or device
  Future<void> registerTokenWithBackend(String token) async {
    final authToken = AuthService().token;
    final empId = AuthService().currentUser?.employeeId;

    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (authToken != null) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      final body = <String, dynamic>{
        'fcmToken': token,
      };
      if (empId != null) {
        body['employeeId'] = empId;
      }

      final res = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/announcements/register-fcm'),
        headers: headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        debugPrint('✅ FCM Token synced with backend MongoDB: ${res.body}');
      } else {
        debugPrint('⚠️ FCM Token sync response: ${res.statusCode} ${res.body}');
      }
    } catch (e) {
      debugPrint('Notice: FCM token backend sync deferred: $e');
    }
  }

  /// Navigate to targeted screen on notification tap
  void _handleNotificationRoute(String route) {
    debugPrint('🎯 Navigating to targeted destination: $route');
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // Route matching
    switch (route.toLowerCase()) {
      case 'onboarding':
        Navigator.of(context).pushNamed('/onboarding');
        break;
      case 'attendance':
        Navigator.of(context).pushNamed('/attendance');
        break;
      case 'leave':
        Navigator.of(context).pushNamed('/leave');
        break;
      case 'work':
        Navigator.of(context).pushNamed('/work');
        break;
      case 'notifications':
        Navigator.of(context).pushNamed('/notifications');
        break;
      default:
        // Default to home / dashboard
        break;
    }
  }
}

