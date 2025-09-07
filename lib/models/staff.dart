enum StaffRole { Nurse, OT_Technician, Anesthesian }

class Staff {
  final String id;
  final String name;
  final StaffRole role;

  Staff({required this.id, required this.name, required this.role});

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['name'],
      role: StaffRole.values.firstWhere(
        (e) => e.toString() == json['role'],
        orElse: () => StaffRole.Nurse, // Default value
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'role': role.toString()};
  }
}
