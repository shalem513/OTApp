import 'package:flutter/material.dart';
import '../widgets/staff_management_card.dart';
import '../widgets/surgeon_management_card.dart';

class MasterDataScreen extends StatelessWidget {
  const MasterDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StaffManagementCard(),
            const SizedBox(height: 24),
            SurgeonManagementCard(),
          ],
        ),
      ),
    );
  }
}
