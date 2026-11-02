import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _isFresher = widget.isFresher;
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
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            if (!allowDownload)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: const Color(0xFFFFFBEB),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined, size: 18, color: Color(0xFFD97706)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'View-Only Document: Uploaded during onboarding. Download is restricted for enterprise identity verification.',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF92400E)),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: AppColors.primaryLight,
                child: const Row(
                  children: [
                    Icon(Icons.verified_outlined, size: 18, color: AppColors.primary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Official Issued Document: You are authorized to download, store, or share this document.',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            allowDownload ? Icons.file_download_done_rounded : Icons.lock_outline_rounded,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          fileName,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Category: $docCategory',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusBg(status),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _getStatusDot(status),
                              const SizedBox(width: 6),
                              Text(
                                'Status: $status',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: _getStatusTextColor(status),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Digital Verification Hash:\nSHA256: 4f8b9e1c3a7d2e5b8c0a9f1e3d5b7a9c',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: AppColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: allowDownload
                  ? SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.download_rounded, color: Colors.white),
                        label: const Text(
                          'Download Official PDF',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Downloading "$fileName"... saved to Downloads.'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.visibility_rounded, color: AppColors.textSecondary),
                        label: const Text(
                          'Download Disabled (Candidate Onboarding Record)',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textSecondary),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: null,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusBg(String status) {
    switch (status.toUpperCase()) {
      case 'VERIFIED':
      case 'APPROVED':
        return const Color(0xFFECFDF5);
      case 'UNDER REVIEW':
      case 'PENDING':
        return const Color(0xFFFFFBEB);
      case 'FLAGGED':
      case 'REJECTED':
        return const Color(0xFFFEF2F2);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toUpperCase()) {
      case 'VERIFIED':
      case 'APPROVED':
        return const Color(0xFF059669);
      case 'UNDER REVIEW':
      case 'PENDING':
        return const Color(0xFFD97706);
      case 'FLAGGED':
      case 'REJECTED':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF475569);
    }
  }

  Widget _getStatusDot(String status) {
    Color c = _getStatusTextColor(status);
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(shape: BoxShape.circle, color: c),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Document Vault', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.textPrimary)),
            Text('Official Identity & Corporate Records', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          tabs: const [
            Tab(text: 'My Documents'),
            Tab(text: 'Company Documents'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyDocumentsTab(),
          _buildCompanyDocumentsTab(),
        ],
      ),
    );
  }

  Widget _buildMyDocumentsTab() {
    final List<Map<String, dynamic>> fresherDocs = [
      {
        'title': 'Aadhaar Card (Front & Back)',
        'category': 'Identity Proof',
        'status': 'VERIFIED',
        'uploadDate': 'Uploaded on 02 Nov 2026',
        'fileName': 'aadhaar_card_verified.pdf',
        'icon': Icons.badge_outlined,
      },
      {
        'title': 'PAN Card',
        'category': 'Tax & Identity',
        'status': 'VERIFIED',
        'uploadDate': 'Uploaded on 02 Nov 2026',
        'fileName': 'pan_card_official.pdf',
        'icon': Icons.credit_card_outlined,
      },
      {
        'title': 'Degree / Graduation Marksheet',
        'category': 'Education Verification',
        'status': 'VERIFIED',
        'uploadDate': 'Uploaded on 02 Nov 2026',
        'fileName': 'btech_final_transcript.pdf',
        'icon': Icons.school_outlined,
      },
      {
        'title': '10th & 12th Standard Marksheets',
        'category': 'Education Verification',
        'status': 'VERIFIED',
        'uploadDate': 'Uploaded on 02 Nov 2026',
        'fileName': 'higher_secondary_certs.pdf',
        'icon': Icons.menu_book_outlined,
      },
      {
        'title': 'Cancelled Cheque / Passbook',
        'category': 'Payroll & Banking',
        'status': 'VERIFIED',
        'uploadDate': 'Uploaded on 02 Nov 2026',
        'fileName': 'bank_cancelled_cheque.pdf',
        'icon': Icons.account_balance_outlined,
      },
      {
        'title': 'Academic Project / Internship Portfolio',
        'category': 'Fresher Evaluation Proof',
        'status': 'APPROVED',
        'uploadDate': 'Uploaded on 02 Nov 2026',
        'fileName': 'capstone_project_portfolio.pdf',
        'icon': Icons.folder_shared_outlined,
      },
    ];

    final List<Map<String, dynamic>> experiencedDocs = [
      {
        'title': 'Aadhaar Card (Front & Back)',
        'category': 'Identity Proof',
        'status': 'VERIFIED',
        'uploadDate': 'Uploaded on 02 Nov 2026',
        'fileName': 'aadhaar_card_verified.pdf',
        'icon': Icons.badge_outlined,
      },
      {
        'title': 'PAN Card',
        'category': 'Tax & Identity',
        'status': 'VERIFIED',
        'uploadDate': 'Uploaded on 02 Nov 2026',
        'fileName': 'pan_card_official.pdf',
        'icon': Icons.credit_card_outlined,
      },
      {
        'title': 'Cancelled Cheque / Passbook',
        'category': 'Payroll & Banking',
        'status': 'VERIFIED',
        'uploadDate': 'Uploaded on 02 Nov 2026',
        'fileName': 'bank_cancelled_cheque.pdf',
        'icon': Icons.account_balance_outlined,
      },
      {
        'title': 'Previous Company Relieving Letter',
        'category': 'Prior Experience Proof',
        'status': 'VERIFIED',
        'uploadDate': 'Uploaded on 02 Nov 2026',
        'fileName': 'relieving_letter_prev_corp.pdf',
        'icon': Icons.work_history_outlined,
      },
      {
        'title': 'Previous Experience Certificate',
        'category': 'Prior Experience Proof',
        'status': 'VERIFIED',
        'uploadDate': 'Uploaded on 02 Nov 2026',
        'fileName': 'experience_letter_signed.pdf',
        'icon': Icons.card_membership_outlined,
      },
      {
        'title': 'Last 3 Months Salary Slips',
        'category': 'Prior Salary Verification',
        'status': 'UNDER REVIEW',
        'uploadDate': 'Uploaded on 02 Nov 2026',
        'fileName': 'previous_slips_3months.pdf',
        'icon': Icons.receipt_long_outlined,
      },
    ];

    final activeDocs = _isFresher ? fresherDocs : experiencedDocs;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Onboarding Profile Mode',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                      ),
                      Text(
                        _isFresher ? 'Showing Fresher Document Checklist' : 'Showing Experienced Document Checklist',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _isFresher = true),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _isFresher ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Fresher',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _isFresher ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _isFresher = false),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: !_isFresher ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Experienced',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: !_isFresher ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
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
          ...activeDocs.map((doc) => _buildDocTile(
                title: doc['title'],
                category: doc['category'],
                status: doc['status'],
                uploadDate: doc['uploadDate'],
                fileName: doc['fileName'],
                icon: doc['icon'],
                allowDownload: false,
              )),
        ],
      ),
    );
  }

  Widget _buildCompanyDocumentsTab() {
    final List<Map<String, dynamic>> companyDocs = [
      {
        'title': 'Official Offer Letter',
        'category': 'Employment Offer',
        'status': 'ISSUED',
        'uploadDate': 'Issued on 01 Nov 2026',
        'fileName': 'AayupOnes_Offer_Letter_Signed.pdf',
        'icon': Icons.assignment_outlined,
      },
      {
        'title': 'October 2026 Payslip',
        'category': 'Monthly Salary Slip',
        'status': 'GENERATED',
        'uploadDate': 'Issued on 31 Oct 2026',
        'fileName': 'Payslip_Oct_2026.pdf',
        'icon': Icons.receipt_long_outlined,
      },
      {
        'title': 'September 2026 Payslip',
        'category': 'Monthly Salary Slip',
        'status': 'GENERATED',
        'uploadDate': 'Issued on 30 Sep 2026',
        'fileName': 'Payslip_Sep_2026.pdf',
        'icon': Icons.receipt_long_outlined,
      },
      {
        'title': 'Non-Disclosure Agreement (NDA)',
        'category': 'Legal & Security',
        'status': 'EXECUTED',
        'uploadDate': 'Signed on 02 Nov 2026',
        'fileName': 'AayupOnes_Corporate_NDA.pdf',
        'icon': Icons.gavel_outlined,
      },
      {
        'title': 'Corporate IT & Security Policy',
        'category': 'Compliance',
        'status': 'ACTIVE',
        'uploadDate': 'Updated 2026',
        'fileName': 'IT_Policy_Guidelines_v4.pdf',
        'icon': Icons.policy_outlined,
      },
      {
        'title': 'Employee Identity Certificate',
        'category': 'Service Certificate',
        'status': 'ISSUED',
        'uploadDate': 'Issued on 02 Nov 2026',
        'fileName': 'Emp_Bonafide_Certificate.pdf',
        'icon': Icons.verified_user_outlined,
      },
    ];

    return SingleChildScrollView(
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
          ...companyDocs.map((doc) => _buildDocTile(
                title: doc['title'],
                category: doc['category'],
                status: doc['status'],
                uploadDate: doc['uploadDate'],
                fileName: doc['fileName'],
                icon: doc['icon'],
                allowDownload: true,
              )),
        ],
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDocumentViewer(
          context: context,
          title: title,
          docCategory: category,
          status: status,
          allowDownload: allowDownload,
          uploadDate: uploadDate,
          fileName: fileName,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          category,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.textMuted),
                        ),
                        const SizedBox(width: 6),
                        _getStatusDot(status),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: _getStatusTextColor(status),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (allowDownload)
                IconButton(
                  icon: const Icon(Icons.download_rounded, color: AppColors.primary, size: 22),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Downloading "$fileName"...'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.remove_red_eye_outlined, size: 14, color: AppColors.textSecondary),
                      SizedBox(width: 4),
                      Text('View', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
