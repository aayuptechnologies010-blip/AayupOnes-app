import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/network/api_endpoints.dart';
import 'apply_leave_screen.dart';

class LeaveScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const LeaveScreen({super.key, this.onBack});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  bool _isLoading = true;
  double _casualAvailable = 11.0;
  double _casualTotal = 12.0;
  double _sickAvailable = 8.0;
  double _sickTotal = 8.0;
  double _compOffAvailable = 2.0;
  List<dynamic> _leaves = [];
  List<dynamic> _holidays = [];

  @override
  void initState() {
    super.initState();
    _fetchLeaveData();
  }

  Future<void> _fetchLeaveData() async {
    setState(() => _isLoading = true);
    final token = AuthService().token;
    try {
      // 1. Fetch Leaves
      final leavesRes = await http.get(
        Uri.parse(ApiEndpoints.leaves),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));

      if (leavesRes.statusCode == 200) {
        final body = jsonDecode(leavesRes.body);
        if (body['success'] == true && body['leaves'] != null) {
          _leaves = body['leaves'];
          final clUsed = _leaves
              .where((l) => l['status'] == 'APPROVED' && (l['leaveType'] ?? '').toString().contains('Casual'))
              .fold<double>(0.0, (sum, l) => sum + (l['days'] ?? 1.0));
          final slUsed = _leaves
              .where((l) => l['status'] == 'APPROVED' && (l['leaveType'] ?? '').toString().contains('Sick'))
              .fold<double>(0.0, (sum, l) => sum + (l['days'] ?? 1.0));
          _casualAvailable = (_casualTotal - clUsed).clamp(0.0, _casualTotal);
          _sickAvailable = (_sickTotal - slUsed).clamp(0.0, _sickTotal);
        }
      }

      // 2. Fetch Holidays
      final holRes = await http.get(
        Uri.parse(ApiEndpoints.holidays),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));

      if (holRes.statusCode == 200) {
        final body = jsonDecode(holRes.body);
        if (body['success'] == true && body['holidays'] != null) {
          _holidays = body['holidays'];
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() => _isLoading = false);
    }
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
        title: const Text('Leave Management', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _fetchLeaveData),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: Colors.white,
              onRefresh: _fetchLeaveData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text('Available Leave Balances', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildLeaveBalanceCard('Casual Leave', _casualAvailable.toStringAsFixed(1), '${_casualTotal.toInt()} Total', AppColors.primary, Icons.beach_access_rounded),
                      const SizedBox(width: 10),
                      _buildLeaveBalanceCard('Sick Leave', _sickAvailable.toStringAsFixed(1), '${_sickTotal.toInt()} Total', AppColors.success, Icons.medical_services_outlined),
                      const SizedBox(width: 10),
                      _buildLeaveBalanceCard('Comp Off', _compOffAvailable.toStringAsFixed(1), 'Earned', const Color(0xFF6366F1), Icons.more_time_rounded),
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
                      onPressed: () async {
                        final applied = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ApplyLeaveScreen(),
                          ),
                        );
                        if (applied == true) {
                          _fetchLeaveData();
                        }
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
                        if (_holidays.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('No upcoming holidays found.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          )
                        else
                          ..._holidays.take(3).map((h) {
                            return Column(
                              children: [
                                _buildHolidayTile(h['date'] ?? '', h['name'] ?? '', h['type'] ?? 'Holiday'),
                                const Divider(height: 18, color: AppColors.borderLight),
                              ],
                            );
                          }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  const Text('Recent Applications & Approvals', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 12),

                  if (_leaves.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Center(
                        child: Text(
                          'No leave applications submitted yet.',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  else
                    ..._leaves.map((l) {
                      final status = l['status']?.toString() ?? 'PENDING';
                      final isApproved = status == 'APPROVED';
                      final color = isApproved ? AppColors.success : (status == 'REJECTED' ? AppColors.danger : AppColors.warning);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildRequestHistoryCard(
                          type: l['leaveType']?.toString() ?? 'Leave',
                          dateRange: '${l['fromDate']} to ${l['toDate']} (${l['days']} Day)',
                          reason: l['reason']?.toString() ?? 'Personal Leave',
                          status: status == 'APPROVED' ? 'Approved' : (status == 'REJECTED' ? 'Rejected' : 'Pending Review'),
                          statusColor: color,
                          approvedBy: l['adminRemark']?.toString() ?? 'Under Review by Aayup Admin',
                        ),
                      );
                    }),
                ],
              ),
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

  Widget _buildHolidayTile(String date, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            date,
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 11),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
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
              Text(type, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(dateRange, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text('Reason: "$reason"', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.verified_outlined, size: 14, color: statusColor),
              const SizedBox(width: 6),
              Text(approvedBy, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
