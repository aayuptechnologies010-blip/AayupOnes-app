import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class OrgDirectoryScreen extends StatefulWidget {
  const OrgDirectoryScreen({super.key});

  @override
  State<OrgDirectoryScreen> createState() => _OrgDirectoryScreenState();
}

class _OrgDirectoryScreenState extends State<OrgDirectoryScreen> {
  String _selectedDept = 'All';
  final _searchCtrl = TextEditingController();

  final List<Map<String, String>> _employees = [
    {
      'name': 'Aayush Shrivastava',
      'role': 'Founder & CEO',
      'dept': 'Management',
      'email': 'aayush@aayup.com',
      'phone': '+91 98765 43210',
      'initials': 'AS',
      'color': '0xFF0066D6',
    },
    {
      'name': 'Pooja Verma',
      'role': 'HR & Operations Lead',
      'dept': 'Human Resources',
      'email': 'hr@aayup.com',
      'phone': '+91 98765 12345',
      'initials': 'PV',
      'color': '0xFF10B981',
    },
    {
      'name': 'Rahul Kumar',
      'role': 'React & Mobile Developer',
      'dept': 'Development',
      'email': 'rahul.k@aayup.com',
      'phone': '+91 91234 56780',
      'initials': 'RK',
      'color': '0xFF4F46E5',
    },
    {
      'name': 'Vikram Singh',
      'role': 'Senior Backend Engineer',
      'dept': 'Development',
      'email': 'vikram.s@aayup.com',
      'phone': '+91 98321 65498',
      'initials': 'VS',
      'color': '0xFF0EA5E9',
    },
    {
      'name': 'Sneha Tiwari',
      'role': 'UI/UX Product Designer',
      'dept': 'Design',
      'email': 'sneha.t@aayup.com',
      'phone': '+91 95432 10987',
      'initials': 'ST',
      'color': '0xFFF59E0B',
    },
    {
      'name': 'Amit Patel',
      'role': 'QA & Automation Engineer',
      'dept': 'Quality Assurance',
      'email': 'amit.p@aayup.com',
      'phone': '+91 97890 23456',
      'initials': 'AP',
      'color': '0xFFEC4899',
    },
  ];

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
            child: filtered.isEmpty
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
