import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';

class StaffManagementCard extends StatefulWidget {
  const StaffManagementCard({super.key});

  @override
  _StaffManagementCardState createState() => _StaffManagementCardState();
}

class _StaffManagementCardState extends State<StaffManagementCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  StaffRole _selectedRole = StaffRole.Nurse;

  void _addStaff() {
    if (_formKey.currentState!.validate()) {
      final newStaff = Staff(
        id: DateTime.now().toString(),
        name: _nameController.text,
        role: _selectedRole,
      );
      Provider.of<AppState>(context, listen: false).addStaff(newStaff);
      _nameController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff added successfully!')),
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
                'Staff Management',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Staff Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a staff name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<StaffRole>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                onChanged: (StaffRole? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedRole = newValue;
                    });
                  }
                },
                items: StaffRole.values.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(
                      role.toString().split('.').last.replaceAll('_', ' '),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addStaff,
                  child: const Text('Add Staff'),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Staff List',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Divider(),
              if (appState.staff.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: Text('No staff members added yet.')),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appState.staff.length,
                  itemBuilder: (context, index) {
                    final staff = appState.staff[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(staff.name[0])),
                      title: Text(staff.name),
                      subtitle: Text(
                        staff.role
                            .toString()
                            .split('.')
                            .last
                            .replaceAll('_', ' '),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          Provider.of<AppState>(
                            context,
                            listen: false,
                          ).removeStaff(staff.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Staff removed.')),
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
