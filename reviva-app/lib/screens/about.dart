import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Reviva'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Image(
              image: const AssetImage('assets/images/revivaSplash.png'),
              height: 120,
              width: 120,
            ),
            const SizedBox(height: 16),
            
            // App Name & Tagline
            const Text(
              'Reviva - A New Life After Transplant',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // App Description
            const Text(
              'Reviva is a mobile and web application designed for transplant patients and doctors. It facilitates seamless communication and advanced monitoring of post-transplant health. '
              'By providing real-time insights, it helps improve patient outcomes and minimizes hospital readmissions.\n\n'
              'Reviva empowers proactive healthcare and supports patients every step of the way.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Team Section
            _buildSectionTitle('Meet the Team'),
            _buildTeamMember('Harsh Prajapati', 'Co-founder & Developer'),
            _buildTeamMember('Avdhish Dhanani', 'Co-founder & Developer'),
            _buildTeamMember('Jainam Patel', 'UI/UX Designer'),
            _buildTeamMember('Arvind Chaudhry', 'Medical Consultant'),
            _buildTeamMember('Vedant More', 'Backend Engineer'),
            _buildTeamMember('Deep Kapadiya', 'Data Analyst'),
            const SizedBox(height: 20),

            // Contact Section
            _buildSectionTitle('Get in Touch'),
            _buildContactRow(Icons.email, 'Email', 'contact@reviva.com'),
            _buildContactRow(Icons.language, 'Website', 'www.revivahealth.com'),
            _buildContactRow(Icons.link, 'LinkedIn', 'linkedin.com/company/reviva'),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper widget for section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper widget for team members
  Widget _buildTeamMember(String name, String role) {
    return ListTile(
      leading: const Icon(Icons.person, color: Colors.green),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(role),
    );
  }

  // Helper widget for contact details
  Widget _buildContactRow(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }
}
