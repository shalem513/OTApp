import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ot_roster/models/leave.dart';
import 'package:ot_roster/models/staff.dart';
import 'package:ot_roster/providers/app_state.dart';
import 'package:searchfield/searchfield.dart';

class LeaveManagementCard extends StatefulWidget {
  const LeaveManagementCard({super.key});

  @override
  State<LeaveManagementCard> createState() => _LeaveManagementCardState();
}

class _LeaveManagementCardState extends State<LeaveManagementCard> {
  final _formKey = GlobalKey<FormState>();
  Staff? _selectedStaff;
  DateTime? _startDate;
  DateTime? _endDate;
  final _staffController = TextEditingController();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate ?? DateTime.now() : _endDate ?? _startDate ?? DateTime.now(),
      firstDate: isStartDate ? DateTime.now() : _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if(_endDate != null && _endDate!.isBefore(_startDate!)){
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _addLeave() {
    if (_formKey.currentState!.validate()) {
      final newLeave = Leave(
        id: DateTime.now().toString(),
        staffId: _selectedStaff!.id,
        startDate: _startDate!,
        endDate: _endDate!,
      );
      Provider.of<AppState>(context, listen: false).addLeave(newLeave);
      setState(() {
        _selectedStaff = null;
        _startDate = null;
        _endDate = null;
        _staffController.clear();
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
              Text(
                'Leave Management',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              SearchField<Staff>(
                controller: _staffController,
                suggestions: appState.staff
                    .map((staff) =>
                        SearchFieldListItem(staff.name, item: staff))
                    .toList(),
                suggestionState: Suggestion.expand,
                textInputAction: TextInputAction.next,
                hint: 'Select Staff',
                searchStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.8),
                ),
                validator: (x) {
                  if (x == null || x.isEmpty || !appState.staff.any((staff) => staff.name == x)) {
                     return 'Please select a valid staff member';
                  }                  
                  return null;
                },
                searchInputDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_search),
                ),
                onSuggestionTap: (SearchFieldListItem<Staff> x) {
                  setState(() {
                    _selectedStaff = x.item;
                    _staffController.text = x.item!.name;
                  });
                  FocusScope.of(context).unfocus();
                },
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: _startDate == null
                            ? 'From Date'
                            : 'From: ${_startDate!.toLocal()}'.split(' ')[0],
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectDate(context, true),
                      validator: (value) =>
                          _startDate == null ? 'Please select a start date' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: _endDate == null
                            ? 'To Date'
                            : 'To: ${_endDate!.toLocal()}'.split(' ')[0],
                        border: const OutlineInputBorder(),
                         prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectDate(context, false),
                      validator: (value) =>
                          _endDate == null ? 'Please select an end date' : null,
                    ),
                  ),
                ],
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
              Text(
                'Upcoming Leave',
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
                    final staffMember = appState.staff.firstWhere(
                      (s) => s.id == leave.staffId,
                      orElse: () => Staff(id: '', name: 'Unknown', role: StaffRole.Nurse, department: ''),
                    );
                    return ListTile(
                      leading: CircleAvatar(child: Text(staffMember.name.isNotEmpty ? staffMember.name[0] : 'U')),
                      title: Text(staffMember.name),
                      subtitle: Text('${leave.startDate.toLocal()}'.split(' ')[0] + ' - ' + '${leave.endDate.toLocal()}'.split(' ')[0]),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          Provider.of<AppState>(
                            context,
                            listen: false,
                          ).removeLeave(leave.id);
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
