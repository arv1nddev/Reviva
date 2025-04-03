import 'package:flutter/material.dart';
import 'medication_schedule.dart';
import 'nutrition_planner.dart';
import 'mental_health.dart';
import 'profile_service.dart';
import 'profile_view_screen.dart';
import 'profile_creation_screen.dart';
import 'food_recognition.dart';

List<
  Widget
>
screens = [
  MedicationScheduleScreen(),
  NutritionPlannerScreen(),
  MentalHealthScreen(),
  FoodRecognitionScreen(),
  ProfileCreationScreen(),
];

class HomeScreen
    extends
        StatefulWidget {
  final Function(
    bool,
  )
  toggleTheme;
  final bool isDarkMode;
  const HomeScreen({
    required this.toggleTheme,
    required this.isDarkMode,
    super.key,
  });
  @override
  HomeScreenState createState() =>
      HomeScreenState();
}

class HomeScreenState
    extends
        State<
          HomeScreen
        > {
  final ProfileService _profileService =
      ProfileService();
  int _selectedIndex =
      0;

  @override
  void initState() {
    super.initState();
    _checkProfileStatus();
  }

  void _checkProfileStatus() async {
    final hasProfile =
        await _profileService.hasProfile();

    if (hasProfile) {
      screens = [
        MedicationScheduleScreen(),
        NutritionPlannerScreen(),
        MentalHealthScreen(),
        FoodRecognitionScreen(),
        hasProfile
            ? ProfileViewScreen()
            : ProfileCreationScreen(),
      ];
    }
  }

  void _onItemTapped(
    int index,
  ) {
    setState(
      () =>
          _selectedIndex =
              index,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reviva Dashboard',
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed:
                () => Navigator.pushNamed(
                  context,
                  '/settings',
                ),
          ),
        ],
      ),
      body: IndexedStack(
        index:
            _selectedIndex,
        children:
            screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type:
            BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.medication,
            ),
            label:
                'Meds',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.restaurant,
            ),
            label:
                'Nutrition',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.psychology,
            ),
            label:
                'Health',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera,
            ),
            label:
                'Identifier',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label:
                'profile',
          ),
        ],
        currentIndex:
            _selectedIndex,
        onTap:
            _onItemTapped,
      ),
    );
  }
}
