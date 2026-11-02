import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/theme/app_colors.dart';
import '../dashboard/main_navigation_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  bool _isFresher = false;
  bool _sameAddress = true;

  // 1. Profile Picture Picker state
  XFile? _profileImage;
  final ImagePicker _imagePicker = ImagePicker();

  // 2. Address & Geolocation / Map autofill state
  bool _isFetchingLocation = false;
  final _currentAddressCtrl = TextEditingController(text: 'Flat 402, Royal Residency, Indira Nagar');
  final _currentCityCtrl = TextEditingController(text: 'Lucknow');
  final _currentStateCtrl = TextEditingController(text: 'Uttar Pradesh');
  final _currentPinCtrl = TextEditingController(text: '226016');
  final _currentDistrictCtrl = TextEditingController(text: 'Lucknow');
  String _fetchedCoordinates = '';

  final _permAddressCtrl = TextEditingController(text: 'House No 12, Main Bazar');
  final _permCityCtrl = TextEditingController(text: 'Varanasi');
  final _permStateCtrl = TextEditingController(text: 'Uttar Pradesh');
  final _permPinCtrl = TextEditingController(text: '221002');
  final _permDistrictCtrl = TextEditingController(text: 'Varanasi');

  // 3. Education List (Dynamic additions)
  final List<Map<String, String>> _educationList = [
    {
      'degree': 'B.Tech in Computer Science',
      'institute': 'AKTU University, Lucknow',
      'passingYear': '2021',
      'score': '82.4%',
      'marksheet': 'Degree_Certificate_RK.pdf',
    },
    {
      'degree': 'Senior Secondary (12th)',
      'institute': 'CBSE Board - Kendriya Vidyalaya',
      'passingYear': '2017',
      'score': '85.0%',
      'marksheet': '12th_Marksheet_RK.pdf',
    },
  ];

  // 4. Experience List (Dynamic additions)
  final List<Map<String, String>> _experienceList = [
    {
      'company': 'TechSolutions Pvt Ltd',
      'designation': 'Frontend Developer',
      'duration': '2 Years (2022 - 2024)',
      'salary': '₹ 4.8 LPA',
      'relievingDoc': 'Relieving_Letter_TechSolutions.pdf',
    },
  ];

  // 5. Document Uploads state with live file names
  final Map<String, String?> _uploadedDocs = {
    'Aadhaar Card (Front & Back)': 'Aadhaar_RahulKumar.pdf',
    'PAN Card': 'PAN_RahulKumar.jpg',
    'Highest Qualification Degree': 'BTech_Degree.pdf',
    'Cancelled Cheque / Bank Statement': null,
    'Previous Experience Letter': 'Exp_Letter_TechSolutions.pdf',
  };

  final List<String> _sections = [
    'Personal Info',
    'Address',
    'Education',
    'Experience',
    'Bank & Statutory',
    'Documents'
  ];

  double get _completionPercent {
    return ((_currentStep + 1) / _sections.length).clamp(0.0, 1.0);
  }

  void _nextStep() {
    if (_currentStep < _sections.length - 1) {
      setState(() => _currentStep++);
    } else {
      _showSubmissionSuccessModal();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  // Pick Profile Picture (Camera / Gallery)
  Future<void> _pickProfileImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(source: source, imageQuality: 85);
      if (picked != null) {
        setState(() => _profileImage = picked);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile photo updated successfully!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  // Simulated GPS / Map API autofill (ready for real Google Maps / OpenStreetMap Geocoding API)
  Future<void> _fetchCurrentLocationAndAutofill() async {
    setState(() => _isFetchingLocation = true);

    // Simulated API call delay to reverse geocode lat/lng into address fields
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;

    setState(() {
      _isFetchingLocation = false;
      _fetchedCoordinates = '26.8467° N, 80.9462° E (GPS Radius ±5m)';
      _currentAddressCtrl.text = 'Plot 45, Cyber Heights, Vibhuti Khand, Gomti Nagar';
      _currentCityCtrl.text = 'Lucknow';
      _currentDistrictCtrl.text = 'Lucknow';
      _currentStateCtrl.text = 'Uttar Pradesh';
      _currentPinCtrl.text = '226010';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📍 Location coordinates fetched! Address autofilled.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  // Pick Document File (PDF, JPG, PNG)
  Future<void> _pickDocumentFile(String docTitle) async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (files.isNotEmpty && files.first.name.isNotEmpty) {
        setState(() {
          _uploadedDocs[docTitle] = files.first.name;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Uploaded ${files.first.name} for $docTitle'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting file: $e')),
        );
      }
    }
  }

  // Add Education Modal
  void _showAddEducationModal() {
    final degreeCtrl = TextEditingController();
    final instituteCtrl = TextEditingController();
    final yearCtrl = TextEditingController();
    final scoreCtrl = TextEditingController();
    String? selectedFileName;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Add Qualification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 16),
              _buildInputLabel('Course / Degree (e.g. Diploma, B.Sc, MBA)'),
              TextField(controller: degreeCtrl, decoration: const InputDecoration(hintText: 'e.g. Master in Computer Science')),
              const SizedBox(height: 12),
              _buildInputLabel('Board / Institute Name'),
              TextField(controller: instituteCtrl, decoration: const InputDecoration(hintText: 'e.g. Lucknow University')),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel('Passing Year'),
                        TextField(controller: yearCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'e.g. 2023')),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel('Percentage / CGPA'),
                        TextField(controller: scoreCtrl, decoration: const InputDecoration(hintText: 'e.g. 8.5 CGPA')),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                icon: const Icon(Icons.upload_file_rounded),
                onPressed: () async {
                  final files = await FilePicker.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'jpg', 'png'],
                  );
                  if (files.isNotEmpty) {
                    setModalState(() {
                      selectedFileName = files.first.name;
                    });
                  }
                },
                label: Text(selectedFileName ?? 'Attach Certificate / Marksheet (PDF)'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (degreeCtrl.text.trim().isEmpty) return;
                    setState(() {
                      _educationList.add({
                        'degree': degreeCtrl.text.trim(),
                        'institute': instituteCtrl.text.trim().isEmpty ? 'Institution' : instituteCtrl.text.trim(),
                        'passingYear': yearCtrl.text.trim().isEmpty ? '2023' : yearCtrl.text.trim(),
                        'score': scoreCtrl.text.trim().isEmpty ? 'Completed' : scoreCtrl.text.trim(),
                        'marksheet': selectedFileName ?? 'Certificate_Attached.pdf',
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Save Education Record'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Add Experience Modal
  void _showAddExperienceModal() {
    final companyCtrl = TextEditingController();
    final roleCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    final ctcCtrl = TextEditingController();
    String? selectedDocName;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Add Work Experience', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 16),
              _buildInputLabel('Company / Employer Name'),
              TextField(controller: companyCtrl, decoration: const InputDecoration(hintText: 'e.g. Infosys Ltd')),
              const SizedBox(height: 12),
              _buildInputLabel('Designation / Role'),
              TextField(controller: roleCtrl, decoration: const InputDecoration(hintText: 'e.g. Junior Software Engineer')),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel('Duration (Years/Months)'),
                        TextField(controller: durationCtrl, decoration: const InputDecoration(hintText: 'e.g. 1.5 Years')),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel('Last Drawn CTC'),
                        TextField(controller: ctcCtrl, decoration: const InputDecoration(hintText: 'e.g. ₹ 5.5 LPA')),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                icon: const Icon(Icons.upload_file_rounded),
                onPressed: () async {
                  final files = await FilePicker.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'jpg', 'png'],
                  );
                  if (files.isNotEmpty) {
                    setModalState(() {
                      selectedDocName = files.first.name;
                    });
                  }
                },
                label: Text(selectedDocName ?? 'Attach Relieving / Exp Letter'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (companyCtrl.text.trim().isEmpty) return;
                    setState(() {
                      _experienceList.add({
                        'company': companyCtrl.text.trim(),
                        'designation': roleCtrl.text.trim().isEmpty ? 'Associate' : roleCtrl.text.trim(),
                        'duration': durationCtrl.text.trim().isEmpty ? '1 Year' : durationCtrl.text.trim(),
                        'salary': ctcCtrl.text.trim().isEmpty ? 'Confidential' : ctcCtrl.text.trim(),
                        'relievingDoc': selectedDocName ?? 'Exp_Letter.pdf',
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Save Experience Record'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubmissionSuccessModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 52,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Profile Submitted!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your profile details and uploaded verification documents have been sent to Aayup Technologies HR team. Status: Under Review.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainNavigationShell(),
                    ),
                  );
                },
                child: const Text('Go to Dashboard (Preview)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final percentVal = (_completionPercent * 100).toInt();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: _prevStep,
        ),
        title: const Text(
          'Employee Onboarding',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Step ${_currentStep + 1}/${_sections.length}',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Profile Completion Header Card
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Profile Completion',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warningLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Action Required',
                            style: TextStyle(
                              color: AppColors.warning,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$percentVal%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _completionPercent,
                    minHeight: 8,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_sections.length, (index) {
                      final isCurrent = index == _currentStep;
                      final isDone = index < _currentStep;

                      return GestureDetector(
                        onTap: () => setState(() => _currentStep = index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? AppColors.primary
                                : (isDone ? AppColors.successLight : AppColors.borderLight),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              if (isDone) ...[
                                const Icon(Icons.check, size: 14, color: AppColors.success),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                _sections[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                                  color: isCurrent
                                      ? Colors.white
                                      : (isDone ? AppColors.success : AppColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.border),

          // Form Steps Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildStepContent(),
            ),
          ),

          // Bottom Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                if (_currentStep > 0) ...[
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      onPressed: _prevStep,
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _nextStep,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentStep == _sections.length - 1
                              ? 'Submit for HR Verification'
                              : 'Save & Continue',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildAddressStep();
      case 2:
        return _buildEducationStep();
      case 3:
        return _buildExperienceStep();
      case 4:
        return _buildBankDetailsStep();
      case 5:
        return _buildDocumentsStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // Step 1: Personal Info with Working Photo Picker
  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => _showPhotoSourceBottomSheet(),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryLight,
                    border: Border.all(color: AppColors.primary, width: 2.5),
                  ),
                  child: ClipOval(
                    child: _profileImage != null
                        ? (kIsWeb
                            ? Image.network(_profileImage!.path, fit: BoxFit.cover)
                            : Image.file(File(_profileImage!.path), fit: BoxFit.cover))
                        : const Icon(Icons.person, size: 60, color: AppColors.primary),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showPhotoSourceBottomSheet(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            onPressed: () => _showPhotoSourceBottomSheet(),
            icon: const Icon(Icons.photo_library_outlined, size: 16),
            label: const Text('Change Profile Photo', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 20),
        _buildTextField('Full Name', 'Rahul Kumar'),
        const SizedBox(height: 16),
        _buildTextField('Father / Guardian Name', 'Mr. Suresh Kumar'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Date of Birth', '12/04/1998')),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField('Gender', 'Male')),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Blood Group', 'O+')),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField('Marital Status', 'Single')),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('Personal Email', 'rahul.kumar@gmail.com'),
        const SizedBox(height: 16),
        _buildTextField('Mobile Number', '+91 98765 43210'),
      ],
    );
  }

  void _showPhotoSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
              title: const Text('Take Photo from Camera', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _pickProfileImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
              title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _pickProfileImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Step 2: Address with Geolocation / Map Fetch & Autofill Flow
  Widget _buildAddressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Current Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            // Map GPS Autofill Action Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                foregroundColor: AppColors.primary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _isFetchingLocation ? null : _fetchCurrentLocationAndAutofill,
              icon: _isFetchingLocation
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                  : const Icon(Icons.my_location_rounded, size: 16),
              label: Text(
                _isFetchingLocation ? 'Locating...' : 'Fetch via Map / GPS',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        if (_fetchedCoordinates.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: AppColors.success, size: 16),
                const SizedBox(width: 6),
                Text('GPS: $_fetchedCoordinates', style: const TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
        const SizedBox(height: 14),
        _buildControllerField('Address Line (House / Flat / Street)', _currentAddressCtrl),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _buildControllerField('City', _currentCityCtrl)),
            const SizedBox(width: 12),
            Expanded(child: _buildControllerField('District', _currentDistrictCtrl)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _buildControllerField('State', _currentStateCtrl)),
            const SizedBox(width: 12),
            Expanded(child: _buildControllerField('PIN Code', _currentPinCtrl)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Switch(
              value: _sameAddress,
              activeThumbColor: AppColors.primary,
              onChanged: (val) => setState(() => _sameAddress = val),
            ),
            const SizedBox(width: 8),
            const Text(
              'Permanent Address same as Current',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
        if (!_sameAddress) ...[
          const SizedBox(height: 20),
          const Text(
            'Permanent Address',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 14),
          _buildControllerField('Address Line', _permAddressCtrl),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildControllerField('City', _permCityCtrl)),
              const SizedBox(width: 12),
              Expanded(child: _buildControllerField('District', _permDistrictCtrl)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildControllerField('State', _permStateCtrl)),
              const SizedBox(width: 12),
              Expanded(child: _buildControllerField('PIN Code', _permPinCtrl)),
            ],
          ),
        ],
      ],
    );
  }

  // Step 3: Education with Working "+ Add Education"
  Widget _buildEducationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Academic History',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                foregroundColor: AppColors.primary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _showAddEducationModal,
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: const Text('+ Add Education', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ..._educationList.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.school_outlined, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['degree']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text('${item['institute']} • Passing: ${item['passingYear']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('Score: ${item['score']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          const SizedBox(width: 8),
                          Text('• ${item['marksheet']}', style: const TextStyle(fontSize: 11, color: AppColors.success)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.danger),
                  onPressed: () {
                    setState(() => _educationList.removeAt(index));
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Step 4: Experience with Working "+ Add Company"
  Widget _buildExperienceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you a Fresher?',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Toggle on if this is your first corporate job',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
              Switch(
                value: _isFresher,
                activeThumbColor: AppColors.primary,
                onChanged: (val) => setState(() => _isFresher = val),
              ),
            ],
          ),
        ),
        if (!_isFresher) ...[
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Previous Experience',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _showAddExperienceModal,
                icon: const Icon(Icons.add_business_outlined, size: 16),
                label: const Text('+ Add Company', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._experienceList.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.business_center_outlined, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['company']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text('${item['designation']} • ${item['duration']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text('Last CTC: ${item['salary']} • Relieving Letter Attached', style: const TextStyle(fontSize: 11, color: AppColors.success)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.danger),
                    onPressed: () {
                      setState(() => _experienceList.removeAt(index));
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  // Step 5: Bank Details
  Widget _buildBankDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.infoLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.lock_clock, size: 20, color: AppColors.info),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Bank & Statutory details are encrypted and only accessible by HR/Payroll.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _buildTextField('Account Holder Name', 'Rahul Kumar'),
        const SizedBox(height: 14),
        _buildTextField('Bank Name', 'HDFC Bank'),
        const SizedBox(height: 14),
        _buildTextField('Account Number', '50100234981290'),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _buildTextField('IFSC Code', 'HDFC0001234')),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField('PAN Card Number', 'ABCDE1234F')),
          ],
        ),
        const SizedBox(height: 14),
        _buildTextField('UAN Number (Optional)', '100918239012'),
      ],
    );
  }

  // Step 6: Documents with Live File Picker
  Widget _buildDocumentsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mandatory Verification Proofs',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tap Upload/Replace to pick documents (PDF or Image) from your device.',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        ..._uploadedDocs.keys.map((title) {
          final fileName = _uploadedDocs[title];
          final isUploaded = fileName != null && fileName.isNotEmpty;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isUploaded ? AppColors.success.withValues(alpha: 0.3) : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isUploaded ? AppColors.successLight : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isUploaded ? Icons.file_present_rounded : Icons.cloud_upload_outlined,
                    color: isUploaded ? AppColors.success : AppColors.textSecondary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        isUploaded ? 'Attached: $fileName' : 'Tap to select document',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isUploaded ? FontWeight.w600 : FontWeight.w400,
                          color: isUploaded ? AppColors.success : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _pickDocumentFile(title),
                  child: Text(
                    isUploaded ? 'Replace' : 'Upload',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildControllerField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
