import 'package:flutter/material.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Security'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Change Password',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'To update your password, please enter your current password and a new one.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Old Password Field
            _buildPasswordField(_oldPasswordController, 'Current Password'),

            // New Password Field
            _buildPasswordField(_newPasswordController, 'New Password'),

            // Confirm New Password Field
            _buildPasswordField(_confirmPasswordController, 'Confirm New Password'),

            const SizedBox(height: 20),

            // Change Password Button (Does Nothing)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // This is a placeholder, does nothing
                  _showConfirmationDialog();
                },
                child: const Text('Change Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Password Input Fields
  Widget _buildPasswordField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // Fake Confirmation Dialog
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Password Changed'),
          content: const Text('Your password has been successfully updated (for display purposes).'),
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
