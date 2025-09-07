import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ot_roster/models/surgery.dart';
import 'package:ot_roster/providers/app_state.dart';
import 'package:ot_roster/models/surgeon.dart';

class SurgerySchedulingCard extends StatefulWidget {
  const SurgerySchedulingCard({super.key});

  @override
  State<SurgerySchedulingCard> createState() => _SurgerySchedulingCardState();
}

class _SurgerySchedulingCardState extends State<SurgerySchedulingCard> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Schedule Surgeries', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...appState.selectedOts.map((ot) {
              final surgery = appState.surgeries.firstWhere(
                    (s) => s.otId == ot,
                orElse: () =>
                    Surgery(id: '', otId: ot, patientName: null, procedure: null, surgeonId: null),
              );
              return _buildSurgeryForm(context, ot, surgery);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSurgeryForm(BuildContext context, String ot, Surgery surgery) {
    final appState = Provider.of<AppState>(context, listen: false);
    final patientNameController = TextEditingController(text: surgery.patientName);
    final procedureController = TextEditingController(text: surgery.procedure);
    Surgeon? selectedSurgeon = surgery.surgeonId != null
        ? appState.surgeons.firstWhere((s) => s.id == surgery.surgeonId)
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ot, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextFormField(
            controller: patientNameController,
            decoration: const InputDecoration(
              labelText: 'Patient Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              final newSurgery = Surgery(
                  id: surgery.id,
                  otId: surgery.otId,
                  patientName: value,
                  procedure: surgery.procedure,
                  surgeonId: surgery.surgeonId);
              appState.updateSurgery(newSurgery);
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: procedureController,
            decoration: const InputDecoration(
              labelText: 'Procedure',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              final newSurgery = Surgery(
                  id: surgery.id,
                  otId: surgery.otId,
                  patientName: surgery.patientName,
                  procedure: value,
                  surgeonId: surgery.surgeonId);
              appState.updateSurgery(newSurgery);
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<Surgeon>(
            initialValue: selectedSurgeon,
            decoration: const InputDecoration(
              labelText: 'Surgeon',
              border: OutlineInputBorder(),
            ),
            onChanged: (Surgeon? newValue) {
              final newSurgery = Surgery(
                  id: surgery.id,
                  otId: surgery.otId,
                  patientName: surgery.patientName,
                  procedure: surgery.procedure,
                  surgeonId: newValue?.id);
              appState.updateSurgery(newSurgery);
            },
            items: appState.surgeons.map((surgeon) {
              return DropdownMenuItem(value: surgeon, child: Text(surgeon.name));
            }).toList(),
          ),
        ],
      ),
    );
  }
}
