import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/surgeon.dart';

class SurgeonManagementCard extends StatefulWidget {
  const SurgeonManagementCard({super.key});

  @override
  _SurgeonManagementCardState createState() => _SurgeonManagementCardState();
}

class _SurgeonManagementCardState extends State<SurgeonManagementCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _departmentController = TextEditingController();

  void _addSurgeon() {
    if (_formKey.currentState!.validate()) {
      final newSurgeon = Surgeon(
        id: DateTime.now().toString(),
        name: _nameController.text,
        department: _departmentController.text,
      );
      Provider.of<AppState>(context, listen: false).addSurgeon(newSurgeon);
      _nameController.clear();
      _departmentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Surgeon added successfully!')),
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
                'Surgeon Management',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Surgeon Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a surgeon name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a department';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addSurgeon,
                  child: const Text('Add Surgeon'),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Surgeon List',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Divider(),
              if (appState.surgeons.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: Text('No surgeons added yet.')),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appState.surgeons.length,
                  itemBuilder: (context, index) {
                    final surgeon = appState.surgeons[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(surgeon.name[0])),
                      title: Text(surgeon.name),
                      subtitle: Text(surgeon.department),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          Provider.of<AppState>(
                            context,
                            listen: false,
                          ).removeSurgeon(surgeon.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Surgeon removed.')),
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
