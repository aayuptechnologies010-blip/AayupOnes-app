class UserModel {
  final String id;
  final String empId;
  String get employeeId => empId;
  final String fullName;
  String get name => fullName;
  final String email;
  final String phone;
  final String role;
  final String department;
  final String designation;
  final String avatarInitials;
  final String profilePic;
  final String status;
  final bool isManager;
  final String onboardingStatus;
  final double onboardingProgress;
  final String dob;

  UserModel({
    required this.id,
    required this.empId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.department,
    required this.designation,
    required this.avatarInitials,
    this.profilePic = '',
    required this.status,
    this.isManager = true,
    this.onboardingStatus = 'Not Started',
    this.onboardingProgress = 0.0,
    this.dob = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      empId: (json['empId'] ?? json['employeeId'])?.toString() ?? '',
      fullName: (json['fullName'] ?? json['name'])?.toString() ?? 'Team Member',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      role: json['role']?.toString() ?? 'Employee',
      department: json['department']?.toString() ?? 'Operations',
      designation: json['designation']?.toString() ?? 'Team Member',
      avatarInitials: json['avatarInitials']?.toString() ?? 'EM',
      profilePic: json['profilePic']?.toString() ?? '',
      status: json['status']?.toString() ?? 'ACTIVE',
      isManager: json['isManager'] as bool? ?? (json['role'] == 'manager' || json['role'] == 'admin' || json['role'] == 'hr'),
      onboardingStatus: json['onboardingStatus']?.toString() ?? 'Not Started',
      onboardingProgress: (json['onboardingProgress'] is num)
          ? (json['onboardingProgress'] as num).toDouble()
          : 0.0,
      dob: json['dob']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'empId': empId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'department': department,
      'designation': designation,
      'avatarInitials': avatarInitials,
      'profilePic': profilePic,
      'status': status,
      'isManager': isManager,
      'onboardingStatus': onboardingStatus,
      'onboardingProgress': onboardingProgress,
      'dob': dob,
    };
  }
}
