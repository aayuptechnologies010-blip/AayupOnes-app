import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/network/api_endpoints.dart';

class HelpdeskScreen extends StatefulWidget {
  const HelpdeskScreen({super.key});

  @override
  State<HelpdeskScreen> createState() => _HelpdeskScreenState();
}

class _HelpdeskScreenState extends State<HelpdeskScreen> {
  bool _isLoading = true;
  List<dynamic> _tickets = [];

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets() async {
    setState(() => _isLoading = true);
    final token = AuthService().token;
    try {
      final res = await http.get(
        Uri.parse(ApiEndpoints.helpdesk),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true && body['data'] is List) {
          if (mounted) {
            setState(() {
              _tickets = body['data'];
              _isLoading = false;
            });
            return;
          }
        }
      }
    } catch (_) {}

    if (mounted) setState(() => _isLoading = false);
  }

  void _openCreateTicketDialog() {
    final subjectCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String dept = 'IT Support';
    String priority = 'Medium';
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Raise Support Ticket', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Department', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: dept,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.apartment_outlined, size: 20)),
                  items: const [
                    DropdownMenuItem(value: 'IT & Hardware Support', child: Text('IT & Hardware Support')),
                    DropdownMenuItem(value: 'HR & Payroll Desk', child: Text('HR & Payroll Desk')),
                    DropdownMenuItem(value: 'Admin & Facilities', child: Text('Admin & Facilities')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => dept = val);
                  },
                ),
                const SizedBox(height: 14),
                const Text('Issue Subject', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: subjectCtrl,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Laptop keyboard key not working',
                    prefixIcon: Icon(Icons.edit_outlined, size: 20),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Priority', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.flag_outlined, size: 20)),
                  items: const [
                    DropdownMenuItem(value: 'LOW', child: Text('Low Priority')),
                    DropdownMenuItem(value: 'MEDIUM', child: Text('Medium Priority')),
                    DropdownMenuItem(value: 'HIGH', child: Text('Urgent / High Priority')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => priority = val);
                  },
                ),
                const SizedBox(height: 14),
                const Text('Detailed Description', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Explain the issue in detail...',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      if (subjectCtrl.text.trim().isEmpty) return;
                      setDialogState(() => isSubmitting = true);
                      final token = AuthService().token;
                      try {
                        await http.post(
                          Uri.parse(ApiEndpoints.helpdesk),
                          headers: {
                            'Authorization': 'Bearer $token',
                            'Content-Type': 'application/json',
                          },
                          body: jsonEncode({
                            'department': dept,
                            'subject': subjectCtrl.text.trim(),
                            'priority': priority,
                            'description': descCtrl.text.trim(),
                          }),
                        );
                      } catch (_) {}

                      Navigator.pop(ctx);
                      _fetchTickets();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Support ticket raised successfully!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    },
              child: isSubmitting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Submit Ticket'),
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
      appBar: AppBar(
        title: const Text('Internal Helpdesk', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _fetchTickets),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: Colors.white,
        onRefresh: _fetchTickets,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Top Action card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.heroCardGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Need assistance from IT, HR or Admin?', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  const Text('Raise a ticket and our internal support team will resolve it within 24-48 business hours.', style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.add_task_rounded, size: 18),
                    label: const Text('Raise New Ticket', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    onPressed: _openCreateTicketDialog,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text('MY TICKETS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: AppColors.textSecondary)),
            const SizedBox(height: 12),

            if (_isLoading)
              const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: AppColors.primary)))
            else if (_tickets.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Center(
                  child: Text('No support tickets raised yet.', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                ),
              )
            else
              ..._tickets.map((t) {
                final status = t['status']?.toString() ?? 'Open';
                final isResolved = status.toLowerCase().contains('resolved');
                final col = isResolved ? AppColors.success : AppColors.warning;
                final ticketId = t['ticketId']?.toString() ?? '#TKT-2026';
                final subject = t['subject']?.toString() ?? 'Support Request';
                final dept = t['category']?.toString() ?? 'IT Support';
                final date = t['created']?.toString() ?? 'Today';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(ticketId, style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: col.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(status, style: TextStyle(color: col, fontSize: 10, fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(subject, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
                            const SizedBox(height: 4),
                            Text('$dept • $date', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    ),
  );
}
}
