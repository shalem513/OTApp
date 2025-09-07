import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ot_roster/models/leave.dart';
import 'package:ot_roster/models/staff.dart';
import 'package:ot_roster/providers/app_state.dart';

class LeaveManagementCard extends StatefulWidget {
  const LeaveManagementCard({super.key});

  @override
  State<LeaveManagementCard> createState() => _LeaveManagementCardState();
}

class _LeaveManagementCardState extends State<LeaveManagementCard> {
  final _formKey = GlobalKey<FormState>();
  Staff? _selectedStaff;
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addLeave() {
    if (_formKey.currentState!.validate()) {
      final newLeave = Leave(
        id: DateTime.now().toString(),
        staffId: _selectedStaff!.id,
        date: _selectedDate!,
      );
      Provider.of<AppState>(context, listen: false).addLeave(newLeave);
      setState(() {
        _selectedStaff = null;
        _selectedDate = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leave added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Leave Management', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              DropdownButtonFormField<Staff>(
                initialValue: _selectedStaff,
                decoration: const InputDecoration(
                  labelText: 'Select Staff',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_search),
                ),
                onChanged: (Staff? newValue) {
                  setState(() {
                    _selectedStaff = newValue;
                  });
                },
                items: appState.staff.map((staff) {
                  return DropdownMenuItem(value: staff, child: Text(staff.name));
                }).toList(),
                validator: (value) => value == null ? 'Please select a staff member' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: _selectedDate == null
                      ? 'Select Leave Date'
                      : '${_selectedDate!.toLocal()}'.split(' ')[0],
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_month),
                ),
                onTap: () => _selectDate(context),
                validator: (value) => _selectedDate == null ? 'Please select a date' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addLeave,
                  child: const Text('Add Leave'),
                ),
              ),
              const SizedBox(height: 24),
              Text('Upcoming Leave', style: Theme.of(context).textTheme.titleMedium),
              const Divider(),
              if (appState.leave.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: Text('No leave scheduled.')),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appState.leave.length,
                  itemBuilder: (context, index) {
                    final leave = appState.leave[index];
                    final staffMember = appState.staff.firstWhere((s) => s.id == leave.staffId);
                    return ListTile(
                      leading: CircleAvatar(child: Text(staffMember.name[0])),
                      title: Text(staffMember.name),
                      subtitle: Text('${leave.date.toLocal()}'.split(' ')[0]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                        onPressed: () {
                          Provider.of<AppState>(context, listen: false).removeLeave(leave.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Leave removed.')),
                          );
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
