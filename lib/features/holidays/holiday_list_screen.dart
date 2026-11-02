import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class HolidayListScreen extends StatelessWidget {
  const HolidayListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final holidays = [
      {'date': '01 Nov - 03 Nov 2026', 'title': 'Diwali & Govardhan Festival', 'type': 'Public Holiday', 'days': '3 Days (Mon - Wed)'},
      {'date': '15 Nov 2026', 'title': 'Guru Nanak Jayanti', 'type': 'Gazetted Holiday', 'days': '1 Day (Sunday)'},
      {'date': '25 Dec 2026', 'title': 'Christmas Celebration', 'type': 'Public Holiday', 'days': '1 Day (Friday)'},
      {'date': '01 Jan 2027', 'title': 'New Year Day', 'type': 'Restricted Holiday', 'days': '1 Day (Friday)'},
      {'date': '26 Jan 2027', 'title': 'Republic Day', 'type': 'National Holiday', 'days': '1 Day (Tuesday)'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Holiday Calendar 2026-27', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.heroCardGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.beach_access_rounded, color: Colors.white, size: 36),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Official Corporate Holidays', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                      SizedBox(height: 4),
                      Text('Aayup Technologies annual holiday roster for Lucknow & remote branches.', style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('All Upcoming Holidays', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 12),
          ...holidays.map((h) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.event_available_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h['title']!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                        const SizedBox(height: 3),
                        Text(h['date']!, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 3),
                        Text('${h['type']} • ${h['days']}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
