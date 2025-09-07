
enum StaffRole {
  Nurse,
  Assistant,
  Technician,
}

class Staff {
  final String id;
  final String name;
  final StaffRole role;
  final String department;

  Staff({required this.id, required this.name, required this.role, required this.department});

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['name'],
      role: StaffRole.values.firstWhere(
        (e) => e.toString() == json['role'],
        orElse: () => StaffRole.Nurse, // Default value
      ),
      department: json['department'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role.toString(),
      'department': department,
    };
  }
}
