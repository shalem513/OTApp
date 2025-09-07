import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/staff.dart';

class SundayRosterCard extends StatefulWidget {
  const SundayRosterCard({super.key});

  @override
  _SundayRosterCardState createState() => _SundayRosterCardState();
}

class _SundayRosterCardState extends State<SundayRosterCard> {
  final List<String> _shifts = ['Morning', 'Evening', 'Night'];
  final Map<String, List<Staff>> _selectedStaffByShift = {};

  void _showStaffSelectionDialog(BuildContext context, String shift) {
    final appState = Provider.of<AppState>(context, listen: false);
    final availableStaff = appState.staff;
    final currentlySelected = _selectedStaffByShift[shift] ?? [];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Staff for $shift Shift'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableStaff.length,
                  itemBuilder: (context, index) {
                    final staff = availableStaff[index];
                    final isSelected = currentlySelected.any((s) => s.id == staff.id);
                    return CheckboxListTile(
                      title: Text(staff.name),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            if (!isSelected) {
                              currentlySelected.add(staff);
                            }
                          } else {
                            currentlySelected.removeWhere((s) => s.id == staff.id);
                          }
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedStaffByShift[shift] = List.from(currentlySelected);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sunday Roster', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.blueAccent),
                  onPressed: () {
                    setState(() {
                      _selectedStaffByShift.clear();
                    });
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Roster cleared.')),
                    );
                  },
                  tooltip: 'Clear Roster',
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _shifts.length,
              itemBuilder: (context, index) {
                final shift = _shifts[index];
                final selectedStaff = _selectedStaffByShift[shift] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(shift, style: Theme.of(context).textTheme.titleMedium),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                          onPressed: () => _showStaffSelectionDialog(context, shift),
                          tooltip: 'Add Staff to $shift Shift',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (selectedStaff.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                        child: Text('No staff assigned.', style: TextStyle(fontStyle: FontStyle.italic)),
                      )
                    else
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: selectedStaff.map((staff) => Chip(
                          avatar: CircleAvatar(child: Text(staff.name[0])),
                          label: Text(staff.name),
                           onDeleted: () {
                            setState(() {
                              _selectedStaffByShift[shift]!.removeWhere((s) => s.id == staff.id);
                            });
                          }, 
                        )).toList(),
                      ),
                    if (index < _shifts.length - 1) const Divider(height: 32),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
