import 'package:flutter/foundation.dart';

class ApiEndpoints {
  // Primary backend server IP for Physical Android Devices, Emulators & Web
  static const String serverIp = '192.168.29.234';
  static const String serverPort = '8080';

  // Configurable base URL:
  // - Web / Desktop uses localhost:8080
  // - Physical Device & Android Emulator connects to host Wi-Fi IP: 192.168.29.234:8080
  static const String _defaultUrl = kDebugMode
      ? (kIsWeb
          ? 'http://localhost:$serverPort/api'
          : 'http://$serverIp:$serverPort/api')
      : 'http://$serverIp:$serverPort/api';

  static const String baseUrl = String.fromEnvironment('API_URL', defaultValue: _defaultUrl);

  // Health
  static const String health = '$baseUrl/health';

  // Auth & Profile
  static const String login = '$baseUrl/auth/login';
  static const String profile = '$baseUrl/auth/me';

  // Operations: Documents & Verification
  static const String documents = '$baseUrl/operations/documents';
  static const String holidays = '$baseUrl/operations/holidays';

  // Operations: Leaves & Shift
  static const String leaves = '$baseUrl/operations/leaves';
  static const String applyLeave = '$baseUrl/operations/leaves/apply';
  static const String toggleShift = '$baseUrl/operations/shift/toggle';
  static const String celebrations = '$baseUrl/operations/celebrations';
  static const String tasks = '$baseUrl/operations/tasks';
  static const String dashboardSummary = '$baseUrl/operations/dashboard-summary';
  static const String payslips = '$baseUrl/payslips';
  static const String helpdesk = '$baseUrl/operations/helpdesk-tickets';
  static const String notifications = '$baseUrl/operations/notifications';
  static const String readAllNotifications = '$baseUrl/operations/notifications/read-all';

  // Attendance
  static const String punchIn = '$baseUrl/attendance/punch-in';
  static const String punchOut = '$baseUrl/attendance/punch-out';
  static const String autoClockout = '$baseUrl/attendance/auto-clockout';
  static const String verifyFace = '$baseUrl/attendance/verify-face';
  static const String attendanceLogs = '$baseUrl/attendance/logs';
  static const String shiftRoster = '$baseUrl/attendance/roster';
  static const String regularization = '$baseUrl/attendance/regularize';
  static const String shiftConfig = '$baseUrl/attendance/shift-config';
}
