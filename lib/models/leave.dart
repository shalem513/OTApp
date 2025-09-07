class Leave {
  final String id;
  final String staffId;
  final DateTime date;

  Leave({required this.id, required this.staffId, required this.date});

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      id: json['id'],
      staffId: json['staffId'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staffId': staffId,
      'date': date.toIso8601String(),
    };
  }
}
