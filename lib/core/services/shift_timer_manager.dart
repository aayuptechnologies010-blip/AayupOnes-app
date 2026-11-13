import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../network/api_endpoints.dart';
import 'auth_service.dart';
import 'fcm_notification_service.dart';
import '../../features/auth/login_screen.dart';

class ShiftTimerManager {
  static final ShiftTimerManager _instance = ShiftTimerManager._internal();
  factory ShiftTimerManager() => _instance;
  ShiftTimerManager._internal();

  Timer? _pollingTimer;
  bool _isWarningShown = false;
  String? _shiftEndTime;
  bool _autoClockoutEnabled = true;

  void startShiftMonitoring() {
    stopShiftMonitoring();
    _isWarningShown = false;
    _syncShiftConfig();

    // Check every 60 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _checkShiftStatus();
    });
  }

  void stopShiftMonitoring() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isWarningShown = false;
  }

  Future<void> _syncShiftConfig() async {
    try {
      final token = AuthService().token;
      if (token == null) return;

      final res = await http.get(
        Uri.parse(ApiEndpoints.shiftConfig),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'];
          _shiftEndTime = data['shiftEndTime'] as String? ?? '06:30 PM';
          _autoClockoutEnabled = data['autoClockoutAtShiftEnd'] as bool? ?? true;
        }
      }
    } catch (_) {}
  }

  Future<void> _checkShiftStatus() async {
    if (!AuthService().isAuthenticated || !_autoClockoutEnabled) return;

    final endTime = _shiftEndTime ?? '06:30 PM';
    final now = DateTime.now();
    final endMinutes = _parseTimeToMinutes(endTime);
    if (endMinutes == null) return;

    final currentMinutes = now.hour * 60 + now.minute;
    final diffMinutes = endMinutes - currentMinutes;

    final context = navigatorKey.currentContext;

    // 10-minute warning before auto logout
    if (diffMinutes <= 10 && diffMinutes > 0 && !_isWarningShown) {
      _isWarningShown = true;
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 8),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFFD97706), // Amber warning
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Row(
              children: [
                const Icon(Icons.timer_outlined, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Shift ends in $diffMinutes minutes ($endTime). App will auto clock-out and log out.',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    // Shift completed: Auto Clock-out and Auto Logout
    if (currentMinutes >= endMinutes) {
      await _executeAutoClockoutAndLogout();
    }
  }

  Future<void> _executeAutoClockoutAndLogout() async {
    stopShiftMonitoring();

    try {
      final token = AuthService().token;
      if (token != null) {
        await http.post(
          Uri.parse(ApiEndpoints.autoClockout),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'isAutoClockOut': true}),
        ).timeout(const Duration(seconds: 4));
      }
    } catch (_) {}

    await AuthService().logout();

    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.bedtime_rounded, color: Color(0xFF4F46E5)),
              SizedBox(width: 8),
              Text('Shift Ended', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: Text(
            'Your scheduled shift for today has ended at ${_shiftEndTime ?? "06:30 PM"}.\n\nYou have been clocked out automatically. Have a wonderful evening!\n\nAccess will reopen at tomorrow\'s shift start.',
            style: const TextStyle(fontSize: 14, color: Color(0xFF475569), height: 1.4),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('OK, Got it', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }

  int? _parseTimeToMinutes(String timeStr) {
    try {
      final cleaned = timeStr.trim().toUpperCase();
      final regex = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)?$');
      final match = regex.firstMatch(cleaned);
      if (match == null) return null;

      int hours = int.parse(match.group(1)!);
      final minutes = int.parse(match.group(2)!);
      final period = match.group(3);

      if (period == 'PM' && hours < 12) hours += 12;
      if (period == 'AM' && hours == 12) hours = 0;

      return hours * 60 + minutes;
    } catch (_) {
      return null;
    }
  }
}
