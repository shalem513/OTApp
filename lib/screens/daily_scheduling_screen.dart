import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/ot_selection_card.dart';
import '../widgets/surgery_scheduling_card.dart';
import '../widgets/staff_allocation_card.dart';

class DailySchedulingScreen extends StatelessWidget {
  const DailySchedulingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OtSelectionCard(),
            if (appState.selectedOts.isNotEmpty) ...[
              const SizedBox(height: 24),
              SurgerySchedulingCard(),
            ],
            if (appState.surgeries.isNotEmpty && appState.surgeries.any((s) => s.patientName != null && s.patientName!.isNotEmpty)) ...[
              const SizedBox(height: 24),
              StaffAllocationCard(),
            ],
          ],
        ),
      ),
    );
  }
}
