import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'food_recognition.dart';

class NutritionEntry {
  final String id;
  final String foodName;
  final int calories;
  final double protein; // in grams
  final double carbs; // in grams
  final double fat; // in grams
  final DateTime dateTime;
  final String mealType; // Breakfast, Lunch, Dinner, Snack

  NutritionEntry({
    required this.id,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.dateTime,
    required this.mealType,
  });

  Map<
    String,
    dynamic
  >
  toJson() {
    return {
      'id':
          id,
      'foodName':
          foodName,
      'calories':
          calories,
      'protein':
          protein,
      'carbs':
          carbs,
      'fat':
          fat,
      'dateTime':
          dateTime.toIso8601String(),
      'mealType':
          mealType,
    };
  }

  factory NutritionEntry.fromJson(
    Map<
      String,
      dynamic
    >
    json,
  ) {
    return NutritionEntry(
      id:
          json['id'],
      foodName:
          json['foodName'],
      calories:
          json['calories'],
      protein:
          json['protein'].toDouble(),
      carbs:
          json['carbs'].toDouble(),
      fat:
          json['fat'].toDouble(),
      dateTime: DateTime.parse(
        json['dateTime'],
      ),
      mealType:
          json['mealType'],
    );
  }

  String getFormattedDate() {
    return DateFormat(
      'MMM d, yyyy',
    ).format(
      dateTime,
    );
  }

  String getFormattedTime() {
    return DateFormat(
      'h:mm a',
    ).format(
      dateTime,
    );
  }
}

class NutritionTrackerScreen
    extends
        StatefulWidget {
  const NutritionTrackerScreen({
    super.key,
  });

  @override
  NutritionTrackerState createState() =>
      NutritionTrackerState();
}

class NutritionTrackerState
    extends
        State<
          NutritionTrackerScreen
        > {
  List<
    NutritionEntry
  >
  nutritionEntries =
      [];
  bool isLoading =
      true;
  DateTime selectedDate =
      DateTime.now();

  // Daily nutrition goals
  final int calorieGoal =
      2000;
  final double proteinGoal =
      50; // grams
  final double carbsGoal =
      250; // grams
  final double fatGoal =
      70; // grams

  @override
  void initState() {
    super.initState();
    _loadNutritionEntries();
  }

  Future<
    void
  >
  _loadNutritionEntries() async {
    setState(
      () {
        isLoading =
            true;
      },
    );

    final prefs =
        await SharedPreferences.getInstance();
    final entriesJson =
        prefs.getStringList(
          'nutritionEntries',
        ) ??
        [];

    setState(
      () {
        nutritionEntries =
            entriesJson
                .map(
                  (
                    json,
                  ) => NutritionEntry.fromJson(
                    jsonDecode(
                      json,
                    ),
                  ),
                )
                .toList();
        isLoading =
            false;
      },
    );
  }

  Future<
    void
  >
  _saveNutritionEntries() async {
    final prefs =
        await SharedPreferences.getInstance();
    final entriesJson =
        nutritionEntries
            .map(
              (
                entry,
              ) => jsonEncode(
                entry.toJson(),
              ),
            )
            .toList();

    await prefs.setStringList(
      'nutritionEntries',
      entriesJson,
    );
  }

  void _addNutritionEntry() async {
    final added =
        await _showNutritionEntryDialog();
    if (added) {
      setState(
        () {},
      );
    }
  }

  void _editNutritionEntry(
    NutritionEntry entry,
  ) async {
    final edited = await _showNutritionEntryDialog(
      entry:
          entry,
    );
    if (edited) {
      setState(
        () {},
      );
    }
  }

  void _deleteNutritionEntry(
    String id,
  ) async {
    setState(
      () {
        nutritionEntries.removeWhere(
          (
            entry,
          ) =>
              entry.id ==
              id,
        );
      },
    );
    await _saveNutritionEntries();
  }

  Future<
    bool
  >
  _showNutritionEntryDialog({
    NutritionEntry? entry,
  }) async {
    final bool isEditing =
        entry !=
        null;
    final foodNameController = TextEditingController(
      text:
          isEditing
              ? entry.foodName
              : '',
    );
    final caloriesController = TextEditingController(
      text:
          isEditing
              ? entry.calories.toString()
              : '',
    );
    final proteinController = TextEditingController(
      text:
          isEditing
              ? entry.protein.toString()
              : '',
    );
    final carbsController = TextEditingController(
      text:
          isEditing
              ? entry.carbs.toString()
              : '',
    );
    final fatController = TextEditingController(
      text:
          isEditing
              ? entry.fat.toString()
              : '',
    );

    DateTime selectedDateTime =
        isEditing
            ? entry.dateTime
            : DateTime.now();
    String selectedMealType =
        isEditing
            ? entry.mealType
            : 'Breakfast';
    final mealTypes = [
      'Breakfast',
      'Lunch',
      'Dinner',
      'Snack',
    ];

    bool entryAdded =
        false;

    await showDialog(
      context:
          context,
      builder: (
        context,
      ) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              title: Text(
                isEditing
                    ? 'Edit Food Entry'
                    : 'Add Food Entry',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    TextField(
                      controller:
                          foodNameController,
                      decoration: const InputDecoration(
                        labelText:
                            'Food Name*',
                        border:
                            OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height:
                          16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller:
                                caloriesController,
                            keyboardType:
                                TextInputType.number,
                            decoration: const InputDecoration(
                              labelText:
                                  'Calories*',
                              border:
                                  OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height:
                          16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller:
                                proteinController,
                            keyboardType:
                                TextInputType.number,
                            decoration: const InputDecoration(
                              labelText:
                                  'Protein (g)*',
                              border:
                                  OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width:
                              8,
                        ),
                        Expanded(
                          child: TextField(
                            controller:
                                carbsController,
                            keyboardType:
                                TextInputType.number,
                            decoration: const InputDecoration(
                              labelText:
                                  'Carbs (g)*',
                              border:
                                  OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width:
                              8,
                        ),
                        Expanded(
                          child: TextField(
                            controller:
                                fatController,
                            keyboardType:
                                TextInputType.number,
                            decoration: const InputDecoration(
                              labelText:
                                  'Fat (g)*',
                              border:
                                  OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height:
                          16,
                    ),
                    ListTile(
                      title: const Text(
                        'Date & Time*',
                      ),
                      subtitle: Text(
                        '${DateFormat('MMM d, yyyy').format(selectedDateTime)} at ${DateFormat('h:mm a').format(selectedDateTime)}',
                      ),
                      trailing: const Icon(
                        Icons.calendar_today,
                      ),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context:
                              context,
                          initialDate:
                              selectedDateTime,
                          firstDate: DateTime(
                            2020,
                          ),
                          lastDate: DateTime(
                            2030,
                          ),
                        );
                        if (pickedDate !=
                            null) {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context:
                                context,
                            initialTime: TimeOfDay.fromDateTime(
                              selectedDateTime,
                            ),
                          );
                          if (pickedTime !=
                              null) {
                            setDialogState(
                              () {
                                selectedDateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              },
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height:
                          16,
                    ),
                    DropdownButtonFormField<
                      String
                    >(
                      decoration: const InputDecoration(
                        labelText:
                            'Meal Type*',
                        border:
                            OutlineInputBorder(),
                      ),
                      value:
                          selectedMealType,
                      items:
                          mealTypes.map(
                            (
                              String mealType,
                            ) {
                              return DropdownMenuItem<
                                String
                              >(
                                value:
                                    mealType,
                                child: Text(
                                  mealType,
                                ),
                              );
                            },
                          ).toList(),
                      onChanged: (
                        String? newValue,
                      ) {
                        if (newValue !=
                            null) {
                          setDialogState(
                            () {
                              selectedMealType =
                                  newValue;
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop();
                  },
                  child: const Text(
                    'Cancel',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // Validate inputs
                    if (foodNameController.text.isEmpty ||
                        caloriesController.text.isEmpty ||
                        proteinController.text.isEmpty ||
                        carbsController.text.isEmpty ||
                        fatController.text.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill in all required fields',
                          ),
                        ),
                      );
                      return;
                    }

                    // Parse numeric values
                    int? calories = int.tryParse(
                      caloriesController.text,
                    );
                    double? protein = double.tryParse(
                      proteinController.text,
                    );
                    double? carbs = double.tryParse(
                      carbsController.text,
                    );
                    double? fat = double.tryParse(
                      fatController.text,
                    );

                    if (calories ==
                            null ||
                        protein ==
                            null ||
                        carbs ==
                            null ||
                        fat ==
                            null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter valid numeric values',
                          ),
                        ),
                      );
                      return;
                    }

                    final newEntry = NutritionEntry(
                      id:
                          isEditing
                              ? entry.id
                              : DateTime.now().millisecondsSinceEpoch.toString(),
                      foodName:
                          foodNameController.text,
                      calories:
                          calories,
                      protein:
                          protein,
                      carbs:
                          carbs,
                      fat:
                          fat,
                      dateTime:
                          selectedDateTime,
                      mealType:
                          selectedMealType,
                    );

                    // Update the entries list in the parent widget's state
                    if (isEditing) {
                      final index = nutritionEntries.indexWhere(
                        (
                          e,
                        ) =>
                            e.id ==
                            entry.id,
                      );
                      if (index !=
                          -1) {
                        setState(
                          () {
                            nutritionEntries[index] =
                                newEntry;
                          },
                        );
                      }
                    } else {
                      setState(
                        () {
                          nutritionEntries.add(
                            newEntry,
                          );
                        },
                      );
                    }

                    await _saveNutritionEntries();

                    entryAdded =
                        true;
                    Navigator.of(
                      context,
                    ).pop();
                  },
                  child: Text(
                    isEditing
                        ? 'Update'
                        : 'Add',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    return entryAdded;
  }

  List<
    NutritionEntry
  >
  _getEntriesForDate(
    DateTime date,
  ) {
    return nutritionEntries.where(
      (
        entry,
      ) {
        return entry.dateTime.year ==
                date.year &&
            entry.dateTime.month ==
                date.month &&
            entry.dateTime.day ==
                date.day;
      },
    ).toList();
  }

  Map<
    String,
    List<
      NutritionEntry
    >
  >
  _getEntriesByMealType(
    List<
      NutritionEntry
    >
    entries,
  ) {
    final Map<
      String,
      List<
        NutritionEntry
      >
    >
    result = {
      'Breakfast':
          [],
      'Lunch':
          [],
      'Dinner':
          [],
      'Snack':
          [],
    };

    for (var entry in entries) {
      result[entry.mealType]!.add(
        entry,
      );
    }

    return result;
  }

  int _getTotalCalories(
    List<
      NutritionEntry
    >
    entries,
  ) {
    return entries.fold(
      0,
      (
        sum,
        entry,
      ) =>
          sum +
          entry.calories,
    );
  }

  double _getTotalProtein(
    List<
      NutritionEntry
    >
    entries,
  ) {
    return entries.fold(
      0.0,
      (
        sum,
        entry,
      ) =>
          sum +
          entry.protein,
    );
  }

  double _getTotalCarbs(
    List<
      NutritionEntry
    >
    entries,
  ) {
    return entries.fold(
      0.0,
      (
        sum,
        entry,
      ) =>
          sum +
          entry.carbs,
    );
  }

  double _getTotalFat(
    List<
      NutritionEntry
    >
    entries,
  ) {
    return entries.fold(
      0.0,
      (
        sum,
        entry,
      ) =>
          sum +
          entry.fat,
    );
  }

  Widget _buildNutritionSummary(
    List<
      NutritionEntry
    >
    entries,
  ) {
    final totalCalories = _getTotalCalories(
      entries,
    );
    final totalProtein = _getTotalProtein(
      entries,
    );
    final totalCarbs = _getTotalCarbs(
      entries,
    );
    final totalFat = _getTotalFat(
      entries,
    );

    final caloriePercent = (totalCalories /
            calorieGoal)
        .clamp(
          0.0,
          1.0,
        );
    final proteinPercent = (totalProtein /
            proteinGoal)
        .clamp(
          0.0,
          1.0,
        );
    final carbsPercent = (totalCarbs /
            carbsGoal)
        .clamp(
          0.0,
          1.0,
        );
    final fatPercent = (totalFat /
            fatGoal)
        .clamp(
          0.0,
          1.0,
        );

    return Card(
      margin: const EdgeInsets.only(
        bottom:
            16,
      ),
      elevation:
          2,
      child: Padding(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Nutrition Summary',
              style:
                  Theme.of(
                    context,
                  ).textTheme.titleLarge,
            ),
            const SizedBox(
              height:
                  16,
            ),
            _buildProgressBar(
              'Calories',
              '$totalCalories / $calorieGoal kcal',
              caloriePercent,
              Colors.red,
            ),
            const SizedBox(
              height:
                  8,
            ),
            _buildProgressBar(
              'Protein',
              '${totalProtein.toStringAsFixed(1)} / ${proteinGoal.toStringAsFixed(1)} g',
              proteinPercent,
              Colors.blue,
            ),
            const SizedBox(
              height:
                  8,
            ),
            _buildProgressBar(
              'Carbs',
              '${totalCarbs.toStringAsFixed(1)} / ${carbsGoal.toStringAsFixed(1)} g',
              carbsPercent,
              Colors.green,
            ),
            const SizedBox(
              height:
                  8,
            ),
            _buildProgressBar(
              'Fat',
              '${totalFat.toStringAsFixed(1)} / ${fatGoal.toStringAsFixed(1)} g',
              fatPercent,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(
    String label,
    String value,
    double percent,
    Color color,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
            ),
            Text(
              value,
            ),
          ],
        ),
        const SizedBox(
          height:
              4,
        ),
        LinearProgressIndicator(
          value:
              percent,
          backgroundColor: color.withOpacity(
            0.2,
          ),
          valueColor: AlwaysStoppedAnimation<
            Color
          >(
            color,
          ),
          minHeight:
              8,
          borderRadius: BorderRadius.circular(
            4,
          ),
        ),
      ],
    );
  }

  Widget _buildMealSection(
    String mealType,
    List<
      NutritionEntry
    >
    entries,
  ) {
    if (entries.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical:
                8,
          ),
          child: Text(
            mealType,
            style:
                Theme.of(
                  context,
                ).textTheme.titleMedium,
          ),
        ),
        ...entries.map(
          (
            entry,
          ) => _buildFoodEntryCard(
            entry,
          ),
        ),
      ],
    );
  }

  Widget _buildFoodEntryCard(
    NutritionEntry entry,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom:
            8,
      ),
      elevation:
          1,
      child: Padding(
        padding: const EdgeInsets.all(
          12,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.foodName,
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize:
                          16,
                    ),
                  ),
                  const SizedBox(
                    height:
                        4,
                  ),
                  Text(
                    '${entry.calories} kcal • P: ${entry.protein.toStringAsFixed(1)}g • C: ${entry.carbs.toStringAsFixed(1)}g • F: ${entry.fat.toStringAsFixed(1)}g',
                    style: TextStyle(
                      color:
                          Colors.grey[600],
                      fontSize:
                          14,
                    ),
                  ),
                  const SizedBox(
                    height:
                        4,
                  ),
                  Text(
                    entry.getFormattedTime(),
                    style: TextStyle(
                      color:
                          Colors.grey[600],
                      fontSize:
                          12,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size:
                        20,
                  ),
                  onPressed:
                      () => _editNutritionEntry(
                        entry,
                      ),
                  tooltip:
                      'Edit',
                  constraints:
                      const BoxConstraints(),
                  padding: const EdgeInsets.all(
                    8,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size:
                        20,
                  ),
                  onPressed:
                      () => _deleteNutritionEntry(
                        entry.id,
                      ),
                  tooltip:
                      'Delete',
                  color:
                      Colors.red,
                  constraints:
                      const BoxConstraints(),
                  padding: const EdgeInsets.all(
                    8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final entriesForSelectedDate = _getEntriesForDate(
      selectedDate,
    );
    final entriesByMealType = _getEntriesByMealType(
      entriesForSelectedDate,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nutrition Tracker',
        ),
        backgroundColor:
            Theme.of(
              context,
            ).colorScheme.primary,
        foregroundColor:
            Theme.of(
              context,
            ).colorScheme.onPrimary,
      ),
      body:
          isLoading
              ? const Center(
                child:
                    CircularProgressIndicator(),
              )
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(
                      16,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_left,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                selectedDate = selectedDate.subtract(
                                  const Duration(
                                    days:
                                        1,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        GestureDetector(
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context:
                                  context,
                              initialDate:
                                  selectedDate,
                              firstDate: DateTime(
                                2020,
                              ),
                              lastDate: DateTime(
                                2030,
                              ),
                            );
                            if (pickedDate !=
                                null) {
                              setState(
                                () {
                                  selectedDate =
                                      pickedDate;
                                },
                              );
                            }
                          },
                          child: Text(
                            DateFormat(
                              'EEEE, MMM d, yyyy',
                            ).format(
                              selectedDate,
                            ),
                            style: const TextStyle(
                              fontSize:
                                  18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_right,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                selectedDate = selectedDate.add(
                                  const Duration(
                                    days:
                                        1,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        entriesForSelectedDate.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.restaurant,
                                    size:
                                        80,
                                    color:
                                        Colors.grey,
                                  ),
                                  const SizedBox(
                                    height:
                                        16,
                                  ),
                                  const Text(
                                    'No food entries for this day',
                                    style: TextStyle(
                                      fontSize:
                                          18,
                                      color:
                                          Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    height:
                                        24,
                                  ),
                                  ElevatedButton.icon(
                                    onPressed:
                                        _addNutritionEntry,
                                    icon: const Icon(
                                      Icons.add,
                                    ),
                                    label: const Text(
                                      'Add Food Entry',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            24,
                                        vertical:
                                            12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView(
                              padding: const EdgeInsets.all(
                                16,
                              ),
                              children: [
                                _buildNutritionSummary(
                                  entriesForSelectedDate,
                                ),
                                _buildMealSection(
                                  'Breakfast',
                                  entriesByMealType['Breakfast']!,
                                ),
                                _buildMealSection(
                                  'Lunch',
                                  entriesByMealType['Lunch']!,
                                ),
                                _buildMealSection(
                                  'Dinner',
                                  entriesByMealType['Dinner']!,
                                ),
                                _buildMealSection(
                                  'Snack',
                                  entriesByMealType['Snack']!,
                                ),
                              ],
                            ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed:
           (){},
        child: const Icon(
          Icons.camera,
        ),
      ),
    );
  }
}
