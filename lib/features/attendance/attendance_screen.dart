import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_colors.dart';
import '../../core/services/attendance_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/network/api_endpoints.dart';
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
  int _selectedDate = 5;
  bool _isLoading = true;
  bool _isPunching = false;

  String _punchInTime = '09:30 AM';
  String _punchOutTime = '-- : --';
  bool _isOnDuty = true;
  String _totalHours = '04h 32m';

  int _workingDays = 24;
  int _presentDays = 1;
  int _lateMarks = 0;
  int _leavesTaken = 0;
  int _absentDays = 0;

  List<dynamic> _logs = [];

  @override
  void initState() {
    super.initState();
    _fetchAttendanceSummary();
  }

  Future<void> _fetchAttendanceSummary() async {
    setState(() => _isLoading = true);
    final token = AuthService().token;
    try {
      final res = await http.get(
        Uri.parse(ApiEndpoints.dashboardSummary),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true && body['data']?['attendance'] != null) {
          final att = body['data']['attendance'];
          final overview = att['monthOverview'] ?? {};
          if (mounted) {
            setState(() {
              _punchInTime = att['todayPunchIn'] ?? '09:30 AM';
              _punchOutTime = att['todayPunchOut'] ?? '-- : --';
              _isOnDuty = att['isOnDuty'] ?? true;
              _totalHours = att['totalHours'] ?? '04h 32m';

              _workingDays = overview['workingDays'] ?? 24;
              _presentDays = overview['present'] ?? 1;
              _lateMarks = overview['late'] ?? 0;
              _leavesTaken = overview['leaves'] ?? 0;
              _absentDays = overview['absent'] ?? 0;

              _logs = att['recentLogs'] ?? [];
              _isLoading = false;
            });
            return;
          }
        }
      }
    } catch (_) {}

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _handlePunchAction() async {
    setState(() => _isPunching = true);
    if (_isOnDuty) {
      final success = await AttendanceService().punchOut();
      if (success) {
        setState(() {
          _isOnDuty = false;
          _punchOutTime = '06:30 PM';
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Clocked Out Successfully for Today!')),
          );
        }
      }
    } else {
      final success = await AttendanceService().punchIn(
        locationName: 'Work From Home (WFH Remote)',
        workMode: 'Remote',
      );
      if (success) {
        setState(() {
          _isOnDuty = true;
          _punchInTime = '09:30 AM';
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Clocked In Successfully (WFH Mode)!')),
          );
        }
      }
    }
    setState(() => _isPunching = false);
    _fetchAttendanceSummary();
  }

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
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _fetchAttendanceSummary,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: Colors.white,
              onRefresh: _fetchAttendanceSummary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                                  child: const Icon(Icons.home_work_outlined, color: Colors.white, size: 16),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Work From Home (WFH)',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _isOnDuty ? '• On-Duty' : '• Off-Duty',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          _totalHours,
                          style: const TextStyle(
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
                                child: Column(
                                  children: [
                                    const Text('Punch In', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                    const SizedBox(height: 2),
                                    Text(_punchInTime, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
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
                                child: Column(
                                  children: [
                                    const Text('Punch Out', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                    const SizedBox(height: 2),
                                    Text(_punchOutTime, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
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
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: _isPunching ? null : _handlePunchAction,
                            child: _isPunching
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(_isOnDuty ? Icons.touch_app_rounded : Icons.fingerprint_rounded, size: 20),
                                      const SizedBox(width: 8),
                                      Text(_isOnDuty ? 'Clock Out for the Day' : 'Clock In Now', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
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
                    const Text('Current Month Overview', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('$_workingDays Working Days', style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _buildStatCard('$_presentDays', 'Present', AppColors.success, Icons.check_circle_outline),
                    const SizedBox(width: 10),
                    _buildStatCard('$_lateMarks', 'Late Marks', AppColors.warning, Icons.warning_amber_rounded),
                    const SizedBox(width: 10),
                    _buildStatCard('$_leavesTaken', 'Leave Taken', const Color(0xFF6366F1), Icons.time_to_leave_outlined),
                    const SizedBox(width: 10),
                    _buildStatCard('$_absentDays', 'Absent', AppColors.danger, Icons.cancel_outlined),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text('Daily Swipe Logs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),

          if (_logs.isEmpty)
            _buildDayLogCard(
              day: 'Today, 05 Nov',
              inTime: _punchInTime,
              outTime: _isOnDuty ? 'In Progress' : _punchOutTime,
              duration: _totalHours,
              status: 'Present',
              statusColor: AppColors.success,
              location: 'Office HQ (Gomti Nagar, Lucknow)',
            )
          else
            ..._logs.map((log) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildDayLogCard(
                  day: log['date']?.toString() ?? 'Recent Date',
                  inTime: log['inTime']?.toString() ?? '--:--',
                  outTime: log['outTime']?.toString() ?? '--:--',
                  duration: log['duration']?.toString() ?? '8.5h',
                  status: log['status']?.toString() ?? 'Present',
                  statusColor: AppColors.success,
                  location: log['location']?.toString() ?? 'Office HQ (Gomti Nagar)',
                ),
              );
            }),
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
                const Text('November 2026', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
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
              itemCount: 30,
              itemBuilder: (context, idx) {
                final date = idx + 1;
                final isSelected = date == _selectedDate;
                final isWeekend = (date % 7 == 5 || date % 7 == 6);

                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (isWeekend ? AppColors.borderLight : Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '$date',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isWeekend ? AppColors.textMuted : AppColors.textPrimary),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegularizationView() {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Need Attendance Regularization?', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 4),
                const Text('Apply if punch missed due to client visit or technical issue.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegularizeAttendanceScreen()),
                      );
                    },
                    child: const Text('Apply for Regularization'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String count, String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
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
  }) {
    return Container(
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
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.login_rounded, size: 14, color: AppColors.success),
              const SizedBox(width: 4),
              Text(inTime, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              const SizedBox(width: 16),
              const Icon(Icons.logout_rounded, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(outTime, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              Text('Total: $duration', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(location, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}
