import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ot_roster/models/surgery.dart';
import 'package:ot_roster/providers/app_state.dart';

class StaffAllocationCard extends StatelessWidget {
  const StaffAllocationCard({super.key});

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
            Text('Allocate Staff', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...appState.surgeries
                .where((s) => s.patientName != null && s.patientName!.isNotEmpty)
                .map((surgery) => _buildStaffAllocationRow(context, surgery))
                ,
          ],
        ),
      ),
    );
  }

  Widget _buildStaffAllocationRow(BuildContext context, Surgery surgery) {
    final appState = Provider.of<AppState>(context, listen: false);
    final allocatedStaff = appState.allocatedStaff[surgery.otId] ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${surgery.otId}: ${surgery.patientName}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            children: appState.staff.map((staff) {
              final isSelected = allocatedStaff.any((s) => s.id == staff.id);
              return ChoiceChip(
                label: Text(staff.name),
                selected: isSelected,
                onSelected: (selected) {
                  appState.toggleStaffAllocation(surgery.otId, staff);
                },
                selectedColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
