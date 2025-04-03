import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile_model.dart';
import 'profile_service.dart';
import 'profile_view_screen.dart';
import 'home_screen.dart';
import 'medication_schedule.dart';
import 'nutrition_planner.dart';
import 'mental_health.dart';


class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  _ProfileCreationScreenState createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProfileService _profileService = ProfileService();
  
  // Controllers for text fields
  final TextEditingController _uniquePatientIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _residenceController = TextEditingController();
  final TextEditingController _adharNoController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();

  String? _sex;
  String? _socioeconomicStatus;
  String? _bloodGroup;
  String? _maritalStatus;
  String? _religion;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  // Load existing profile if it exists
  void _loadExistingProfile() async {
    final existingProfile = await _profileService.getProfile();
    if (existingProfile != null) {
      setState(() {
        _uniquePatientIdController.text = existingProfile.uniquePatientId ?? '';
        _nameController.text = existingProfile.name ?? '';
        _ageController.text = existingProfile.age?.toString() ?? '';
        _sex = existingProfile.sex;
        _socioeconomicStatus = existingProfile.socioeconomicStatus;
        _residenceController.text = existingProfile.residence ?? '';
        _adharNoController.text = existingProfile.adharNo ?? '';
        _phoneNoController.text = existingProfile.phoneNo ?? '';
        _heightController.text = existingProfile.height?.toString() ?? '';
        _weightController.text = existingProfile.weight?.toString() ?? '';
        _bloodGroup = existingProfile.bloodGroup;
        _maritalStatus = existingProfile.maritalStatus;
        _occupationController.text = existingProfile.occupation ?? '';
        _religion = existingProfile.religion;
      });
    }
  }

  // Save profile
  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final profile = Profile(
        uniquePatientId: _uniquePatientIdController.text,
        name: _nameController.text,
        age: int.tryParse(_ageController.text),
        sex: _sex,
        socioeconomicStatus: _socioeconomicStatus,
        residence: _residenceController.text,
        adharNo: _adharNoController.text,
        phoneNo: _phoneNoController.text,
        height: double.tryParse(_heightController.text),
        weight: double.tryParse(_weightController.text),
        bloodGroup: _bloodGroup,
        maritalStatus: _maritalStatus,
        occupation: _occupationController.text,
        religion: _religion,
      );

      await _profileService.saveProfile(profile);

    screens = [
    MedicationScheduleScreen(),
    NutritionPlannerScreen(),
    MentalHealthScreen(),
    ProfileViewScreen(),
  ];
  setState(() {
    
  });
  Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProfileViewScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Patient Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Unique Patient ID
              TextFormField(
                controller: _uniquePatientIdController,
                decoration: InputDecoration(labelText: 'Unique Patient ID'),
                validator: (value) => value!.isEmpty ? 'Please enter Patient ID' : null,
              ),
              
              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter Name' : null,
              ),
              
              // Age
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => value!.isEmpty ? 'Please enter Age' : null,
              ),
              
              // Sex Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Sex'),
                value: _sex,
                items: ['Male', 'Female', 'Other']
                    .map((sex) => DropdownMenuItem(
                          value: sex,
                          child: Text(sex),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _sex = value),
                validator: (value) => value == null ? 'Please select Sex' : null,
              ),
              
              // Socioeconomic Status Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Socioeconomic Status'),
                value: _socioeconomicStatus,
                items: ['Low', 'Middle', 'High']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _socioeconomicStatus = value),
                validator: (value) => value == null ? 'Please select Status' : null,
              ),
              
              // Residence
              TextFormField(
                controller: _residenceController,
                decoration: InputDecoration(labelText: 'Residence (Address)'),
                maxLines: 2,
                validator: (value) => value!.isEmpty ? 'Please enter Residence' : null,
              ),
              
              // Adhar No
              TextFormField(
                controller: _adharNoController,
                decoration: InputDecoration(labelText: 'Adhar Number'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => value!.isEmpty ? 'Please enter Adhar Number' : null,
              ),
              
              // Phone No
              TextFormField(
                controller: _phoneNoController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => value!.isEmpty ? 'Please enter Phone Number' : null,
              ),
              
              // Height
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value!.isEmpty ? 'Please enter Height' : null,
              ),
              
              // Weight
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value!.isEmpty ? 'Please enter Weight' : null,
              ),
              
              // Blood Group Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Blood Group'),
                value: _bloodGroup,
                items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                    .map((group) => DropdownMenuItem(
                          value: group,
                          child: Text(group),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _bloodGroup = value),
                validator: (value) => value == null ? 'Please select Blood Group' : null,
              ),
              
              // Marital Status Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Marital Status'),
                value: _maritalStatus,
                items: ['Single', 'Married', 'Divorced', 'Widowed']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _maritalStatus = value),
                validator: (value) => value == null ? 'Please select Marital Status' : null,
              ),
              
              // Occupation
              TextFormField(
                controller: _occupationController,
                decoration: InputDecoration(labelText: 'Occupation'),
                validator: (value) => value!.isEmpty ? 'Please enter Occupation' : null,
              ),
              
              // Religion Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Religion'),
                value: _religion,
                items: ['Hinduism', 'Islam', 'Christianity', 'Sikhism', 'Buddhism', 'Jainism', 'Other']
                    .map((religion) => DropdownMenuItem(
                          value: religion,
                          child: Text(religion),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _religion = value),
                validator: (value) => value == null ? 'Please select Religion' : null,
              ),
              
              SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    _uniquePatientIdController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _residenceController.dispose();
    _adharNoController.dispose();
    _phoneNoController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _occupationController.dispose();
    super.dispose();
  }
}