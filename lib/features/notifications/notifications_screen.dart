import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/network/api_endpoints.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../onboarding/onboarding_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilter = 0;
  bool _isLoading = true;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final token = AuthService().token;
      final response = await http.get(
        Uri.parse(ApiEndpoints.notifications),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] is List) {
          final List list = decoded['data'];
          if (mounted) {
            setState(() {
              _notifications = list.map((item) {
                final type = (item['type'] ?? 'HR').toString().toUpperCase();
                IconData icon = Icons.notifications_none_rounded;
                Color color = AppColors.primary;

                if (type == 'ONBOARDING') {
                  icon = Icons.assignment_late_rounded;
                  color = const Color(0xFFEF4444);
                } else if (type == 'ATTENDANCE') {
                  icon = Icons.verified_user_outlined;
                  color = AppColors.success;
                } else if (type == 'WORK') {
                  icon = Icons.assignment_outlined;
                  color = AppColors.primary;
                } else if (type == 'PAYROLL') {
                  icon = Icons.receipt_long_outlined;
                  color = const Color(0xFFF59E0B);
                } else {
                  icon = Icons.task_alt_rounded;
                  color = const Color(0xFF6366F1);
                }

                return {
                  'id': item['id'],
                  'type': type,
                  'title': item['title'] ?? 'Notification',
                  'desc': item['desc'] ?? '',
                  'time': item['time'] ?? 'Recent',
                  'icon': icon,
                  'color': color,
                  'isUnread': item['isUnread'] ?? false,
                  'route': item['route'],
                };
              }).toList();
              _isLoading = false;
            });
            return;
          }
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markAllRead() async {
    setState(() {
      for (var n in _notifications) {
        n['isUnread'] = false;
      }
    });

    try {
      final token = AuthService().token;
      await http.post(
        Uri.parse(ApiEndpoints.readAllNotifications),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
    } catch (_) {}

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All marked as read')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filters = ['ALL', 'WORK', 'HR', 'ATTENDANCE'];
    final filteredList = _selectedFilter == 0
        ? _notifications
        : _notifications.where((n) => n['type'] == filters[_selectedFilter]).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        actions: [
          TextButton(
            onPressed: _notifications.isEmpty ? null : _markAllRead,
            child: const Text('Mark all read', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(filters.length, (idx) {
                        final isSelected = _selectedFilter == idx;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = idx),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.borderLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              filters[idx],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),

                Expanded(
                  child: filteredList.isEmpty
                      ? const Center(
                          child: Text('No notifications in this category', style: TextStyle(color: AppColors.textMuted)),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchNotifications,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredList.length,
                            itemBuilder: (context, i) {
                              final item = filteredList[i];
                              return InkWell(
                                onTap: () {
                                  if (item['route'] == 'onboarding') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const OnboardingScreen(),
                                      ),
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: (item['isUnread'] == true) ? Colors.white : Colors.white.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: (item['isUnread'] == true) ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border,
                                      width: (item['isUnread'] == true) ? 1.5 : 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: (item['color'] as Color).withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 22),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    item['title'],
                                                    style: TextStyle(
                                                      fontWeight: (item['isUnread'] == true) ? FontWeight.w800 : FontWeight.w600,
                                                      fontSize: 14,
                                                      color: AppColors.textPrimary,
                                                    ),
                                                  ),
                                                ),
                                                if (item['isUnread'] == true)
                                                  Container(
                                                    width: 8,
                                                    height: 8,
                                                    margin: const EdgeInsets.only(left: 6),
                                                    decoration: const BoxDecoration(
                                                      color: AppColors.primary,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item['desc'],
                                              style: const TextStyle(
                                                fontSize: 12.5,
                                                color: AppColors.textSecondary,
                                                height: 1.35,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              item['time'],
                                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
