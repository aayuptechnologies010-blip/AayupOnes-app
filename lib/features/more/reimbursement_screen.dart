import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ReimbursementScreen extends StatefulWidget {
  const ReimbursementScreen({super.key});

  @override
  State<ReimbursementScreen> createState() => _ReimbursementScreenState();
}

class _ReimbursementScreenState extends State<ReimbursementScreen> {
  final List<Map<String, dynamic>> _claims = [
    {
      'title': 'Client Travel - Delhi Metro & Cab',
      'category': 'Travel & Fuel',
      'amount': '₹ 1,450.00',
      'date': '24 Oct 2026',
      'status': 'Approved',
      'statusColor': AppColors.success,
      'statusBg': AppColors.successLight,
    },
    {
      'title': 'Team Lunch (Project Milestone)',
      'category': 'Food & Meals',
      'amount': '₹ 3,200.00',
      'date': '18 Oct 2026',
      'status': 'Pending Approval',
      'statusColor': AppColors.warning,
      'statusBg': AppColors.warningLight,
    },
    {
      'title': 'Broadband / Internet Allowance',
      'category': 'WFH Utility',
      'amount': '₹ 1,000.00',
      'date': '01 Oct 2026',
      'status': 'Approved',
      'statusColor': AppColors.success,
      'statusBg': AppColors.successLight,
    },
  ];

  void _openNewClaimModal() {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String category = 'Travel & Fuel';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Submit New Expense Claim', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Expense Title', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Client meeting cab fare',
                    prefixIcon: Icon(Icons.edit_note_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Category', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category_outlined, size: 20),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Travel & Fuel', child: Text('Travel & Fuel')),
                    DropdownMenuItem(value: 'Food & Meals', child: Text('Food & Meals')),
                    DropdownMenuItem(value: 'WFH Utility', child: Text('WFH Utility')),
                    DropdownMenuItem(value: 'Medical', child: Text('Medical')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => category = val);
                  },
                ),
                const SizedBox(height: 14),
                const Text('Claim Amount (₹)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 1500',
                    prefixIcon: Icon(Icons.currency_rupee_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.receipt_outlined, color: AppColors.primary, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Bill / Receipt attached (Camera/Gallery)',
                          style: TextStyle(fontSize: 12, color: AppColors.primaryDark, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty || amountCtrl.text.trim().isEmpty) return;
                setState(() {
                  _claims.insert(0, {
                    'title': titleCtrl.text.trim(),
                    'category': category,
                    'amount': '₹ ${amountCtrl.text.trim()}',
                    'date': 'Today',
                    'status': 'Pending Approval',
                    'statusColor': AppColors.warning,
                    'statusBg': AppColors.warningLight,
                  });
                });
                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Expense claim submitted for manager review!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Submit Claim'),
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
        title: const Text('Reimbursements', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
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
            // Top Summary Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('APPROVED', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textMuted)),
                        SizedBox(height: 6),
                        Text('₹ 2,450.00', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.success)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('UNDER REVIEW', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textMuted)),
                        SizedBox(height: 6),
                        Text('₹ 3,200.00', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.warning)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_circle_outline, size: 20),
                onPressed: _openNewClaimModal,
                label: const Text('New Expense Claim'),
              ),
            ),

            const SizedBox(height: 24),

            // Claims list
            const Text('CLAIMS HISTORY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textMuted, letterSpacing: 0.8)),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _claims.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _claims[index];
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
                          Expanded(
                            child: Text(
                              item['title'] as String,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                            ),
                          ),
                          Text(
                            item['amount'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(item['category'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                              const Text(' • ', style: TextStyle(color: AppColors.textMuted)),
                              Text(item['date'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: item['statusBg'] as Color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item['status'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: item['statusColor'] as Color,
                              ),
                            ),
                          ),
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
