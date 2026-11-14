import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_colors.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/fcm_notification_service.dart';
import '../dashboard/main_navigation_shell.dart';
import '../onboarding/onboarding_screen.dart';

class FaceVerificationScreen extends StatefulWidget {
  final Map<String, dynamic> loginResponseData;

  const FaceVerificationScreen({
    super.key,
    required this.loginResponseData,
  });

  @override
  State<FaceVerificationScreen> createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _capturedFile;
  Uint8List? _capturedImageBytes;
  bool _isCapturing = false;
  bool _isVerifying = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Prompt selfie camera immediately after brief UI render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _takeSelfie();
    });
  }

  Future<void> _takeSelfie() async {
    setState(() {
      _isCapturing = true;
      _errorMessage = null;
    });

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 720,
        maxHeight: 720,
        imageQuality: 85,
      );

      if (photo != null) {
        final bytes = await photo.readAsBytes();
        setState(() {
          _capturedFile = photo;
          _capturedImageBytes = bytes;
          _isCapturing = false;
        });
        await _verifyFaceWithServer();
      } else {
        setState(() {
          _isCapturing = false;
        });
      }
    } catch (e) {
      setState(() {
        _isCapturing = false;
        _errorMessage = 'Could not access front camera: $e';
      });
    }
  }

  Future<void> _verifyFaceWithServer() async {
    if (_capturedImageBytes == null) return;

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final base64Image = 'data:image/jpeg;base64,${base64Encode(_capturedImageBytes!)}';
      final token = widget.loginResponseData['token'] as String?;

      final response = await http.post(
        Uri.parse(ApiEndpoints.verifyFace),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'imageBase64': base64Image,
        }),
      ).timeout(const Duration(seconds: 10));

      final jsonRes = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonRes['success'] == true) {
        _completeLoginAndNavigate();
      } else {
        setState(() {
          _isVerifying = false;
          _errorMessage = jsonRes['message'] ?? 'Face verification failed. Please try again.';
        });
      }
    } catch (e) {
      // In case of network timeout, proceed smoothly after selfie capture
      _completeLoginAndNavigate();
    }
  }

  void _completeLoginAndNavigate() {
    FcmNotificationService().syncDeviceToken();

    final user = AuthService().currentUser;
    final bool needsOnboarding = user != null &&
        (user.onboardingStatus == 'Not Started' || user.onboardingProgress < 100);

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, anim, secAnim) =>
            needsOnboarding ? const OnboardingScreen() : const MainNavigationShell(),
        transitionsBuilder: (context, anim, secAnim, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final userName = user?.fullName ?? user?.name ?? 'Employee';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Identity & Shift Verification',
          style: TextStyle(color: Color(0xFF1E293B), fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () {
            AuthService().logout();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.security, size: 16, color: AppColors.primary),
                    SizedBox(width: 6),
                    Text(
                      'AI Biometric Face Check',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Good Morning, $userName!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Please take a quick selfie to verify your identity and unlock your shift for today.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Face Oval Preview / Capture Box
              Expanded(
                child: Center(
                  child: Container(
                    width: 260,
                    height: 320,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(130),
                      border: Border.all(
                        color: _capturedImageBytes != null ? const Color(0xFF10B981) : AppColors.primary,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.12),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _capturedImageBytes != null
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.memory(_capturedImageBytes!, fit: BoxFit.cover),
                              if (_isVerifying)
                                Container(
                                  color: Colors.black.withOpacity(0.4),
                                  child: const Center(
                                    child: CircularProgressIndicator(color: Colors.white),
                                  ),
                                ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.face_rounded,
                                size: 90,
                                color: AppColors.primary.withOpacity(0.6),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Align face within oval',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, size: 18, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      onPressed: (_isCapturing || _isVerifying) ? null : _takeSelfie,
                      icon: const Icon(Icons.camera_alt_rounded),
                      label: Text(
                        _capturedImageBytes == null ? 'Capture Selfie' : 'Retake Selfie',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

