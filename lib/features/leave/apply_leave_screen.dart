import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  String _selectedLeaveType = 'Casual Leave (CL) - 8.0 Available';
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  String _session = 'Full Day';
  final _reasonCtrl = TextEditingController();
  bool _isLoading = false;

  final List<String> _leaveTypes = [
    'Casual Leave (CL) - 8.0 Available',
    'Sick Leave (SL) - 5.5 Available',
    'Compensatory Off - 2.0 Available',
    'Leave Without Pay (LWP)',
  ];

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _fromDate : _toDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2028),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
          if (_toDate.isBefore(_fromDate)) _toDate = _fromDate;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  void _handleSubmit() {
    if (_reasonCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid reason for applying leave.'),
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
          content: Text('Leave application submitted for Manager approval!'),
          backgroundColor: AppColors.success,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = _toDate.difference(_fromDate).inDays + 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Apply for Leave', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
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
            // Leave Type Card
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
                  const Text('Select Leave Type', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedLeaveType,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: _leaveTypes.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedLeaveType = val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Date Range Card
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
                  const Text('Select Duration', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, true),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.borderLight,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('FROM DATE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textMuted)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${_fromDate.day}/${_fromDate.month}/${_fromDate.year}',
                                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, false),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.borderLight,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('TO DATE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textMuted)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${_toDate.day}/${_toDate.month}/${_toDate.year}',
                                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Applied Duration:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                        Text('$days ${days > 1 ? "Days" : "Day"}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text('Day Session', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Full Day', 'First Half', 'Second Half'].map((sess) {
                      final isSelected = _session == sess;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(sess),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            fontSize: 12,
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _session = sess);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Reason Card
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
                  const Text('Reason for Leave', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _reasonCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Please describe the reason for your leave request in detail for the reporting manager...',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
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
                    : const Text('Submit Leave Application', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
