import 'package:flutter/material.dart';

class MedicalAccessScreen extends StatelessWidget {
  const MedicalAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Access'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emergency Contacts',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildContactTile('Primary Contact', 'Dr. Rajesh Sharma', '+91 98765 43210'),
            _buildContactTile('Secondary Contact', 'Family Member', '+91 87654 32109'),

            const SizedBox(height: 20),

            const Text(
              'Medical Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildInfoTile('Blood Group', 'O+'),
            _buildInfoTile('Allergies', 'Penicillin, Dust Allergy'),
            _buildInfoTile('Medical Conditions', 'Kidney Transplant, Hypertension'),
            _buildInfoTile('Medications', 'Tacrolimus, Mycophenolate, Aspirin'),

            const SizedBox(height: 20),

            // Fake "Update Medical Info" Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showUpdateDialog(context);
                },
                child: const Text('Update Medical Info'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Emergency Contacts
  Widget _buildContactTile(String label, String name, String phone) {
    return ListTile(
      leading: const Icon(Icons.phone, color: Colors.redAccent),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(phone),
      trailing: const Icon(Icons.call, color: Colors.green),
    );
  }

  // Helper Widget for Medical Info
  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      leading: const Icon(Icons.medical_services, color: Colors.blueAccent),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }

  // Fake Dialog for Updating Medical Info
  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Medical Info'),
          content: const Text('This is a static UI. Updating info is currently disabled.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
