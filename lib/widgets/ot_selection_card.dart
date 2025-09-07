import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class OtSelectionCard extends StatelessWidget {
  const OtSelectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final availableOts = [
      'OT 1',
      'OT 2',
      'OT 3',
      'OT 4',
      'OT 5',
      'OT 6',
      'OT 7',
      'OT 8',
      'OT 9',
      'OT 10',
    ];

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Available OTs for Today',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              children: availableOts.map((ot) {
                final isSelected = appState.selectedOts.contains(ot);
                return ChoiceChip(
                  label: Text(ot),
                  selected: isSelected,
                  onSelected: (selected) {
                    appState.toggleOtSelection(ot);
                  },
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
