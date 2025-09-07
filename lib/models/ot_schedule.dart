import 'package:flutter/material.dart';

class OT {
  final int number;
  final Color color;

  OT({required this.number, required this.color});
}

class Surgery {
  final String id;
  final String otId;
  final String? patientName;
  final String? procedure;
  final String? surgeonId;

  Surgery({
    required this.id,
    required this.otId,
    this.patientName,
    this.procedure,
    this.surgeonId,
  });

  Surgery copyWith({
    String? patientName,
    String? procedure,
    String? surgeonId,
  }) {
    return Surgery(
      id: id,
      otId: otId,
      patientName: patientName ?? this.patientName,
      procedure: procedure ?? this.procedure,
      surgeonId: surgeonId ?? this.surgeonId,
    );
  }

  factory Surgery.fromJson(Map<String, dynamic> json) => Surgery(
    id: json['id'],
    otId: json['otId'],
    patientName: json['patientName'],
    procedure: json['procedure'],
    surgeonId: json['surgeonId'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'otId': otId,
    'patientName': patientName,
    'procedure': procedure,
    'surgeonId': surgeonId,
  };
}
