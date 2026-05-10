class UserModel {
  final String empId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String role;
  final String status;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;

  const UserModel({
    required this.empId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      empId: map['empId'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      phoneNumber: map['phone'] ?? '',
      role: map['role'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['created_at'] ?? '',
      createdBy: map['created_by'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      updatedBy: map['updated_by'] ?? '',
    );
  }

  factory UserModel.empty() {
    return const UserModel(
      empId: '',
      firstName: '',
      lastName: '',
      phoneNumber: '',
      role: '',
      status: '',
      createdAt: '',
      createdBy: '',
      updatedAt: '',
      updatedBy: '',
    );
  }

  bool get isEmpty => empId.isEmpty;
}
