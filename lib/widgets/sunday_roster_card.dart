import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SundayRosterCard extends StatelessWidget {
  const SundayRosterCard({super.key});

  void _generateRoster(BuildContext context) {
    Provider.of<AppState>(context, listen: false).generateSundayRoster();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sunday roster generated!')),
    );
  }

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
            Text('Sunday Roster', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _generateRoster(context),
                child: const Text('Generate This Week\'s Roster'),
              ),
            ),
            const SizedBox(height: 24),
            Text('This Week\'s Sunday Staff', style: Theme.of(context).textTheme.titleMedium),
            const Divider(),
            if (appState.sundayRoster.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: Text('Roster has not been generated yet.')),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appState.sundayRoster.length,
                itemBuilder: (context, index) {
                  final staff = appState.sundayRoster[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(staff.name[0])),
                    title: Text(staff.name),
                    subtitle: Text(staff.role.name),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
