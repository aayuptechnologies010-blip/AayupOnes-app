import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../auth/login_screen.dart';
import '../documents/employee_documents_screen.dart';
import '../leave/leave_screen.dart';
import '../attendance/attendance_screen.dart';
import 'helpdesk_screen.dart';

class MoreScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const MoreScreen({super.key, this.onBack});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _isOnDuty = true;
  final String _dutyDuration = "09:27:10";

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirm Logout', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.textPrimary)),
        content: const Text(
          'Are you sure you want to end your current session and sign out from AayupOnes?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showAboutUsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.70,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.business_rounded, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About Aayup Technologies', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.textPrimary)),
                    Text('Empowering Enterprise Workflows', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'Aayup Technologies Private Limited is a fast-growing technology solutions provider delivering enterprise-grade cloud systems, smart workforce platforms, and automated workflow solutions.\n\nAayupOnes is our unified employee and operational portal designed to bring onboarding, attendance, verification, leave approvals, and resource allocation into a single intuitive interface.',
              style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Platform Version:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text('v2.4.0-Enterprise', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Headquarters:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text('Bengaluru & Noida, India', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Support Contact:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text('support@aayuptechnologies.com', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.gavel_rounded, color: AppColors.warning, size: 28),
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Terms of Use & Workplace Policy', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textPrimary)),
                    Text('Employee Code of Conduct', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1. Confidentiality & IP', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                    SizedBox(height: 4),
                    Text(
                      'All source code, designs, credentials, customer records, and operational assets accessed via AayupOnes are proprietary to Aayup Technologies. Unauthorized distribution or copying is strictly prohibited under our Non-Disclosure Agreement.',
                      style: TextStyle(fontSize: 12, height: 1.4, color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 12),
                    Text('2. Shift Punching & Geofence Policy', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                    SizedBox(height: 4),
                    Text(
                      'Employees are required to punch in and out using authentic device biometric verification. Proxy check-ins or manipulating GPS locations violates enterprise attendance standards.',
                      style: TextStyle(fontSize: 12, height: 1.4, color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 12),
                    Text('3. Document Verification Integrity', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                    SizedBox(height: 4),
                    Text(
                      'All government identity and educational credentials submitted during onboarding must be genuine and verifiable. Discrepancies may result in credential re-submission or administrative review.',
                      style: TextStyle(fontSize: 12, height: 1.4, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('I Understand & Acknowledge', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final feedbackCtrl = TextEditingController();
    int rating = 5;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.rate_review_outlined, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Share Feedback', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.textPrimary)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your insights help us improve workplace tools and operations.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                const Text('Overall Experience', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starNum = index + 1;
                    return IconButton(
                      icon: Icon(
                        starNum <= rating ? Icons.star_rounded : Icons.star_border_rounded,
                        color: const Color(0xFFF59E0B),
                        size: 32,
                      ),
                      onPressed: () => setDialogState(() => rating = starNum),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: feedbackCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Share any comments, app suggestions or operational feedback...',
                    hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you! Your feedback has been sent to operations team.'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Standard AayupOnes Brand Gradient Header (Matching App Theme)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Profile',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Official Identity & Operations',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFE0EDFF),
                          ),
                        ),
                      ],
                    ),
                    // Logout button in white pill style
                    InkWell(
                      onTap: () => _showLogoutDialog(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.35)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.door_front_door_outlined, size: 16, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Card 1: Joining Date & Employee ID & Account Status
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Joining Date
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.calendar_month_rounded, size: 20, color: AppColors.primary),
                                    ),
                                    const SizedBox(width: 10),
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Joining Date', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                        SizedBox(height: 2),
                                        Text('02/11/2026', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textPrimary)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Employee ID
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.warningLight,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.badge_rounded, size: 20, color: AppColors.warning),
                                    ),
                                    const SizedBox(width: 10),
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Employee ID', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                        SizedBox(height: 2),
                                        Text(
                                          'AAYUP-EMP-2026-37583',
                                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColors.primary),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(height: 1, color: AppColors.borderLight),
                          const SizedBox(height: 12),
                          // Account Status row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.circle, size: 9, color: AppColors.success),
                                  SizedBox(width: 8),
                                  Text(
                                    'Account Status:',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.successLight,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFA7F3D0)),
                                ),
                                child: const Text(
                                  'ACTIVE',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF065F46),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Card 2: Official Shift Status & End Shift button
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.timer_outlined, size: 18, color: AppColors.textSecondary),
                                  SizedBox(width: 6),
                                  Text(
                                    'OFFICIAL SHIFT',
                                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.3, color: AppColors.textPrimary),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '24/7 Unrestricted',
                                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _isOnDuty ? AppColors.successLight : AppColors.dangerLight,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: _isOnDuty ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 7,
                                      color: _isOnDuty ? AppColors.success : AppColors.danger,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      _isOnDuty ? 'ON DUTY ($_dutyDuration)' : 'OFF DUTY',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: _isOnDuty ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '24/7 OPERATIONAL DUTY',
                                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.textPrimary),
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(Icons.circle, size: 7, color: AppColors.success),
                                        SizedBox(width: 4),
                                        Text('ACTIVE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.success)),
                                        SizedBox(width: 6),
                                        Text('Shift: 24/7', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                      ],
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() => _isOnDuty = !_isOnDuty);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(_isOnDuty ? 'Shift Resumed - Punch Recorded.' : 'Shift Ended - Punch Recorded.'),
                                        backgroundColor: _isOnDuty ? AppColors.success : AppColors.danger,
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEE2E2),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xFFFECACA)),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 9,
                                          height: 9,
                                          decoration: BoxDecoration(
                                            color: AppColors.danger,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          _isOnDuty ? 'End Shift' : 'Start Shift',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12,
                                            color: Color(0xFF991B1B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Grid of Action Tiles matching app standard theme
                    // Row 1: Documents & Leaves
                    Row(
                      children: [
                        Expanded(
                          child: _buildGridTile(
                            icon: Icons.description_outlined,
                            iconBg: AppColors.primaryLight,
                            iconColor: AppColors.primary,
                            title: 'Documents',
                            onTap: () => _navigateTo(context, const EmployeeDocumentsScreen()),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildGridTile(
                            icon: Icons.beach_access_outlined,
                            iconBg: AppColors.successLight,
                            iconColor: AppColors.success,
                            title: 'Leaves',
                            onTap: () => _navigateTo(context, const LeaveScreen()),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Row 2: Attendance
                    Row(
                      children: [
                        Expanded(
                          child: _buildGridTile(
                            icon: Icons.alarm_outlined,
                            iconBg: const Color(0xFFFAF5FF),
                            iconColor: const Color(0xFFA855F7),
                            title: 'Attendance',
                            onTap: () => _navigateTo(context, const AttendanceScreen()),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: SizedBox.shrink(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Row 3: Help & Support & About Us
                    Row(
                      children: [
                        Expanded(
                          child: _buildGridTile(
                            icon: Icons.headset_mic_outlined,
                            iconBg: AppColors.warningLight,
                            iconColor: AppColors.warning,
                            title: 'Help & Support',
                            onTap: () => _navigateTo(context, const HelpdeskScreen()),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildGridTile(
                            icon: Icons.info_outline_rounded,
                            iconBg: const Color(0xFFE0E7FF),
                            iconColor: const Color(0xFF4F46E5),
                            title: 'About Us',
                            onTap: () => _showAboutUsDialog(context),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Row 4: Terms of Use & Share Feedback
                    Row(
                      children: [
                        Expanded(
                          child: _buildGridTile(
                            icon: Icons.assignment_outlined,
                            iconBg: AppColors.borderLight,
                            iconColor: AppColors.textSecondary,
                            title: 'Terms of Use',
                            onTap: () => _showTermsDialog(context),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildGridTile(
                            icon: Icons.chat_bubble_outline_rounded,
                            iconBg: const Color(0xFFFDF2F8),
                            iconColor: const Color(0xFFEC4899),
                            title: 'Share Feedback',
                            onTap: () => _showFeedbackDialog(context),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 84,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
