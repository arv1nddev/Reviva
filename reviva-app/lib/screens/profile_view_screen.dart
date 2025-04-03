import 'package:flutter/material.dart';
import 'profile_model.dart';
import 'profile_service.dart';
import 'profile_creation_screen.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  _ProfileViewScreenState createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  Profile? _profile;
  final ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final profile = await _profileService.getProfile();
    setState(() {
      _profile = profile;
    });
  }

  void _editProfile() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ProfileCreationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editProfile,
          ),
        ],
      ),
      body: _profile == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileField('Unique Patient ID', _profile!.uniquePatientId),
                  _buildProfileField('Name', _profile!.name),
                  _buildProfileField('Age', _profile!.age?.toString()),
                  _buildProfileField('Sex', _profile!.sex),
                  _buildProfileField('Socioeconomic Status', _profile!.socioeconomicStatus),
                  _buildProfileField('Residence', _profile!.residence),
                  _buildProfileField('Adhar Number', _profile!.adharNo),
                  _buildProfileField('Phone Number', _profile!.phoneNo),
                  _buildProfileField('Height', _profile!.height?.toString()),
                  _buildProfileField('Weight', _profile!.weight?.toString()),
                  _buildProfileField('Blood Group', _profile!.bloodGroup),
                  _buildProfileField('Marital Status', _profile!.maritalStatus),
                  _buildProfileField('Occupation', _profile!.occupation),
                  _buildProfileField('Religion', _profile!.religion),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value ?? 'Not Specified',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}