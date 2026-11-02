import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class HelpdeskScreen extends StatefulWidget {
  const HelpdeskScreen({super.key});

  @override
  State<HelpdeskScreen> createState() => _HelpdeskScreenState();
}

class _HelpdeskScreenState extends State<HelpdeskScreen> {
  final List<Map<String, dynamic>> _tickets = [
    {
      'ticketId': '#TKT-2026-089',
      'subject': 'Dual Monitor HDMI Cable Request',
      'dept': 'IT Support',
      'date': '26 Oct 2026',
      'status': 'In Progress',
      'statusColor': AppColors.warning,
      'statusBg': AppColors.warningLight,
    },
    {
      'ticketId': '#TKT-2026-042',
      'subject': 'PF UAN Transfer Query',
      'dept': 'HR & Payroll',
      'date': '15 Oct 2026',
      'status': 'Resolved',
      'statusColor': AppColors.success,
      'statusBg': AppColors.successLight,
    },
  ];

  void _openCreateTicketDialog() {
    final subjectCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String dept = 'IT Support';
    String priority = 'Medium';

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
                    DropdownMenuItem(value: 'IT Support', child: Text('IT & Hardware Support')),
                    DropdownMenuItem(value: 'HR & Payroll', child: Text('HR & Payroll Desk')),
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
                    DropdownMenuItem(value: 'Low', child: Text('Low Priority')),
                    DropdownMenuItem(value: 'Medium', child: Text('Medium Priority')),
                    DropdownMenuItem(value: 'High', child: Text('Urgent / High Priority')),
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
              onPressed: () {
                if (subjectCtrl.text.trim().isEmpty) return;
                setState(() {
                  _tickets.insert(0, {
                    'ticketId': '#TKT-2026-${100 + _tickets.length}',
                    'subject': subjectCtrl.text.trim(),
                    'dept': dept,
                    'date': 'Today',
                    'status': 'Open',
                    'statusColor': AppColors.info,
                    'statusBg': AppColors.infoLight,
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Support ticket raised successfully!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Submit Ticket'),
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
      ),
      body: SingleChildScrollView(
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
                  const Text(
                    'Need assistance from IT, HR or Admin?',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Raise a ticket and our internal support team will resolve it within 24-48 business hours.',
                    style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.add_task_rounded, size: 18),
                    onPressed: _openCreateTicketDialog,
                    label: const Text('Raise New Ticket', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text('MY TICKETS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textMuted, letterSpacing: 0.8)),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tickets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final ticket = _tickets[index];
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
                          Text(ticket['ticketId'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primary)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: ticket['statusBg'] as Color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              ticket['status'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: ticket['statusColor'] as Color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ticket['subject'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.apartment_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(ticket['dept'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const Text(' • ', style: TextStyle(color: AppColors.textMuted)),
                          Text(ticket['date'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
