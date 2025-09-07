class Surgeon {
  final String id;
  final String name;

  Surgeon({required this.id, required this.name});

  factory Surgeon.fromJson(Map<String, dynamic> json) {
    return Surgeon(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
