import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class RegularizeAttendanceScreen extends StatefulWidget {
  final String date;
  final String issue;

  const RegularizeAttendanceScreen({
    super.key,
    this.date = '23 Oct 2026 (Friday)',
    this.issue = 'Late Arrival: 10:05 AM (Shift starts 09:30 AM)',
  });

  @override
  State<RegularizeAttendanceScreen> createState() => _RegularizeAttendanceScreenState();
}

class _RegularizeAttendanceScreenState extends State<RegularizeAttendanceScreen> {
  String _selectedReason = 'Client Meeting / On-Duty';
  final _remarksCtrl = TextEditingController();
  final _correctInCtrl = TextEditingController(text: '09:30 AM');
  final _correctOutCtrl = TextEditingController(text: '06:30 PM');
  bool _isLoading = false;

  final List<String> _reasons = [
    'Client Meeting / On-Duty',
    'Traffic Delay / Vehicle Breakdown',
    'Biometric Machine / Network Glitch',
    'Personal Emergency',
    'Forgot to Punch In / Out',
  ];

  void _handleSubmit() {
    if (_remarksCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide an explanation for your manager.'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Regularization request submitted to reporting manager!'),
          backgroundColor: AppColors.success,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Regularize Attendance', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
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
            // Issue summary header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.date, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                        const SizedBox(height: 3),
                        Text(widget.issue, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Correct timings
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
                  const Text('Actual / Correct Timings', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ACTUAL IN TIME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textMuted)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _correctInCtrl,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.access_time_rounded, size: 18, color: AppColors.primary),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ACTUAL OUT TIME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textMuted)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _correctOutCtrl,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.access_time_rounded, size: 18, color: AppColors.primary),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Reason selector
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
                  const Text('Reason Category', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedReason,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.category_outlined, color: AppColors.primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _reasons.map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedReason = val);
                    },
                  ),
                  const SizedBox(height: 18),
                  const Text('Remarks / Note to Reporting Manager', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _remarksCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Explain the reason in detail so your reporting manager can approve...',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                      )
                    : const Text('Submit Regularization Request', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
