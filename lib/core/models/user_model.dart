class UserModel {
  final String id;
  final String empId;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String department;
  final String designation;
  final String avatarInitials;
  final String status;
  final bool isManager;

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
    required this.status,
    this.isManager = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? 'emp_0024',
      empId: json['empId'] as String? ?? 'AAYUP-DEV-0024',
      fullName: json['fullName'] as String? ?? 'Rahul Kumar',
      email: json['email'] as String? ?? 'rahul.k@aayup.com',
      phone: json['phone'] as String? ?? '+91 91234 56780',
      role: json['role'] as String? ?? 'React Developer',
      department: json['department'] as String? ?? 'Development',
      designation: json['designation'] as String? ?? 'Software Engineer L2',
      avatarInitials: json['avatarInitials'] as String? ?? 'RK',
      status: json['status'] as String? ?? 'Active',
      isManager: json['isManager'] as bool? ?? true,
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
      'status': status,
      'isManager': isManager,
    };
  }
}
