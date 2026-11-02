import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class PayslipScreen extends StatefulWidget {
  const PayslipScreen({super.key});

  @override
  State<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  String _selectedMonth = 'September 2026';

  final List<Map<String, dynamic>> _payslipHistory = [
    {
      'month': 'September 2026',
      'net': '₹ 48,500.00',
      'gross': '₹ 52,500.00',
      'deductions': '₹ 4,000.00',
      'status': 'Paid',
      'paidDate': '30 Sep 2026',
    },
    {
      'month': 'August 2026',
      'net': '₹ 48,500.00',
      'gross': '₹ 52,500.00',
      'deductions': '₹ 4,000.00',
      'status': 'Paid',
      'paidDate': '31 Aug 2026',
    },
    {
      'month': 'July 2026',
      'net': '₹ 48,500.00',
      'gross': '₹ 52,500.00',
      'deductions': '₹ 4,000.00',
      'status': 'Paid',
      'paidDate': '31 Jul 2026',
    },
    {
      'month': 'June 2026',
      'net': '₹ 46,200.00',
      'gross': '₹ 52,500.00',
      'deductions': '₹ 6,300.00',
      'status': 'Paid',
      'paidDate': '30 Jun 2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Salary & Payslips', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
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
            // Month Selector Dropdown Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 20),
                      SizedBox(width: 10),
                      Text('Pay Period:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    ],
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedMonth,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                      items: _payslipHistory.map((item) {
                        return DropdownMenuItem<String>(
                          value: item['month'] as String,
                          child: Text(
                            item['month'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedMonth = val);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Net Take Home Hero Card
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: AppColors.heroCardGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'NET TAKE HOME SALARY',
                        style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text('Disbursed', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('₹ 48,500.00', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 14),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryMetric('Gross Earnings', '₹ 52,500.00'),
                      _buildSummaryMetric('Deductions', '₹ 4,000.00'),
                      _buildSummaryMetric('Pay Days', '30 Days'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Salary Breakdown Sections
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Earnings', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textPrimary)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Total: ₹ 52,500', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildSalaryRow('Basic Salary', '₹ 25,000.00'),
                  _buildSalaryRow('House Rent Allowance (HRA)', '₹ 12,500.00'),
                  _buildSalaryRow('Special Allowance', '₹ 15,000.00'),
                  const SizedBox(height: 18),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Deductions', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textPrimary)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.dangerLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Total: ₹ 4,000', style: TextStyle(color: AppColors.danger, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildSalaryRow('Provident Fund (Employee PF)', '- ₹ 1,800.00', isDeduction: true),
                  _buildSalaryRow('Professional Tax (PT)', '- ₹ 200.00', isDeduction: true),
                  _buildSalaryRow('TDS / Income Tax', '- ₹ 2,000.00', isDeduction: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Download Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.download_rounded, size: 20),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$_selectedMonth Payslip PDF downloaded successfully!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                label: Text('Download $_selectedMonth PDF'),
              ),
            ),

            const SizedBox(height: 24),

            // Past Payslips History
            const Text('PAST PAYSLIPS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textMuted, letterSpacing: 0.8)),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _payslipHistory.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _payslipHistory[index];
                return Container(
                  padding: const EdgeInsets.all(16),
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
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['month'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            const SizedBox(height: 2),
                            Text('Paid on ${item['paidDate']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(item['net'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          const Text('Download', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w700)),
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

  Widget _buildSummaryMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
      ],
    );
  }

  Widget _buildSalaryRow(String label, String amount, {bool isDeduction = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text(
            amount,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDeduction ? AppColors.danger : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
