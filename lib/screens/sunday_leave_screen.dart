import 'package:flutter/material.dart';
import '../widgets/leave_management_card.dart';
import '../widgets/sunday_roster_card.dart';

class SundayLeaveScreen extends StatelessWidget {
  const SundayLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            LeaveManagementCard(),
            SizedBox(height: 24),
            SundayRosterCard(),
          ],
        ),
      ),
    );
  }
}
