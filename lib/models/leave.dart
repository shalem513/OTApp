class Leave {
  final String id;
  final String staffId;
  final DateTime startDate;
  final DateTime endDate;

  Leave({required this.id, required this.staffId, required this.startDate, required this.endDate});

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      id: json['id'],
      staffId: json['staffId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staffId': staffId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
