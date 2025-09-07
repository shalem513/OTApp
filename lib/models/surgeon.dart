class Surgeon {
  final String id;
  final String name;
  final String department;

  Surgeon({required this.id, required this.name, required this.department});

  factory Surgeon.fromJson(Map<String, dynamic> json) {
    return Surgeon(
      id: json['id'],
      name: json['name'],
      department: json['department'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'department': department};
  }
}
