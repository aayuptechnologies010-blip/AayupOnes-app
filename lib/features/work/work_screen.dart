import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'log_work_screen.dart';

class WorkManagementScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const WorkManagementScreen({super.key, this.onBack});

  @override
  State<WorkManagementScreen> createState() => _WorkManagementScreenState();
}

class _WorkManagementScreenState extends State<WorkManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        title: const Text('My Work & Tasks', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: const [
            Tab(text: "Today's Work (2)"),
            Tab(text: 'Upcoming (4)'),
            Tab(text: 'Completed (12)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodayTasksList(),
          _buildUpcomingTasksList(),
          _buildCompletedTasksList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Daily Update', style: TextStyle(fontWeight: FontWeight.w700)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LogWorkScreen(taskName: 'Daily Work Update'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodayTasksList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: const Row(
            children: [
              Icon(Icons.tips_and_updates_outlined, color: AppColors.primary, size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Submit your daily progress update before 06:30 PM for manager review.',
                  style: TextStyle(color: AppColors.primaryDark, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        _buildTaskCard(
          project: 'Solar CRM Development',
          module: 'Lead Management System',
          title: 'Implement Excel Lead Bulk Upload Parser API',
          description: 'Build backend multipart upload endpoint in Node.js with field validation and duplicate check logic.',
          priority: 'High Priority',
          priorityColor: AppColors.danger,
          deadline: 'Due Today • 05:00 PM',
          progress: 0.80,
          assignedBy: 'Mr. Arvind Sharma (Tech Lead)',
        ),
        const SizedBox(height: 14),

        _buildTaskCard(
          project: 'AayupOnes Mobile App',
          module: 'Attendance Module',
          title: 'Integrate Geofencing & Biometric Clock Out Screen',
          description: 'Design interactive calendar dots and wire up GPS radius check with office polygon bounds.',
          priority: 'Medium Priority',
          priorityColor: AppColors.warning,
          deadline: 'Due Today • 06:15 PM',
          progress: 0.50,
          assignedBy: 'Mr. Arvind Sharma (Tech Lead)',
        ),
      ],
    );
  }

  Widget _buildUpcomingTasksList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildTaskCard(
          project: 'Solar CRM Development',
          module: 'Reports & Analytics',
          title: 'Lead Conversion Funnel Chart Integration',
          description: 'Visualize weekly lead sources and salesperson conversion metrics via clean SVG chart widgets.',
          priority: 'Medium Priority',
          priorityColor: AppColors.warning,
          deadline: 'Starts 29 Oct 2026',
          progress: 0.0,
          assignedBy: 'Mr. Arvind Sharma (Tech Lead)',
        ),
      ],
    );
  }

  Widget _buildCompletedTasksList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildTaskCard(
          project: 'AayupOnes Mobile App',
          module: 'Auth & Onboarding',
          title: 'Employee First-Login & 6-Step Onboarding Form',
          description: 'Completed onboarding wizard flow with personal details, bank KYC, and document upload.',
          priority: 'High Priority',
          priorityColor: AppColors.success,
          deadline: 'Completed Yesterday',
          progress: 1.0,
          assignedBy: 'Aayup HR System',
          isDone: true,
        ),
      ],
    );
  }

  Widget _buildTaskCard({
    required String project,
    required String module,
    required String title,
    required String description,
    required String priority,
    required Color priorityColor,
    required String deadline,
    required double progress,
    required String assignedBy,
    bool isDone = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDone ? AppColors.success.withValues(alpha: 0.3) : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  project,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  priority,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: priorityColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(fontSize: 12, height: 1.4, color: AppColors.textSecondary)),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress: ${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text(deadline, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDone ? AppColors.success : AppColors.danger)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(isDone ? AppColors.success : AppColors.primary),
            ),
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_circle_outlined, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(assignedBy, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
              TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogWorkScreen(taskName: title),
                    ),
                  );
                },
                child: const Text('Log Update ➔', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
