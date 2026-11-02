import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/attendance_service.dart';
import 'regularize_attendance_screen.dart';
import 'shift_roster_screen.dart';
import 'wfh_request_screen.dart';

class AttendanceScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const AttendanceScreen({super.key, this.onBack});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  int _selectedTab = 0; // 0: My Logs, 1: Monthly Calendar, 2: Regularization
  int _selectedDate = 27;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Time & Attendance',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Live Clock-in Hero Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.heroCardGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.location_on, color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Aayup Technologies HQ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                        ),
                        child: const Text(
                          'Within Geofence',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    '04 : 32 : 18',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Text(
                    'Active Shift: 09:30 AM - 06:30 PM (General)',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Column(
                            children: [
                              Text('Punch In', style: TextStyle(color: Colors.white70, fontSize: 11)),
                              SizedBox(height: 2),
                              Text('09:48 AM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Column(
                            children: [
                              Text('Punch Out', style: TextStyle(color: Colors.white70, fontSize: 11)),
                              SizedBox(height: 2),
                              Text('-- : --', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => _showClockOutConfirm(context),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.touch_app_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('Clock Out for the Day', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Quick Shortcut Row: Shift Schedule & WFH Request
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ShiftRosterScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.event_note_outlined, size: 20, color: AppColors.primary),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Shift Roster', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
                                  Text('View 7-day schedule', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WfhRequestScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.home_work_outlined, size: 20, color: AppColors.success),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('WFH / On-Duty', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
                                  Text('Remote work request', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar Switcher
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _buildTabButton(0, 'Monthly Summary'),
                  _buildTabButton(1, 'Calendar View'),
                  _buildTabButton(2, 'Regularize'),
                ],
              ),
            ),

            if (_selectedTab == 0) _buildMonthlySummaryView(),
            if (_selectedTab == 1) _buildCalendarView(),
            if (_selectedTab == 2) _buildRegularizationView(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlySummaryView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('October 2026 Overview', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('24 Working Days', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _buildStatCard('21', 'Present', AppColors.success, Icons.check_circle_outline),
                    const SizedBox(width: 10),
                    _buildStatCard('2', 'Late Marks', AppColors.warning, Icons.warning_amber_rounded),
                    const SizedBox(width: 10),
                    _buildStatCard('1', 'Leave Taken', const Color(0xFF6366F1), Icons.time_to_leave_outlined),
                    const SizedBox(width: 10),
                    _buildStatCard('0', 'Absent', AppColors.danger, Icons.cancel_outlined),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text('Daily Swipe Logs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),

          _buildDayLogCard(
            day: 'Today, 27 Oct',
            inTime: '09:48 AM',
            outTime: 'In Progress',
            duration: '04h 32m',
            status: 'Present',
            statusColor: AppColors.success,
            location: 'GPS & Web Verified (Office HQ)',
          ),
          _buildDayLogCard(
            day: 'Yesterday, 26 Oct',
            inTime: '09:25 AM',
            outTime: '06:35 PM',
            duration: '09h 10m',
            status: 'On Time',
            statusColor: AppColors.success,
            location: 'Biometric Scanner #02',
          ),
          _buildDayLogCard(
            day: 'Friday, 23 Oct',
            inTime: '10:05 AM',
            outTime: '06:40 PM',
            duration: '08h 35m',
            status: 'Late (15m)',
            statusColor: AppColors.warning,
            location: 'GPS Verified (Office HQ)',
            canRegularize: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('October 2026', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.chevron_left, size: 20), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.chevron_right, size: 20), onPressed: () {}),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                  .map((d) => Text(d, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)))
                  .toList(),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: 31,
              itemBuilder: (context, idx) {
                final date = idx + 1;
                final isSelected = date == _selectedDate;
                final isWeekend = (date % 7 == 5 || date % 7 == 6);
                final isLate = date == 23;

                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (isWeekend ? AppColors.borderLight : (isLate ? AppColors.warningLight : AppColors.successLight)),
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected ? Border.all(color: AppColors.primaryDark, width: 2) : null,
                    ),
                    child: Center(
                      child: Text(
                        '$date',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : (isWeekend ? AppColors.textMuted : (isLate ? AppColors.warning : AppColors.success)),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 14,
              children: [
                _buildLegendItem(AppColors.success, 'Present (P)'),
                _buildLegendItem(AppColors.warning, 'Late (L)'),
                _buildLegendItem(AppColors.border, 'Weekend (WO)'),
                _buildLegendItem(const Color(0xFF6366F1), 'Leave (LV)'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildRegularizationView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Missed a swipe or clocked in late due to on-duty work? Submit a regularization request to your manager.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Pending Regularization (1)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('23 Oct 2026 (Friday)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(8)),
                      child: const Text('Late by 15 mins', style: TextStyle(fontSize: 11, color: AppColors.warning, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Logged In: 10:05 AM • Required: 09:50 AM (Grace)', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _showRegularizeDialog(context),
                    child: const Text('Request Regularization'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String val, String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildDayLogCard({
    required String day,
    required String inTime,
    required String outTime,
    required String duration,
    required String status,
    required Color statusColor,
    required String location,
    bool canRegularize = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(day, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time_filled, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text('$inTime  ➔  $outTime', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('Total: $duration', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.pin_drop_outlined, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(location, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              if (canRegularize) ...[
                const Spacer(),
                GestureDetector(
                  onTap: () => _showRegularizeDialog(context),
                  child: const Text('Regularize', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showClockOutConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clock Out Confirmation', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to end your working shift for today? Total logged time: 04h : 32m.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await AttendanceService().punchOut();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Clocked out successfully! Punch synced with HRMS server.'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('Yes, Clock Out'),
          ),
        ],
      ),
    );
  }

  void _showRegularizeDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegularizeAttendanceScreen(),
      ),
    );
  }
}
