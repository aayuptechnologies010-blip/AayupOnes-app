import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/network/api_endpoints.dart';
import 'log_work_screen.dart';

class WorkManagementScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const WorkManagementScreen({super.key, this.onBack});

  @override
  State<WorkManagementScreen> createState() => _WorkManagementScreenState();
}

class _WorkManagementScreenState extends State<WorkManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<dynamic> _todayTasks = [];
  List<dynamic> _upcomingTasks = [];
  List<dynamic> _completedTasks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    setState(() => _isLoading = true);
    final token = AuthService().token;
    try {
      final res = await http.get(
        Uri.parse(ApiEndpoints.tasks),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 6));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true && body['data'] != null) {
          if (mounted) {
            setState(() {
              _todayTasks = body['data']['today'] ?? [];
              _upcomingTasks = body['data']['upcoming'] ?? [];
              _completedTasks = body['data']['completed'] ?? [];
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
          tabs: [
            Tab(text: "Today's Work (${_todayTasks.length})"),
            Tab(text: "Upcoming (${_upcomingTasks.length})"),
            Tab(text: "Completed (${_completedTasks.length})"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(_todayTasks, isToday: true),
                _buildTaskList(_upcomingTasks),
                _buildTaskList(_completedTasks, isCompleted: true),
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

  Widget _buildTaskList(List<dynamic> tasks, {bool isToday = false, bool isCompleted = false}) {
    if (tasks.isEmpty) {
      return RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: Colors.white,
        onRefresh: _fetchTasks,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: 400,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.task_alt_rounded, size: 48, color: AppColors.textMuted),
                const SizedBox(height: 12),
                Text(
                  isCompleted ? 'No completed tasks yet' : (isToday ? 'No tasks pending for today' : 'No upcoming tasks scheduled'),
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: _fetchTasks,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
        if (isToday)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
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
        ...tasks.map((t) {
          final priority = t['priority']?.toString() ?? 'Medium';
          final pColor = priority.contains('High')
              ? AppColors.danger
              : (priority.contains('Medium') ? AppColors.warning : AppColors.success);

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _buildTaskCard(
              project: t['project']?.toString() ?? 'AayupOnes HRMS',
              title: t['title']?.toString() ?? 'Assigned Task',
              description: t['description']?.toString() ?? '',
              priority: priority,
              priorityColor: pColor,
              deadline: t['deadline']?.toString() ?? 'Due Today',
              progress: (t['progress'] is num) ? (t['progress'] as num).toDouble() : 0.0,
              assignedBy: t['assignedBy']?.toString() ?? 'Aayup Admin',
              isDone: isCompleted,
            ),
          );
        }),
      ],
    ),
  );
}

  Widget _buildTaskCard({
    required String project,
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
          if (description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(description, style: const TextStyle(fontSize: 12, height: 1.4, color: AppColors.textSecondary)),
          ],
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
