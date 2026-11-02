import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class WfhRequestScreen extends StatefulWidget {
  const WfhRequestScreen({super.key});

  @override
  State<WfhRequestScreen> createState() => _WfhRequestScreenState();
}

class _WfhRequestScreenState extends State<WfhRequestScreen> {
  String _requestType = 'Work From Home (WFH)';
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  final _reasonCtrl = TextEditingController();
  final _clientLocCtrl = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _wfhHistory = [
    {
      'type': 'Work From Home (WFH)',
      'date': '21 Oct 2026 (1 Day)',
      'reason': 'Home broadband fiber optic installation and technician visit',
      'status': 'Approved',
      'statusColor': AppColors.success,
      'statusBg': AppColors.successLight,
    },
    {
      'type': 'On-Duty (Client Visit)',
      'date': '12 Oct 2026 (1 Day)',
      'reason': 'Solar Project Site Survey & client demo at Gomti Nagar office',
      'status': 'Approved',
      'statusColor': AppColors.success,
      'statusBg': AppColors.successLight,
    },
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
          content: Text('Please specify a reason for WFH / On-Duty request.'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      setState(() {
        _wfhHistory.insert(0, {
          'type': _requestType,
          'date': '${_fromDate.day}/${_fromDate.month}/${_fromDate.year}',
          'reason': _reasonCtrl.text.trim(),
          'status': 'Pending Approval',
          'statusColor': AppColors.warning,
          'statusBg': AppColors.warningLight,
        });
        _reasonCtrl.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WFH / On-Duty request submitted to reporting manager!'),
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
        title: const Text('WFH & On-Duty Request', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
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
            // Top Request Type Selector
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
                  const Text('Request Type', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _requestType = 'Work From Home (WFH)'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: _requestType == 'Work From Home (WFH)' ? AppColors.primaryLight : AppColors.borderLight,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _requestType == 'Work From Home (WFH)' ? AppColors.primary : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.home_work_outlined,
                                  color: _requestType == 'Work From Home (WFH)' ? AppColors.primary : AppColors.textSecondary,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Work From Home',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: _requestType == 'Work From Home (WFH)' ? AppColors.primary : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _requestType = 'On-Duty (Client/External)'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: _requestType == 'On-Duty (Client/External)' ? AppColors.primaryLight : AppColors.borderLight,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _requestType == 'On-Duty (Client/External)' ? AppColors.primary : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.commute_outlined,
                                  color: _requestType == 'On-Duty (Client/External)' ? AppColors.primary : AppColors.textSecondary,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'On-Duty Visit',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: _requestType == 'On-Duty (Client/External)' ? AppColors.primary : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Date Selection
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
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Request Days:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                        Text('$days ${days > 1 ? "Days" : "Day"}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Client Location if On-Duty
            if (_requestType.contains('On-Duty')) ...[
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
                    const Text('Client / Visit Location', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _clientLocCtrl,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Tata Power Solar Site, Vibhuti Khand, Lucknow',
                        prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],

            // Reason field
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
                  const Text('Reason / Remarks to Manager', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _reasonCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Mention reason for working remotely or on-duty client assignment...',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

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
                    : const Text('Submit Request', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ),

            const SizedBox(height: 28),

            // History
            const Text('PAST WFH & ON-DUTY REQUESTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textMuted, letterSpacing: 0.8)),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _wfhHistory.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _wfhHistory[index];
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
                          Text(item['type'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: item['statusBg'] as Color,
                              borderRadius: BorderRadius.circular(6),
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
                      const SizedBox(height: 6),
                      Text(item['date'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                      const SizedBox(height: 4),
                      Text(item['reason'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
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
