class UserModel {
  final String empeId;
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
    required this.empeId,
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
      empeId: map['empeId'] ?? '',
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

  bool get isEmpty => empeId.isEmpty;
}
