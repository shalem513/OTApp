
class Surgery {
  final String id;
  final String otId;
  String? patientName;
  String? procedure;
  String? surgeonId;
  List<String> staffIds;

  Surgery({
    required this.id,
    required this.otId,
    this.patientName,
    this.procedure,
    this.surgeonId,
    this.staffIds = const [],
  });

  factory Surgery.fromJson(Map<String, dynamic> json) {
    return Surgery(
      id: json['id'],
      otId: json['otId'],
      patientName: json['patientName'],
      procedure: json['procedure'],
      surgeonId: json['surgeonId'],
      staffIds: List<String>.from(json['staffIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'otId': otId,
      'patientName': patientName,
      'procedure': procedure,
      'surgeonId': surgeonId,
      'staffIds': staffIds,
    };
  }
}
