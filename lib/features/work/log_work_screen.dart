import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LogWorkScreen extends StatefulWidget {
  final String taskName;

  const LogWorkScreen({super.key, this.taskName = 'Solar CRM Module'});

  @override
  State<LogWorkScreen> createState() => _LogWorkScreenState();
}

class _LogWorkScreenState extends State<LogWorkScreen> {
  final _hoursCtrl = TextEditingController(text: '4.5');
  final _descCtrl = TextEditingController(
    text: 'Finished the multipart API controller, added validation for phone/email headers, and created test seeds.',
  );
  double _progress = 0.80;
  bool _isLoading = false;

  void _handleSubmit() {
    if (_hoursCtrl.text.trim().isEmpty || _descCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the required work log details.'),
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
          content: Text('Daily timesheet logged & submitted to manager!'),
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
        title: const Text('Log Daily Work', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
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
            // Task info badge
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
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
                    child: const Icon(Icons.work_outline_rounded, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Assigned Task', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
                        const SizedBox(height: 2),
                        Text(
                          widget.taskName,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Time & Progress Card
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
                  const Text('Hours Spent Today', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _hoursCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.timer_outlined, color: AppColors.primary),
                      hintText: 'e.g. 4.5',
                      suffixText: 'Hours',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Task Completion Progress', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      Text('${(_progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _progress,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.border,
                    onChanged: (val) => setState(() => _progress = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Deliverables / Accomplishment
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
                  const Text('What did you accomplish today?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Describe today\'s deliverables, modules worked on, or blockers faced...',
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
                    : const Text('Submit Timesheet Entry', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
