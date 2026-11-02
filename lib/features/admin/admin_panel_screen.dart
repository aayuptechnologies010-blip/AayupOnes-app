import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  // Employee Registry mock list (AayupOnes style)
  final List<Map<String, dynamic>> _employees = [
    {
      'id': 'AAYUP-DEV-0024',
      'name': 'Rahul Kumar',
      'role': 'Senior React & Mobile Developer',
      'dept': 'Engineering',
      'type': 'Full Time',
      'status': 'Active',
      'statusColor': AppColors.success,
      'avatar': 'RK',
      'email': 'rahul.k@aayup.com',
      'phone': '+91 98765 43210',
      'joined': '14 Jan 2024',
      'manager': 'Vikram Singh',
      'salary': '₹ 8,50,000 / yr',
    },
    {
      'id': 'AAYUP-ENG-0012',
      'name': 'Vikram Singh',
      'role': 'Lead Backend Architect',
      'dept': 'Engineering',
      'type': 'Full Time',
      'status': 'Active',
      'statusColor': AppColors.success,
      'avatar': 'VS',
      'email': 'vikram.s@aayup.com',
      'phone': '+91 97654 32109',
      'joined': '02 Feb 2022',
      'manager': 'CEO Office',
      'salary': '₹ 16,00,000 / yr',
    },
    {
      'id': 'AAYUP-DES-0031',
      'name': 'Sneha Tiwari',
      'role': 'Lead Product Designer',
      'dept': 'Design',
      'type': 'Full Time',
      'status': 'On Leave',
      'statusColor': AppColors.warning,
      'avatar': 'ST',
      'email': 'sneha.t@aayup.com',
      'phone': '+91 98111 22334',
      'joined': '18 May 2023',
      'manager': 'Vikram Singh',
      'salary': '₹ 7,80,000 / yr',
    },
    {
      'id': 'AAYUP-QA-0019',
      'name': 'Amit Patel',
      'role': 'QA Automation Lead',
      'dept': 'Quality Assurance',
      'type': 'Full Time',
      'status': 'Active',
      'statusColor': AppColors.success,
      'avatar': 'AP',
      'email': 'amit.p@aayup.com',
      'phone': '+91 96555 44332',
      'joined': '10 Aug 2023',
      'manager': 'Vikram Singh',
      'salary': '₹ 6,50,000 / yr',
    },
    {
      'id': 'AAYUP-HR-0008',
      'name': 'Pooja Verma',
      'role': 'Senior HR Specialist',
      'dept': 'People & Culture',
      'type': 'Full Time',
      'status': 'Active',
      'statusColor': AppColors.success,
      'avatar': 'PV',
      'email': 'pooja.v@aayup.com',
      'phone': '+91 99887 76655',
      'joined': '01 Nov 2021',
      'manager': 'CEO Office',
      'salary': '₹ 7,20,000 / yr',
    },
    {
      'id': 'AAYUP-MKT-0045',
      'name': 'Rohan Saxena',
      'role': 'Growth & Marketing Lead',
      'dept': 'Marketing',
      'type': 'Contractor',
      'status': 'Probation',
      'statusColor': AppColors.info,
      'avatar': 'RS',
      'email': 'rohan.s@aayup.com',
      'phone': '+91 91234 56789',
      'joined': '01 Sep 2026',
      'manager': 'Pooja Verma',
      'salary': '₹ 5,40,000 / yr',
    },
  ];

  // Leave Approvals Inbox
  final List<Map<String, dynamic>> _leaveRequests = [
    {
      'id': 'LR-901',
      'emp': 'Sneha Tiwari',
      'role': 'UI/UX Designer',
      'type': 'Casual Leave (CL)',
      'duration': '30 Oct - 02 Nov (3 Days)',
      'reason': 'Family function in Varanasi',
      'applied': '2 hours ago',
      'status': 'Pending',
    },
    {
      'id': 'LR-902',
      'emp': 'Amit Patel',
      'role': 'QA Engineer',
      'type': 'Sick Leave (SL)',
      'duration': '03 Nov (1 Day)',
      'reason': 'Viral fever and doctor consultation',
      'applied': 'Yesterday',
      'status': 'Pending',
    },
    {
      'id': 'LR-903',
      'emp': 'Rohan Saxena',
      'role': 'Marketing Lead',
      'type': 'Work From Home (WFH)',
      'duration': '04 Nov (1 Day)',
      'reason': 'Broadband technician appointment at residence',
      'applied': 'Yesterday',
      'status': 'Approved',
    },
  ];

  // Attendance exceptions
  final List<Map<String, dynamic>> _attendanceExceptions = [
    {
      'emp': 'Sneha Tiwari',
      'date': 'Today',
      'shift': '09:30 AM - 06:30 PM',
      'firstIn': '10:18 AM',
      'issue': 'Late Arrival (48m)',
      'issueColor': AppColors.warning,
      'status': 'Regularize Requested',
    },
    {
      'emp': 'Amit Patel',
      'date': 'Today',
      'shift': '09:30 AM - 06:30 PM',
      'firstIn': '09:35 AM',
      'issue': 'On Time',
      'issueColor': AppColors.success,
      'status': 'Normal',
    },
    {
      'emp': 'Rahul Kumar',
      'date': 'Today',
      'shift': '09:30 AM - 06:30 PM',
      'firstIn': '09:25 AM',
      'issue': 'On Time',
      'issueColor': AppColors.success,
      'status': 'Normal',
    },
    {
      'emp': 'Rohan Saxena',
      'date': 'Today',
      'shift': '09:30 AM - 06:30 PM',
      'firstIn': 'Missed Punch',
      'issue': 'No In-Punch',
      'issueColor': AppColors.danger,
      'status': 'Action Required',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddEmployeeDialog() {
    final nameCtrl = TextEditingController();
    final roleCtrl = TextEditingController();
    final deptCtrl = TextEditingController(text: 'Engineering');
    final emailCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Onboard New Employee', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                    Text('Add to Aayup HRMS Registry', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name', hintText: 'e.g. Ankit Sharma', prefixIcon: Icon(Icons.badge_outlined)),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: roleCtrl,
              decoration: const InputDecoration(labelText: 'Designation / Job Role', hintText: 'e.g. Flutter Specialist', prefixIcon: Icon(Icons.work_outline_rounded)),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: deptCtrl,
              decoration: const InputDecoration(labelText: 'Department', hintText: 'Engineering, Design, HR', prefixIcon: Icon(Icons.business_rounded)),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Official Corporate Email', hintText: 'ankit.s@aayup.com', prefixIcon: Icon(Icons.email_outlined)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  if (nameCtrl.text.trim().isNotEmpty) {
                    setState(() {
                      _employees.insert(0, {
                        'id': 'AAYUP-EMP-00${_employees.length + 10}',
                        'name': nameCtrl.text.trim(),
                        'role': roleCtrl.text.trim().isEmpty ? 'Associate Developer' : roleCtrl.text.trim(),
                        'dept': deptCtrl.text.trim(),
                        'type': 'Full Time',
                        'status': 'Active',
                        'statusColor': AppColors.success,
                        'avatar': nameCtrl.text.trim().substring(0, 2).toUpperCase(),
                        'email': emailCtrl.text.trim().isEmpty ? 'new.user@aayup.com' : emailCtrl.text.trim(),
                        'phone': '+91 98000 11223',
                        'joined': 'Today',
                        'manager': 'Rahul Kumar',
                        'salary': '₹ 6,00,000 / yr',
                      });
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Employee onboarded & credential invite sent!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
                child: const Text('Confirm & Create Account', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmployeeDetails(Map<String, dynamic> emp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 44, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    emp['avatar'],
                    style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 20),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(emp['name'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
                      Text(emp['role'], style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (emp['statusColor'] as Color).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          emp['status'],
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: emp['statusColor']),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Employee ID', emp['id'], Icons.badge_outlined),
            _buildDetailRow('Department', emp['dept'], Icons.domain_rounded),
            _buildDetailRow('Corporate Email', emp['email'], Icons.email_outlined),
            _buildDetailRow('Contact Phone', emp['phone'], Icons.phone_outlined),
            _buildDetailRow('Joining Date', emp['joined'], Icons.calendar_today_outlined),
            _buildDetailRow('Reporting Manager', emp['manager'], Icons.supervised_user_circle_outlined),
            _buildDetailRow('Annual CTC', emp['salary'], Icons.currency_rupee_rounded),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profile edit initiated for ${emp['name']}')),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit Profile'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Password reset token sent to ${emp['email']}')),
                      );
                    },
                    icon: const Icon(Icons.lock_reset_rounded, size: 18),
                    label: const Text('Reset Pass'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AayupOnes HR Admin Console',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textPrimary),
                ),
                Text(
                  'Aayup Technologies • Lucknow Office',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          const SizedBox(width: 6),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              tabs: const [
                Tab(icon: Icon(Icons.dashboard_rounded, size: 18), text: 'Overview'),
                Tab(icon: Icon(Icons.people_alt_rounded, size: 18), text: 'Employees'),
                Tab(icon: Icon(Icons.approval_rounded, size: 18), text: 'Approvals'),
                Tab(icon: Icon(Icons.how_to_reg_rounded, size: 18), text: 'Attendance'),
                Tab(icon: Icon(Icons.payments_rounded, size: 18), text: 'Payroll'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildEmployeesTab(),
          _buildApprovalsTab(),
          _buildAttendanceTab(),
          _buildPayrollTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Employee', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
        onPressed: _showAddEmployeeDialog,
      ),
    );
  }

  // 1. OVERVIEW TAB (AayupOnes Style Analytics & Action Center)
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner greeting
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'HR EXECUTIVE ACCESS',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Good Day, Admin',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Here is what is happening across Aayup Technologies workforce today.',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shield_rounded, color: Color(0xFF38BDF8), size: 36),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Quick Stat KPI Cards (AayupOnes Metrics)
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Total Headcount',
                  value: '42',
                  sub: '+3 this month',
                  icon: Icons.groups_rounded,
                  color: AppColors.primary,
                  onTap: () => _tabController.animateTo(1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Present Today',
                  value: '38',
                  sub: '90.4% turnout',
                  icon: Icons.check_circle_rounded,
                  color: AppColors.success,
                  onTap: () => _tabController.animateTo(3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'On Leave / WFH',
                  value: '4',
                  sub: '2 WFH, 2 Leave',
                  icon: Icons.beach_access_rounded,
                  color: AppColors.warning,
                  onTap: () => _tabController.animateTo(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Pending Requests',
                  value: '6',
                  sub: '3 Leave, 3 Reg.',
                  icon: Icons.pending_actions_rounded,
                  color: const Color(0xFF6366F1),
                  onTap: () => _tabController.animateTo(2),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Attendance Pulse Bar
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Today Attendance Pulse', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    Text('38 / 42 Employees', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      Expanded(flex: 34, child: Container(height: 12, color: AppColors.success)),
                      Expanded(flex: 4, child: Container(height: 12, color: AppColors.info)),
                      Expanded(flex: 2, child: Container(height: 12, color: AppColors.warning)),
                      Expanded(flex: 2, child: Container(height: 12, color: AppColors.danger)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPulseIndicator('In-Office (34)', AppColors.success),
                    _buildPulseIndicator('WFH (4)', AppColors.info),
                    _buildPulseIndicator('Leave (2)', AppColors.warning),
                    _buildPulseIndicator('Absent (2)', AppColors.danger),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Quick HR Actions (AayupOnes Quick Access)
          const Text('ADMIN SHORTCUTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textMuted, letterSpacing: 0.8)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildShortcutButton(
                  title: 'Add Employee',
                  icon: Icons.person_add_alt_1_rounded,
                  color: AppColors.primary,
                  onTap: _showAddEmployeeDialog,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildShortcutButton(
                  title: 'Run Payroll',
                  icon: Icons.payments_rounded,
                  color: const Color(0xFF10B981),
                  onTap: () => _tabController.animateTo(4),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildShortcutButton(
                  title: 'Approvals',
                  icon: Icons.task_alt_rounded,
                  color: const Color(0xFF8B5CF6),
                  onTap: () => _tabController.animateTo(2),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Department Breakdown
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Headcount by Department', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 14),
                _buildDeptProgress('Engineering', 24, 42, AppColors.primary),
                _buildDeptProgress('Product Design', 6, 42, const Color(0xFFEC4899)),
                _buildDeptProgress('Quality Assurance', 5, 42, const Color(0xFFF59E0B)),
                _buildDeptProgress('People & HR', 4, 42, const Color(0xFF10B981)),
                _buildDeptProgress('Sales & Marketing', 3, 42, const Color(0xFF8B5CF6)),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String sub,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 14),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(sub, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildPulseIndicator(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildShortcutButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildDeptProgress(String dept, int count, int total, Color color) {
    final double pct = count / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dept, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Text('$count (${(pct * 100).toStringAsFixed(0)}%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppColors.borderLight,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  // 2. EMPLOYEES DIRECTORY (AayupOnes Employee Registry with Search & Filters)
  Widget _buildEmployeesTab() {
    final filtered = _employees.where((e) {
      final q = _searchQuery.toLowerCase();
      return e['name'].toString().toLowerCase().contains(q) ||
          e['id'].toString().toLowerCase().contains(q) ||
          e['role'].toString().toLowerCase().contains(q) ||
          e['dept'].toString().toLowerCase().contains(q);
    }).toList();

    return Column(
      children: [
        // Search bar & count
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            children: [
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search by name, Emp ID, or designation...',
                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing ${filtered.length} Employees',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.filter_list_rounded, size: 14, color: AppColors.primary),
                            SizedBox(width: 4),
                            Text('All Depts', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const Divider(height: 1, color: AppColors.border),

        // Employee Cards List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final emp = filtered[i];
              return InkWell(
                onTap: () => _showEmployeeDetails(emp),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          emp['avatar'],
                          style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 16),
                        ),
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
                                    emp['name'],
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textPrimary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: (emp['statusColor'] as Color).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    emp['status'],
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: emp['statusColor']),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              emp['role'],
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Text(
                                    emp['id'],
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '•  ${emp['dept']}',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 3. APPROVALS TAB (AayupOnes Approvals Inbox)
  Widget _buildApprovalsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Pending Action Requests (3)',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  for (var req in _leaveRequests) {
                    req['status'] = 'Approved';
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All pending requests approved!'), backgroundColor: AppColors.success),
                );
              },
              child: const Text('Approve All', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._leaveRequests.map((req) {
          final isPending = req['status'] == 'Pending';
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
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            req['emp'].toString().substring(0, 1),
                            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(req['emp'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                            Text(req['role'], style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isPending ? AppColors.warningLight : AppColors.successLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        req['status'],
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isPending ? AppColors.warning : AppColors.success),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: AppColors.borderLight, height: 1),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                      child: Text(req['type'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ),
                    const SizedBox(width: 8),
                    Text(req['duration'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Reason: "${req['reason']}"',
                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                if (isPending)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.danger,
                            side: const BorderSide(color: AppColors.danger),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            setState(() => req['status'] = 'Rejected');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Request rejected for ${req['emp']}')),
                            );
                          },
                          child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            setState(() => req['status'] = 'Approved');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Request approved for ${req['emp']}!'), backgroundColor: AppColors.success),
                            );
                          },
                          child: const Text('Approve', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // 4. ATTENDANCE MONITOR (AayupOnes Who is in Today & Exceptions)
  Widget _buildAttendanceTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Top summary metrics
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shift Timing: General Shift', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  Text('09:30 AM - 06:30 PM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildAttendMiniStat('34', 'In Office', AppColors.success),
                  _buildAttendMiniStat('4', 'Work From Home', AppColors.info),
                  _buildAttendMiniStat('2', 'On Leave', AppColors.warning),
                  _buildAttendMiniStat('2', 'Unmarked', AppColors.danger),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        const Text('Attendance Exceptions & Log', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        const SizedBox(height: 10),

        ..._attendanceExceptions.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (item['issueColor'] as Color).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.access_time_rounded, color: item['issueColor'], size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['emp'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text('First In: ${item['firstIn']} • Shift: ${item['shift']}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: (item['issueColor'] as Color).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(item['issue'], style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: item['issueColor'])),
                          ),
                          const SizedBox(width: 8),
                          Text(item['status'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert_rounded, color: AppColors.textMuted),
                  onPressed: () {},
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAttendMiniStat(String count, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 2),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // 5. PAYROLL TAB (AayupOnes Salary Processing, Cycles & Disbursals)
  Widget _buildPayrollTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Payroll cycle card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0066D6), Color(0xFF004BA8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
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
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('CYCLE: OCT 2026', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(8)),
                    child: const Text('READY TO RUN', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text('Total Net Disbursal Estimate', style: TextStyle(color: Color(0xFFE0E7FF), fontSize: 12)),
              const SizedBox(height: 4),
              const Text('₹ 28,45,600.00', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('42 Employees Processed', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text('Payout Date: 31 Oct', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Payroll Steps Progress (AayupOnes 4-step wizard)
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
              const Text('Payroll Processing Steps', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              const SizedBox(height: 14),
              _buildPayrollStep('1', 'Attendance & Leaves Finalized', 'Completed on 28 Oct', true),
              _buildPayrollStep('2', 'Reimbursements & Arrears Approved', 'Completed (₹ 42,500 total)', true),
              _buildPayrollStep('3', 'TDS & Statutory Deductions (PF/ESI)', 'Computed automatically', true),
              _buildPayrollStep('4', 'Direct Bank Disbursal Batch', 'Pending HR Master confirmation', false),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payroll batch executed & payslips published to employees!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Execute Final Disbursal & Publish Payslips', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Statutory & Compliance breakdown
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
              const Text('Statutory Compliance Summary', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              const SizedBox(height: 12),
              _buildPayrollStatRow('Provident Fund (EPF)', '₹ 2,14,500', '12% Employee + 12% Employer'),
              _buildPayrollStatRow('Employee State Insurance (ESIC)', '₹ 38,200', '0.75% + 3.25%'),
              _buildPayrollStatRow('Professional Tax (PT)', '₹ 8,400', 'UP Slab applicable'),
              _buildPayrollStatRow('Income Tax TDS (Sec 192)', '₹ 3,45,000', 'Auto computed from 12BB declaration'),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildPayrollStep(String num, String title, String sub, bool done) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? AppColors.successLight : AppColors.primaryLight,
              border: Border.all(color: done ? AppColors.success : AppColors.primary),
            ),
            child: Center(
              child: done
                  ? const Icon(Icons.check_rounded, color: AppColors.success, size: 16)
                  : Text(num, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.primary)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text(sub, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayrollStatRow(String title, String amount, String rule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Text(rule, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
          Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

