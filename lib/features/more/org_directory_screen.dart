import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/network/api_endpoints.dart';

class OrgDirectoryScreen extends StatefulWidget {
  const OrgDirectoryScreen({super.key});

  @override
  State<OrgDirectoryScreen> createState() => _OrgDirectoryScreenState();
}

class _OrgDirectoryScreenState extends State<OrgDirectoryScreen> {
  String _selectedDept = 'All';
  final _searchCtrl = TextEditingController();
  bool _isLoading = true;
  List<Map<String, String>> _employees = [];

  @override
  void initState() {
    super.initState();
    _fetchDirectory();
  }

  Future<void> _fetchDirectory() async {
    setState(() => _isLoading = true);
    final token = AuthService().token;
    try {
      final res = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/employees'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 6));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true && body['employees'] is List) {
          final list = (body['employees'] as List).map<Map<String, String>>((e) {
            final name = e['name']?.toString() ?? 'Team Member';
            final role = e['role']?.toString() ?? 'Engineer';
            final dept = e['dept']?.toString() ?? 'Engineering';
            final email = e['email']?.toString() ?? '';
            final phone = e['phone']?.toString() ?? '';
            final avatar = e['avatar']?.toString() ?? name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
            return {
              'name': name,
              'role': role,
              'dept': dept,
              'email': email,
              'phone': phone,
              'initials': avatar,
              'color': '0xFF0066D6',
            };
          }).toList();

          if (mounted) {
            setState(() {
              _employees = list;
              _isLoading = false;
            });
            return;
          }
        }
      }
    } catch (_) {}

    // Fallback to active current user
    if (mounted) {
      final currentUser = AuthService().currentUser;
      setState(() {
        if (currentUser != null) {
          _employees = [
            {
              'name': currentUser.fullName,
              'role': currentUser.designation,
              'dept': currentUser.department,
              'email': currentUser.email,
              'phone': currentUser.phone,
              'initials': currentUser.avatarInitials,
              'color': '0xFF0066D6',
            }
          ];
        } else {
          _employees = [];
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _employees.where((emp) {
      final matchesDept = _selectedDept == 'All' || emp['dept'] == _selectedDept;
      final query = _searchCtrl.text.toLowerCase().trim();
      final matchesQuery = query.isEmpty ||
          emp['name']!.toLowerCase().contains(query) ||
          emp['role']!.toLowerCase().contains(query) ||
          emp['dept']!.toLowerCase().contains(query);
      return matchesDept && matchesQuery;
    }).toList();

    const depts = ['All', 'Management', 'Development', 'Design', 'Human Resources', 'Quality Assurance'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Company Directory', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  onChanged: (val) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by name, role or department...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: depts.map((d) {
                      final isSelected = _selectedDept == d;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(d),
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 12,
                          ),
                          backgroundColor: AppColors.borderLight,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          side: BorderSide.none,
                          onSelected: (val) => setState(() => _selectedDept = d),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Employee List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'No team members found',
                          style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                        ),
                      )
                    : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final emp = filtered[index];
                      final col = Color(int.parse(emp['color']!));
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: col.withOpacity(0.12),
                                border: Border.all(color: col, width: 1.5),
                              ),
                              child: Center(
                                child: Text(
                                  emp['initials']!,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: col,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    emp['name']!,
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    emp['role']!,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.mail_outline_rounded, size: 13, color: AppColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Text(
                                        emp['email']!,
                                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.borderLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                emp['dept']!,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
