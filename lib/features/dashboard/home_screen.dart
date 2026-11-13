import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/network/api_endpoints.dart';
import '../onboarding/onboarding_screen.dart';
import '../attendance/attendance_screen.dart';
import '../work/work_screen.dart';
import '../leave/leave_screen.dart';
import '../notifications/notifications_screen.dart';
import '../holidays/holiday_list_screen.dart';
import 'manager_hub_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _wishedCelebration = false;
  Map<String, dynamic>? _todayCelebration;
  Map<String, dynamic>? _dashboardSummary;
  List<dynamic> _todayTasks = [];
  bool _isLoading = false;

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLiveDashboardData();
  }

  Future<void> _fetchLiveDashboardData() async {
    final token = AuthService().token;
    if (token == null) return;
    setState(() => _isLoading = true);

    try {
      // 1. Fetch Celebrations
      final celRes = await http.get(
        Uri.parse(ApiEndpoints.celebrations),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 4));

      if (celRes.statusCode == 200) {
        final body = jsonDecode(celRes.body);
        if (body['success'] == true && body['data'] is List && (body['data'] as List).isNotEmpty) {
          _todayCelebration = body['data'][0] as Map<String, dynamic>;
        }
      }

      // 2. Fetch Tasks
      final taskRes = await http.get(
        Uri.parse(ApiEndpoints.tasks),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 4));

      if (taskRes.statusCode == 200) {
        final body = jsonDecode(taskRes.body);
        if (body['success'] == true && body['data'] != null) {
          _todayTasks = body['data']['today'] ?? [];
        }
      }

      // 3. Fetch Dashboard Summary (attendance, onboarding status, payslip)
      final sumRes = await http.get(
        Uri.parse(ApiEndpoints.dashboardSummary),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 4));

      if (sumRes.statusCode == 200) {
        final body = jsonDecode(sumRes.body);
        if (body['success'] == true && body['data'] != null) {
          _dashboardSummary = body['data'] as Map<String, dynamic>;
        }
      }
    } catch (_) {}

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final isOnboardingDone = _dashboardSummary?['onboarding']?['progress'] == 100 &&
        _dashboardSummary?['onboarding']?['status'] == 'Approved';

    final userAvatar = _dashboardSummary?['onboarding']?['avatarInitials'] ?? user?.avatarInitials ?? 'MA';
    final userPic = _dashboardSummary?['onboarding']?['profilePic'] ?? user?.profilePic ?? '';
    final userFullName = _dashboardSummary?['onboarding']?['fullName'] ?? user?.fullName ?? 'Member';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: Colors.white,
          onRefresh: _fetchLiveDashboardData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Profile Greeting Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryLight,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: ClipOval(
                          child: userPic.isNotEmpty
                              ? Image.network(
                                  userPic,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Center(
                                    child: Text(
                                      userAvatar,
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    userAvatar,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${_getTimeGreeting()}, ${userFullName.split(" ").first}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text('👋', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${user?.designation ?? "Team Member"} • ${user?.department ?? "Operations"}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Notification Bell Button
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotificationsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 12,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.danger,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Attendance Clock-in Hero Card
              _buildAttendanceHeroCard(context),

              const SizedBox(height: 14),

              // Manager Hub Banner (Only if manager / HR role)
              if (user?.isManager ?? false)
                InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManagerHubScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.people_outline_rounded, color: Color(0xFF6366F1), size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Manager Approvals Hub',
                                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '• ${_dashboardSummary?['managerHub']?['pendingApprovals'] ?? 0} Pending',
                                    style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Review team leaves, regularizations & attendance',
                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF6366F1)),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 14),

              // Pending Profile Onboarding Banner
              if (!isOnboardingDone)
                _buildOnboardingAlertBanner(context),

              const SizedBox(height: 22),

              // Quick Actions Grid
              const Text(
                'Quick Actions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              _buildQuickActionsGrid(context),

              const SizedBox(height: 24),

              // Today's Work & Tasks
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Today\'s Work & Tasks',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  TextButton(
                    onPressed: () {
                      if (widget.onNavigateTab != null) {
                        widget.onNavigateTab!(2);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkManagementScreen(),
                          ),
                        );
                      }
                    },
                    child: Text('View All (${_todayTasks.length}) ➔', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (_todayTasks.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Text('No pending tasks for today.', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  ),
                )
              else
                ..._todayTasks.take(2).map((t) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildTaskCard(
                      project: t['project']?.toString() ?? 'AayupOnes HRMS',
                      taskTitle: t['title']?.toString() ?? 'Assigned Task',
                      priority: (t['priority']?.toString() ?? 'High').replaceAll(' Priority', ''),
                      progress: (t['progress'] is num) ? (t['progress'] as num).toDouble() : 0.75,
                      dueText: t['deadline']?.toString() ?? 'Due Today',
                      onTap: () {
                        if (widget.onNavigateTab != null) {
                          widget.onNavigateTab!(2);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WorkManagementScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  );
                }),

              const SizedBox(height: 24),

              // Company Wall & Celebrations
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Company Wall & Celebrations 🎉',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  TextButton(
                    onPressed: () => _showCompanyWallModal(context),
                    child: const Text('View Wall', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildCelebrationCard(context),

              const SizedBox(height: 24),

              // Upcoming Holidays Announcement Card
              _buildHolidayAnnouncementCard(context),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildAttendanceHeroCard(BuildContext context) {
    final attData = _dashboardSummary?['attendance'];
    final punchIn = attData?['todayPunchIn'] ?? '09:30 AM';
    final totalHours = attData?['totalHours'] ?? '04h : 38m';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.heroCardGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.white, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'Shift: 09:30 AM - 06:30 PM',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.home_work_outlined, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'WFH Mode Active',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'TODAY\'S WORKING HOURS',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                totalHours,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'logged today',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'First Check-in: $punchIn',
            style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    if (widget.onNavigateTab != null) {
                      widget.onNavigateTab!(1);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AttendanceScreen(),
                        ),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fingerprint_rounded, size: 20, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'View Swipes & Clock Out',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingAlertBanner(BuildContext context) {
    final onbData = _dashboardSummary?['onboarding'];
    final progress = onbData?['progress'] ?? 10;
    final status = onbData?['status']?.toString() ?? 'Not Started';
    final remarks = onbData?['pendingRemarks']?.toString() ?? 'Complete your profile & verify credentials';

    final Color bannerColor = status == 'Submitted'
        ? AppColors.info
        : (status == 'Approved' ? AppColors.success : AppColors.warning);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bannerColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: bannerColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bannerColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  status == 'Submitted' ? Icons.hourglass_top_rounded : Icons.assignment_ind_outlined,
                  color: bannerColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      status == 'Submitted'
                          ? 'Onboarding Submitted (100%)'
                          : 'Onboarding Incomplete ($progress%)',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      remarks,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bannerColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    elevation: 0,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                    );
                    _fetchLiveDashboardData();
                  },
                  child: Text(
                    status == 'Submitted' ? 'Review' : 'Complete',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (progress is num ? progress.toDouble() : 10.0) / 100.0,
              minHeight: 5,
              backgroundColor: bannerColor.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(bannerColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final actions = [
      {
        'title': 'Apply Leave',
        'icon': Icons.calendar_today_rounded,
        'color': AppColors.primary,
        'action': () {
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(3);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LeaveScreen()),
            );
          }
        }
      },
      {
        'title': 'Regularize',
        'icon': Icons.pending_actions_rounded,
        'color': AppColors.info,
        'action': () {
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(1);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AttendanceScreen()),
            );
          }
        }
      },
      {
        'title': 'Daily Update',
        'icon': Icons.rate_review_outlined,
        'color': AppColors.success,
        'action': () {
          _showDailyWorkUpdateModal(context);
        }
      },
      {
        'title': 'My Payslip',
        'icon': Icons.receipt_long_rounded,
        'color': AppColors.warning,
        'action': () {
          _showQuickPayslipModal(context);
        }
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final item = actions[index];
        final col = item['color'] as Color;
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: item['action'] as VoidCallback,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: col.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item['icon'] as IconData, color: col, size: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  item['title'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskCard({
    required String project,
    required String taskTitle,
    required String priority,
    required double progress,
    required String dueText,
    required VoidCallback onTap,
  }) {
    final isHigh = priority == 'High';
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    project,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isHigh
                        ? AppColors.danger.withValues(alpha: 0.1)
                        : AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$priority Priority',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isHigh ? AppColors.danger : AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              taskTitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress: ${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  dueText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isHigh ? AppColors.danger : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrationCard(BuildContext context) {
    if (_todayCelebration == null) {
      return const SizedBox.shrink();
    }

    final isSelf = _todayCelebration?['isSelf'] == true;
    final name = _todayCelebration?['name']?.toString() ?? 'Team Member';
    final role = _todayCelebration?['designation']?.toString() ?? 'AayupOnes';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text('🎂', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSelf ? 'Happy Birthday to You! 🎂' : "$name's Birthday",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  isSelf ? 'Have a fantastic year ahead from all of us!' : '$role • Celebrate together!',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (!isSelf)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _wishedCelebration ? AppColors.successLight : AppColors.primary,
                foregroundColor: _wishedCelebration ? AppColors.success : Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                setState(() {
                  _wishedCelebration = !_wishedCelebration;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_wishedCelebration
                        ? '🎈 Sent birthday wishes to $name on Company Buzz!'
                        : 'Wish withdrawn'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                _wishedCelebration ? 'Wished ✓' : 'Wish 🎈',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHolidayAnnouncementCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
            child: const Text('🗓️', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Holiday: Guru Nanak Jayanti',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '24 Nov 2026 • Official Holiday',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HolidayListScreen()),
              );
            },
            child: const Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showCompanyWallModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Aayup Buzz & Wall 🎉', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView(
                children: [
                  _buildBuzzCard(
                    icon: '🚀',
                    badge: 'New Team Member',
                    title: 'Welcome New Team Members!',
                    subtitle: 'Joined Development & Operations • Aayup Technologies',
                    likes: '14 Cheers',
                  ),
                  if (_todayCelebration != null)
                    _buildBuzzCard(
                      icon: '🎂',
                      badge: 'Birthday Celebration',
                      title: 'Happy Birthday ${_todayCelebration?['name']}! 🎉',
                      subtitle: '${_todayCelebration?['designation'] ?? "Aayup Team"} • Celebrate together!',
                      likes: '28 Wishes',
                    ),
                  _buildBuzzCard(
                    icon: '🏆',
                    badge: 'Work Milestone',
                    title: 'Congratulations on completing work milestones!',
                    subtitle: 'Engineering & Delivery Team • Aayup Technologies',
                    likes: '34 Congratulations',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuzzCard({
    required String icon,
    required String badge,
    required String title,
    required String subtitle,
    required String likes,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(badge, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.favorite, size: 14, color: AppColors.danger),
              const SizedBox(width: 4),
              Text(likes, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  void _showDailyWorkUpdateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Submit Daily Work Log', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(
              'Task: ${_todayTasks.isNotEmpty ? _todayTasks[0]['title'] : "General Work Update"}',
              style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            const Text('Today\'s Deliverables Summary', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter your work update...',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Daily work update sent to Reporting Manager!')),
                  );
                },
                child: const Text('Submit Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickPayslipModal(BuildContext context) {
    final slip = _dashboardSummary?['payslip'];
    final netSalary = slip?['netSalary'] ?? 55425;
    final grossSalary = slip?['grossSalary'] ?? 62500;
    final deductions = slip?['totalDeductions'] ?? 7075;
    final month = slip?['month'] ?? 'October 2026';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$month Payslip', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.heroCardGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('NET TAKE HOME SALARY', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('₹ ${NumberFormatHelper.format(netSalary)}', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const Icon(Icons.verified, color: Colors.white, size: 32),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Basic + HRA + Special Allowances', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                Text('₹ ${NumberFormatHelper.format(grossSalary)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('PF + PT + TDS Deductions', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                Text('- ₹ ${NumberFormatHelper.format(deductions)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.danger)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.download_rounded, size: 20),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$month Payslip PDF downloaded!')),
                  );
                },
                label: const Text('Download Payslip PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NumberFormatHelper {
  static String format(dynamic number) {
    if (number == null) return '0.00';
    final n = (number is num) ? number.toDouble() : (double.tryParse(number.toString()) ?? 0.0);
    return n.toStringAsFixed(2);
  }
}
