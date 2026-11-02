import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../onboarding/onboarding_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilter = 0;

  final List<Map<String, dynamic>> _notifications = [
    {
      'type': 'ONBOARDING',
      'title': 'Onboarding Correction Required ⚠️',
      'desc': 'HR flagged Bank Passbook / Cheque: "Please upload clear scan showing printed IFSC code & name". Click to update.',
      'time': 'Just now',
      'icon': Icons.assignment_late_rounded,
      'color': Color(0xFFEF4444),
      'isUnread': true,
      'route': 'onboarding',
    },
    {
      'type': 'HR',
      'title': 'New Team Member Joined 🎉',
      'desc': 'Rohan Mehrotra has joined as Flutter Developer in Development team.',
      'time': '10 mins ago',
      'icon': Icons.person_add_alt_1_rounded,
      'color': Color(0xFF6366F1),
      'isUnread': true,
    },
    {
      'type': 'WORK',
      'title': 'New Task Assigned 📋',
      'desc': 'Arvind Sharma assigned you "Solar CRM Lead Import Module".',
      'time': '1 hour ago',
      'icon': Icons.assignment_outlined,
      'color': AppColors.primary,
      'isUnread': true,
    },
    {
      'type': 'ATTENDANCE',
      'title': 'Swipe Verified Successfully 🟢',
      'desc': 'Web clock-in at 09:48 AM inside Office Geofence bounds.',
      'time': '3 hours ago',
      'icon': Icons.verified_user_outlined,
      'color': AppColors.success,
      'isUnread': false,
    },
    {
      'type': 'HR',
      'title': 'Leave Request Approved ✨',
      'desc': 'Your Casual Leave for 14 Oct was approved by Arvind Sharma.',
      'time': 'Yesterday',
      'icon': Icons.task_alt_rounded,
      'color': AppColors.success,
      'isUnread': false,
    },
    {
      'type': 'HR',
      'title': 'Monthly Payslip Released 💰',
      'desc': 'Payslip for September 2026 is now available for download.',
      'time': '2 days ago',
      'icon': Icons.receipt_long_outlined,
      'color': Color(0xFFF59E0B),
      'isUnread': false,
    },
  ];

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
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n['isUnread'] = false;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All marked as read')),
              );
            },
            child: const Text('Mark all read', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Column(
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
                : ListView.builder(
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
                          color: item['isUnread'] ? Colors.white : Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: item['isUnread'] ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border,
                            width: item['isUnread'] ? 1.5 : 1.0,
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item['title'] as String,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: item['isUnread'] ? FontWeight.w800 : FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      if (item['isUnread'] as bool)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['desc'] as String,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.35),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item['time'] as String,
                                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600),
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
        ],
      ),
    );
  }
}
