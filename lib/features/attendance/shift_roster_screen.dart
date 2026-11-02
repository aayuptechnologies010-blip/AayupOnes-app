import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ShiftRosterScreen extends StatefulWidget {
  const ShiftRosterScreen({super.key});

  @override
  State<ShiftRosterScreen> createState() => _ShiftRosterScreenState();
}

class _ShiftRosterScreenState extends State<ShiftRosterScreen> {
  int _selectedWeekOffset = 0; // 0: This Week, 1: Next Week

  final List<Map<String, dynamic>> _currentWeekSchedule = [
    {
      'day': 'Mon',
      'date': '26 Oct',
      'shiftName': 'General Day Shift (GEN)',
      'timing': '09:30 AM - 06:30 PM',
      'duration': '9h 00m (1h break)',
      'type': 'Work Day',
      'typeColor': AppColors.primary,
      'isToday': false,
    },
    {
      'day': 'Tue',
      'date': '27 Oct',
      'shiftName': 'General Day Shift (GEN)',
      'timing': '09:30 AM - 06:30 PM',
      'duration': '9h 00m (1h break)',
      'type': 'Work Day',
      'typeColor': AppColors.primary,
      'isToday': false,
    },
    {
      'day': 'Wed',
      'date': '28 Oct',
      'shiftName': 'General Day Shift (GEN)',
      'timing': '09:30 AM - 06:30 PM',
      'duration': '9h 00m (1h break)',
      'type': 'Active Today',
      'typeColor': AppColors.success,
      'isToday': true,
    },
    {
      'day': 'Thu',
      'date': '29 Oct',
      'shiftName': 'General Day Shift (GEN)',
      'timing': '09:30 AM - 06:30 PM',
      'duration': '9h 00m (1h break)',
      'type': 'Work Day',
      'typeColor': AppColors.primary,
      'isToday': false,
    },
    {
      'day': 'Fri',
      'date': '30 Oct',
      'shiftName': 'General Day Shift (GEN)',
      'timing': '09:30 AM - 06:30 PM',
      'duration': '9h 00m (1h break)',
      'type': 'Work Day',
      'typeColor': AppColors.primary,
      'isToday': false,
    },
    {
      'day': 'Sat',
      'date': '31 Oct',
      'shiftName': 'Weekly Off (WO)',
      'timing': 'Non-Working Day',
      'duration': 'Holiday / Rest',
      'type': 'Weekend Off',
      'typeColor': AppColors.textMuted,
      'isToday': false,
    },
    {
      'day': 'Sun',
      'date': '01 Nov',
      'shiftName': 'Weekly Off (WO)',
      'timing': 'Non-Working Day',
      'duration': 'Holiday / Rest',
      'type': 'Weekend Off',
      'typeColor': AppColors.textMuted,
      'isToday': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Shift Schedule & Roster', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Shift Hero Card
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: AppColors.heroCardGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ASSIGNED SHIFT POLICY',
                        style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('General Shift', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('09:30 AM - 06:30 PM', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  const Text('Grace Time: 15 mins (Till 09:45 AM) • Half Day: 4.5 Hours', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 14),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Weekly Off: Saturday & Sunday', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      Text('Total Hours: 45h / Week', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Week Switcher Filter
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedWeekOffset = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedWeekOffset == 0 ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _selectedWeekOffset == 0 ? AppColors.primary : AppColors.border),
                      ),
                      child: Text(
                        'This Week (26 Oct - 01 Nov)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _selectedWeekOffset == 0 ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedWeekOffset = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedWeekOffset == 1 ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _selectedWeekOffset == 1 ? AppColors.primary : AppColors.border),
                      ),
                      child: Text(
                        'Next Week (02 Nov - 08 Nov)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _selectedWeekOffset == 1 ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text('7-DAY ROSTER TIMETABLE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textMuted, letterSpacing: 0.8)),
            const SizedBox(height: 12),

            // 7 Days List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _currentWeekSchedule.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _currentWeekSchedule[index];
                final isToday = item['isToday'] as bool;
                final isWeekend = (item['type'] as String) == 'Weekend Off';

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isToday ? AppColors.primaryLight.withOpacity(0.5) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isToday ? AppColors.primary : AppColors.border,
                      width: isToday ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Day + Date Box
                      Container(
                        width: 52,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isToday ? AppColors.primary : AppColors.borderLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              item['day'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isToday ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['date'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isToday ? Colors.white70 : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['shiftName'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: isWeekend ? AppColors.textMuted : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(
                                  isWeekend ? Icons.weekend_outlined : Icons.schedule_rounded,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item['timing'] as String,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: (item['typeColor'] as Color).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['type'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: item['typeColor'] as Color,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
