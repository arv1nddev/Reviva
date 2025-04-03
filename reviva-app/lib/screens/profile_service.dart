import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_model.dart';

class ProfileService {
  static const String _profileKey = 'user_profile';

  // Save profile to SharedPreferences
  Future<void> saveProfile(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, json.encode(profile.toJson()));
  }

  // Retrieve profile from SharedPreferences
  Future<Profile?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);
    
    if (profileJson != null) {
      return Profile.fromJson(json.decode(profileJson));
    }
    return null;
  }

  // Check if profile exists
  Future<bool> hasProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_profileKey);
  }

  // Clear profile
  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }
}