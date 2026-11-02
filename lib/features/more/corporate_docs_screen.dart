import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CorporateDocsScreen extends StatelessWidget {
  const CorporateDocsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> docs = [
      {
        'title': 'Employment Offer Letter',
        'type': 'PDF',
        'date': 'Issued: 15 Jun 2024',
        'size': '420 KB',
        'icon': Icons.description_outlined,
        'category': 'Contracts',
      },
      {
        'title': 'Annual Appraisal & Increment Letter',
        'type': 'PDF',
        'date': 'Issued: 01 Apr 2026',
        'size': '280 KB',
        'icon': Icons.trending_up_rounded,
        'category': 'Compensation',
      },
      {
        'title': 'Aayup Employee Handbook & Code of Conduct',
        'type': 'PDF',
        'date': 'Updated: 01 Jan 2026',
        'size': '1.8 MB',
        'icon': Icons.menu_book_rounded,
        'category': 'Company Policy',
      },
      {
        'title': 'Group Health Insurance E-Card',
        'type': 'PDF',
        'date': 'Valid till: 31 Mar 2027',
        'size': '650 KB',
        'icon': Icons.health_and_safety_outlined,
        'category': 'Benefits',
      },
      {
        'title': 'Non-Disclosure Agreement (NDA)',
        'type': 'PDF',
        'date': 'Signed: 16 Jun 2024',
        'size': '310 KB',
        'icon': Icons.verified_user_outlined,
        'category': 'Legal',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Corporate Documents', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: docs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = docs[index];
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item['icon'] as IconData, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.borderLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item['category'] as String,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item['date']} • ${item['size']}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.file_download_outlined, color: AppColors.primary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Downloading "${item['title']}"...'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
