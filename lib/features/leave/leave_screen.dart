import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'apply_leave_screen.dart';

class LeaveScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const LeaveScreen({super.key, this.onBack});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
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
        title: const Text('Leave Management', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline_rounded), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Available Leave Balances', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildLeaveBalanceCard('Casual Leave', '8.0', '12 Total', AppColors.primary, Icons.beach_access_rounded),
                const SizedBox(width: 10),
                _buildLeaveBalanceCard('Sick Leave', '5.5', '8 Total', AppColors.success, Icons.medical_services_outlined),
                const SizedBox(width: 10),
                _buildLeaveBalanceCard('Comp Off', '2.0', 'Earned', const Color(0xFF6366F1), Icons.more_time_rounded),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                label: const Text('Apply for New Leave', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ApplyLeaveScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Upcoming Public Holidays 🗓️', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                      Text('Holiday List 2026', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildHolidayTile('01 Nov - 03 Nov', 'Diwali & Govardhan Puja', '3 Days Off (Mon - Wed)'),
                  const Divider(height: 18, color: AppColors.borderLight),
                  _buildHolidayTile('25 Dec', 'Christmas Day', '1 Day Off (Friday)'),
                ],
              ),
            ),

            const SizedBox(height: 26),

            const Text('Recent Applications & Approvals', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 12),

            _buildRequestHistoryCard(
              type: 'Casual Leave (CL)',
              dateRange: '14 Oct 2026 (1 Day)',
              reason: 'Attending family celebration at hometown',
              status: 'Approved',
              statusColor: AppColors.success,
              approvedBy: 'Approved by Arvind Sharma on 12 Oct',
            ),
            _buildRequestHistoryCard(
              type: 'Sick Leave (SL)',
              dateRange: '02 Sep 2026 (Half Day - Second Half)',
              reason: 'Severe headache and doctor consultation',
              status: 'Approved',
              statusColor: AppColors.success,
              approvedBy: 'Approved by Arvind Sharma on 02 Sep',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveBalanceCard(String title, String available, String total, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(available, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
            const SizedBox(height: 2),
            Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary), textAlign: TextAlign.center),
            const SizedBox(height: 2),
            Text(total, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildHolidayTile(String date, String name, String duration) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(date, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              Text(duration, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestHistoryCard({
    required String type,
    required String dateRange,
    required String reason,
    required String status,
    required Color statusColor,
    required String approvedBy,
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
              Text(type, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
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
          const SizedBox(height: 6),
          Text(dateRange, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('Reason: "$reason"', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.verified_user_outlined, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(approvedBy, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}
