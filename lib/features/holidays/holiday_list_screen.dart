import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/network/api_endpoints.dart';

class HolidayListScreen extends StatefulWidget {
  const HolidayListScreen({super.key});

  @override
  State<HolidayListScreen> createState() => _HolidayListScreenState();
}

class _HolidayListScreenState extends State<HolidayListScreen> {
  bool _isLoading = true;
  List<dynamic> _holidays = [];

  @override
  void initState() {
    super.initState();
    _fetchHolidays();
  }

  Future<void> _fetchHolidays() async {
    setState(() => _isLoading = true);
    final token = AuthService().token;
    try {
      final res = await http.get(
        Uri.parse(ApiEndpoints.holidays),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true && body['holidays'] is List) {
          if (mounted) {
            setState(() {
              _holidays = body['holidays'];
              _isLoading = false;
            });
            return;
          }
        }
      }
    } catch (_) {}

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Holiday Calendar 2026-27', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _fetchHolidays),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: Colors.white,
              onRefresh: _fetchHolidays,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppColors.heroCardGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.beach_access_rounded, color: Colors.white, size: 36),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Official Corporate Holidays', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                            SizedBox(height: 4),
                            Text('Aayup Technologies annual holiday roster for Lucknow & remote branches.', style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text('All Upcoming Holidays', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 12),
                if (_holidays.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                      child: Text('No upcoming holidays scheduled.', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    ),
                  )
                else
                  ..._holidays.map((h) {
                    final title = h['name']?.toString() ?? 'Official Holiday';
                    final date = h['date']?.toString() ?? '';
                    final type = h['type']?.toString() ?? 'Public Holiday';
                    final desc = h['description']?.toString() ?? '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.event_available_rounded, color: AppColors.primary, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                                const SizedBox(height: 3),
                                Text(date, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text(
                                  desc.isNotEmpty ? '$type • $desc' : type,
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
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
    );
  }
}
