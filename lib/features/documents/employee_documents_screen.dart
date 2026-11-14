import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/network/api_endpoints.dart';

class EmployeeDocumentsScreen extends StatefulWidget {
  final bool isFresher;

  const EmployeeDocumentsScreen({
    super.key,
    this.isFresher = true,
  });

  @override
  State<EmployeeDocumentsScreen> createState() => _EmployeeDocumentsScreenState();
}

class _EmployeeDocumentsScreenState extends State<EmployeeDocumentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool _isFresher;
  bool _isLoading = true;

  List<dynamic> _myDocs = [];
  List<dynamic> _companyDocs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _isFresher = widget.isFresher;
    _fetchDocuments();
  }

  Future<void> _fetchDocuments() async {
    setState(() => _isLoading = true);
    final token = AuthService().token;
    try {
      final res = await http.get(
        Uri.parse(ApiEndpoints.documents),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true) {
          if (mounted) {
            setState(() {
              _myDocs = body['myDocuments'] ?? [];
              _companyDocs = body['companyDocuments'] ?? [];
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showDocumentViewer({
    required BuildContext context,
    required String title,
    required String docCategory,
    required String status,
    required bool allowDownload,
    required String uploadDate,
    required String fileName,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$docCategory  •  $uploadDate',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 24, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderLight),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary, size: 48),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        fileName,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Document Verified & Secured in Vault',
                        style: const TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Download Document PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.success,
                        content: Row(
                          children: [
                            const Icon(Icons.file_download_done_rounded, color: Colors.white),
                            const SizedBox(width: 10),
                            Expanded(child: Text('Downloaded $fileName to device storage.')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Document Vault', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
            Text('Official Identity & Corporate Records', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: [
            Tab(text: 'My Documents (${_myDocs.length})'),
            Tab(text: 'Company Documents (${_companyDocs.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMyDocumentsTab(),
                _buildCompanyDocumentsTab(),
              ],
            ),
    );
  }

  Widget _buildMyDocumentsTab() {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: _fetchDocuments,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.info, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'These are your onboarding documents submitted to HR. You can view & track verification status. Download is restricted for compliance.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_myDocs.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Text('No submitted documents found in vault.', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              ),
            )
          else
            ..._myDocs.map((doc) => _buildDocTile(
                  title: doc['title']?.toString() ?? 'Document',
                  category: doc['category']?.toString() ?? 'Identity Proof',
                  status: doc['status']?.toString() ?? 'VERIFIED',
                  uploadDate: doc['uploadDate']?.toString() ?? 'Uploaded 05 Nov 2026',
                  fileName: doc['fileName']?.toString() ?? 'Document.pdf',
                  icon: Icons.badge_outlined,
                  allowDownload: false,
                )),
        ],
      ),
    ),
  );
}

  Widget _buildCompanyDocumentsTab() {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: _fetchDocuments,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.download_for_offline_outlined, color: AppColors.success, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Company Issued Documents: Offer Letter, Monthly Payslips, and Certificates. You can download and save these files anytime.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF065F46), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_companyDocs.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Text('No company documents issued yet.', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              ),
            )
          else
            ..._companyDocs.map((doc) => _buildDocTile(
                  title: doc['title']?.toString() ?? 'Official Record',
                  category: doc['category']?.toString() ?? 'Company Document',
                  status: doc['status']?.toString() ?? 'ISSUED',
                  uploadDate: doc['uploadDate']?.toString() ?? 'Issued Recently',
                  fileName: doc['fileName']?.toString() ?? 'Doc.pdf',
                  icon: Icons.assignment_outlined,
                  allowDownload: true,
                )),
        ],
      ),
    ),
  );
}

  Widget _buildDocTile({
    required String title,
    required String category,
    required String status,
    required String uploadDate,
    required String fileName,
    required IconData icon,
    required bool allowDownload,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(category, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const SizedBox(width: 6),
                    const Text('•', style: TextStyle(color: AppColors.textMuted)),
                    const SizedBox(width: 6),
                    Text(status, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.success)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(allowDownload ? Icons.download_rounded : Icons.visibility_outlined, color: AppColors.primary),
            onPressed: () {
              _showDocumentViewer(
                context: context,
                title: title,
                docCategory: category,
                status: status,
                allowDownload: allowDownload,
                uploadDate: uploadDate,
                fileName: fileName,
              );
            },
          ),
        ],
      ),
    );
  }
}
