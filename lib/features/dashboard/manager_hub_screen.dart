import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ManagerHubScreen extends StatefulWidget {
  const ManagerHubScreen({super.key});

  @override
  State<ManagerHubScreen> createState() => _ManagerHubScreenState();
}

class _ManagerHubScreenState extends State<ManagerHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 1. Pending Approvals List
  final List<Map<String, dynamic>> _pendingRequests = [
    {
      'id': 'REQ-101',
      'name': 'Vikram Singh',
      'role': 'Senior Backend Engineer',
      'avatar': 'VS',
      'category': 'Leave Request',
      'categoryColor': const Color(0xFF6366F1),
      'details': 'Casual Leave (CL) • 30 Oct - 02 Nov (3 Days)',
      'reason': 'Attending sibling wedding ceremony in Varanasi',
      'appliedOn': 'Today, 10:15 AM',
      'icon': Icons.beach_access_rounded,
    },
    {
      'id': 'REQ-102',
      'name': 'Sneha Tiwari',
      'role': 'UI/UX Product Designer',
      'avatar': 'ST',
      'category': 'Attendance Regularization',
      'categoryColor': AppColors.warning,
      'details': '23 Oct 2026 • Late by 25 mins (In: 10:15 AM)',
      'reason': 'Client site meeting at Hazratganj before coming to office',
      'appliedOn': 'Yesterday',
      'icon': Icons.lock_reset_rounded,
    },
    {
      'id': 'REQ-103',
      'name': 'Amit Patel',
      'role': 'QA & Automation Engineer',
      'avatar': 'AP',
      'category': 'Expense Claim',
      'categoryColor': AppColors.success,
      'details': 'Travel & Fuel • ₹ 1,850.00',
      'reason': 'Cab fare for client server deployment at Gomti Nagar office',
      'appliedOn': '26 Oct 2026',
      'icon': Icons.currency_rupee_rounded,
    },
    {
      'id': 'REQ-104',
      'name': 'Pooja Verma',
      'role': 'HR Operations',
      'avatar': 'PV',
      'category': 'Work From Home (WFH)',
      'categoryColor': AppColors.primary,
      'details': 'WFH • 29 Oct 2026 (1 Day)',
      'reason': 'Home plumbing work and electric inspection at residence',
      'appliedOn': '27 Oct 2026',
      'icon': Icons.home_work_outlined,
    },
  ];

  // 2. Team Attendance Members
  final List<Map<String, dynamic>> _teamMembers = [
    {
      'name': 'Vikram Singh',
      'role': 'Senior Backend Engineer',
      'avatar': 'VS',
      'status': 'In Office',
      'statusColor': AppColors.success,
      'statusBg': AppColors.successLight,
      'inTime': '09:28 AM',
      'hoursLogged': '05h 12m',
    },
    {
      'name': 'Sneha Tiwari',
      'role': 'UI/UX Designer',
      'avatar': 'ST',
      'status': 'Work From Home',
      'statusColor': AppColors.primary,
      'statusBg': AppColors.primaryLight,
      'inTime': '09:40 AM',
      'hoursLogged': '04h 45m',
    },
    {
      'name': 'Amit Patel',
      'role': 'QA Engineer',
      'avatar': 'AP',
      'status': 'In Office',
      'statusColor': AppColors.success,
      'statusBg': AppColors.successLight,
      'inTime': '09:55 AM (Late)',
      'hoursLogged': '04h 10m',
    },
    {
      'name': 'Pooja Verma',
      'role': 'HR Operations',
      'avatar': 'PV',
      'status': 'On Leave',
      'statusColor': AppColors.danger,
      'statusBg': AppColors.dangerLight,
      'inTime': '--',
      'hoursLogged': '00h 00m',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleAction(String id, String employeeName, bool isApproved) {
    setState(() {
      _pendingRequests.removeWhere((item) => item['id'] == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isApproved
              ? 'Request for $employeeName has been APPROVED!'
              : 'Request for $employeeName has been REJECTED.',
        ),
        backgroundColor: isApproved ? AppColors.success : AppColors.danger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manager & Approvals Hub', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Pending Approvals'),
                  const SizedBox(width: 6),
                  if (_pendingRequests.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_pendingRequests.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                      ),
                    ),
                ],
              ),
            ),
            const Tab(text: "Today's Team Attendance"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildApprovalsTab(),
          _buildTeamAttendanceTab(),
        ],
      ),
    );
  }

  Widget _buildApprovalsTab() {
    if (_pendingRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.done_all_rounded, size: 48, color: AppColors.success),
            ),
            const SizedBox(height: 16),
            const Text(
              'All Caught Up! 🎉',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'No pending approvals waiting for your action.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _pendingRequests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = _pendingRequests[index];
        final id = item['id'] as String;
        final name = item['name'] as String;
        final categoryColor = item['categoryColor'] as Color;

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employee header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryLight,
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        item['avatar'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(item['role'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(item['icon'] as IconData, size: 13, color: categoryColor),
                        const SizedBox(width: 4),
                        Text(
                          item['category'] as String,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: categoryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Request detail box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['details'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Reason: "${item['reason']}"',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Applied: ${item['appliedOn']}',
                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Action Buttons: Reject & Approve
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: const BorderSide(color: AppColors.danger),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => _handleAction(id, name, false),
                      child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => _handleAction(id, name, true),
                      child: const Text('Approve', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTeamAttendanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Stats Summary
          Row(
            children: [
              _buildMetricCard('Present', '3', AppColors.success, Icons.check_circle_outline),
              const SizedBox(width: 10),
              _buildMetricCard('WFH', '1', AppColors.primary, Icons.home_work_outlined),
              const SizedBox(width: 10),
              _buildMetricCard('On Leave', '1', AppColors.danger, Icons.beach_access_outlined),
            ],
          ),

          const SizedBox(height: 24),

          const Text('TEAM STATUS TODAY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textMuted, letterSpacing: 0.8)),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _teamMembers.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final member = _teamMembers[index];
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
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryLight,
                      ),
                      child: Center(
                        child: Text(
                          member['avatar'] as String,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(member['name'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(member['role'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 13, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text('In: ${member['inTime']}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                              const SizedBox(width: 10),
                              const Icon(Icons.timelapse_rounded, size: 13, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text('Hours: ${member['hoursLogged']}', style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: member['statusBg'] as Color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        member['status'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: member['statusColor'] as Color,
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
    );
  }

  Widget _buildMetricCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
