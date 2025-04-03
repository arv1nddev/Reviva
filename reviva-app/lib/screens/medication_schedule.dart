import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_init;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Medication {
  final String id;
  final String name;
  final String dosage;
  final TimeOfDay time;
  final List<
    bool
  >
  daysOfWeek; // [Mon, Tue, Wed, Thu, Fri, Sat, Sun]
  final String notes;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.daysOfWeek,
    this.notes =
        '',
  });

  Map<
    String,
    dynamic
  >
  toJson() {
    return {
      'id':
          id,
      'name':
          name,
      'dosage':
          dosage,
      'timeHour':
          time.hour,
      'timeMinute':
          time.minute,
      'daysOfWeek':
          daysOfWeek,
      'notes':
          notes,
    };
  }

  factory Medication.fromJson(
    Map<
      String,
      dynamic
    >
    json,
  ) {
    return Medication(
      id:
          json['id'],
      name:
          json['name'],
      dosage:
          json['dosage'],
      time: TimeOfDay(
        hour:
            json['timeHour'],
        minute:
            json['timeMinute'],
      ),
      daysOfWeek: List<
        bool
      >.from(
        json['daysOfWeek'],
      ),
      notes:
          json['notes'],
    );
  }

  String getTimeString() {
    final hour = time.hour.toString().padLeft(
      2,
      '0',
    );
    final minute = time.minute.toString().padLeft(
      2,
      '0',
    );
    return '$hour:$minute';
  }

  String getDaysString() {
    final days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    final selectedDays =
        <
          String
        >[];

    for (
      int i = 0;
      i <
          daysOfWeek.length;
      i++
    ) {
      if (daysOfWeek[i]) {
        selectedDays.add(
          days[i],
        );
      }
    }

    return selectedDays.join(
      ', ',
    );
  }
}

class MedicationScheduleScreen
    extends
        StatefulWidget {
  const MedicationScheduleScreen({
    super.key,
  });
  @override
  MedicationScheduleState createState() =>
      MedicationScheduleState();
}

class MedicationScheduleState
    extends
        State<
          MedicationScheduleScreen
        > {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<
    Medication
  >
  medications =
      [];
  bool isLoading =
      true;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadMedications();
  }

  Future<
    void
  >
  _initializeNotifications() async {
    tz_init.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission:
          true,
      requestBadgePermission:
          true,
      requestSoundPermission:
          true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android:
          initializationSettingsAndroid,
      iOS:
          initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (
        NotificationResponse details,
      ) {
        // Handle notification tapped logic here
      },
    );
  }

  Future<
    void
  >
  _loadMedications() async {
    setState(
      () {
        isLoading =
            true;
      },
    );

    final prefs =
        await SharedPreferences.getInstance();
    final medicationsJson =
        prefs.getStringList(
          'medications',
        ) ??
        [];

    setState(
      () {
        medications =
            medicationsJson
                .map(
                  (
                    json,
                  ) => Medication.fromJson(
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
  _saveMedications() async {
    final prefs =
        await SharedPreferences.getInstance();
    final medicationsJson =
        medications
            .map(
              (
                medication,
              ) => jsonEncode(
                medication.toJson(),
              ),
            )
            .toList();

    await prefs.setStringList(
      'medications',
      medicationsJson,
    );
    _scheduleAllNotifications();
  }

  Future<
    void
  >
  _scheduleAllNotifications() async {
    // Cancel all previous notifications
    await flutterLocalNotificationsPlugin.cancelAll();

    // Schedule new notifications for each medication
    for (final medication in medications) {
      _scheduleMedicationNotifications(
        medication,
      );
    }
  }

  Future<
    void
  >
  _scheduleMedicationNotifications(
    Medication medication,
  ) async {
    // Get current date for scheduling
    final now =
        DateTime.now();

    // Schedule for each selected day of the week
    for (
      int i = 0;
      i <
          medication.daysOfWeek.length;
      i++
    ) {
      if (medication.daysOfWeek[i]) {
        // Calculate the next occurrence of this day
        int daysToAdd =
            (i +
                1 -
                now.weekday) %
            7;
        if (daysToAdd ==
            0) {
          // If it's today, check if the time has already passed
          final medicationTime = DateTime(
            now.year,
            now.month,
            now.day,
            medication.time.hour,
            medication.time.minute,
          );

          if (medicationTime.isBefore(
            now,
          )) {
            daysToAdd =
                7; // Schedule for next week
          }
        }

        // Create the scheduled date
        final scheduledDate = DateTime(
          now.year,
          now.month,
          now.day +
              daysToAdd,
          medication.time.hour,
          medication.time.minute,
        );

        // Schedule the notification
        await _scheduleNotification(
          id: int.parse(
            '${medication.id}$i',
          ),
          title:
              'Medication Reminder',
          body:
              'Time to take ${medication.name} - ${medication.dosage}',
          scheduledDate:
              scheduledDate,
          weekly:
              true,
        );
      }
    }
  }

  Future<
    void
  >
  _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    bool weekly =
        false,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'medication_channel',
      'Medication Reminders',
      channelDescription:
          'Notifications for medication reminders',
      importance:
          Importance.high,
      priority:
          Priority.high,
      sound: RawResourceAndroidNotificationSound(
        'notification_sound',
      ),
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      sound:
          'notification_sound.aiff',
      presentAlert:
          true,
      presentBadge:
          true,
      presentSound:
          true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android:
          androidDetails,
      iOS:
          iosDetails,
    );

    if (weekly) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledDate,
          tz.local,
        ),
        notificationDetails,
        androidScheduleMode:
            AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
            DateTimeComponents.dayOfWeekAndTime,
      );
    } else {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledDate,
          tz.local,
        ),
        notificationDetails,
        androidScheduleMode:
            AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  void _addMedication() async {
    final added =
        await _showMedicationDialog();
    if (added) {
      setState(
        () {},
      );
    }
  }

  void _editMedication(
    Medication medication,
  ) async {
    final edited = await _showMedicationDialog(
      medication:
          medication,
    );
    if (edited) {
      setState(
        () {},
      );
    }
  }

  void _deleteMedication(
    String id,
  ) async {
    setState(
      () {
        medications.removeWhere(
          (
            medication,
          ) =>
              medication.id ==
              id,
        );
      },
    );
    await _saveMedications();
  }

  Future<
    bool
  >
  _showMedicationDialog({
    Medication? medication,
  }) async {
    final bool isEditing =
        medication !=
        null;
    final nameController = TextEditingController(
      text:
          isEditing
              ? medication.name
              : '',
    );
    final dosageController = TextEditingController(
      text:
          isEditing
              ? medication.dosage
              : '',
    );
    final notesController = TextEditingController(
      text:
          isEditing
              ? medication.notes
              : '',
    );

    TimeOfDay selectedTime =
        isEditing
            ? medication.time
            : TimeOfDay.now();
    List<
      bool
    >
    selectedDays =
        isEditing
            ? List<
              bool
            >.from(
              medication.daysOfWeek,
            )
            : List.generate(
              7,
              (
                _,
              ) =>
                  false,
            );

    bool medicationAdded =
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
                    ? 'Edit Medication'
                    : 'Add Medication',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    TextField(
                      controller:
                          nameController,
                      decoration: const InputDecoration(
                        labelText:
                            'Medication Name*',
                        border:
                            OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height:
                          16,
                    ),
                    TextField(
                      controller:
                          dosageController,
                      decoration: const InputDecoration(
                        labelText:
                            'Dosage*',
                        border:
                            OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height:
                          16,
                    ),
                    ListTile(
                      title: const Text(
                        'Time*',
                      ),
                      subtitle: Text(
                        '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                      ),
                      trailing: const Icon(
                        Icons.access_time,
                      ),
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context:
                              context,
                          initialTime:
                              selectedTime,
                        );
                        if (pickedTime !=
                            null) {
                          setDialogState(
                            () {
                              selectedTime =
                                  pickedTime;
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height:
                          16,
                    ),
                    const Text(
                      'Days of Week*',
                    ),
                    const SizedBox(
                      height:
                          8,
                    ),
                    Wrap(
                      spacing:
                          8,
                      children: [
                        for (
                          int i = 0;
                          i <
                              7;
                          i++
                        )
                          FilterChip(
                            label: Text(
                              [
                                'M',
                                'T',
                                'W',
                                'T',
                                'F',
                                'S',
                                'S',
                              ][i],
                            ),
                            selected:
                                selectedDays[i],
                            onSelected: (
                              selected,
                            ) {
                              setDialogState(
                                () {
                                  selectedDays[i] =
                                      selected;
                                },
                              );
                            },
                          ),
                      ],
                    ),
                    const SizedBox(
                      height:
                          16,
                    ),
                    TextField(
                      controller:
                          notesController,
                      maxLines:
                          3,
                      decoration: const InputDecoration(
                        labelText:
                            'Notes (Optional)',
                        border:
                            OutlineInputBorder(),
                      ),
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
                    if (nameController.text.isEmpty ||
                        dosageController.text.isEmpty) {
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

                    if (!selectedDays.contains(
                      true,
                    )) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please select at least one day',
                          ),
                        ),
                      );
                      return;
                    }

                    final newMedication = Medication(
                      id:
                          isEditing
                              ? medication.id
                              : DateTime.now().millisecondsSinceEpoch.toString(),
                      name:
                          nameController.text,
                      dosage:
                          dosageController.text,
                      time:
                          selectedTime,
                      daysOfWeek:
                          selectedDays,
                      notes:
                          notesController.text,
                    );

                    // Update the medications list in the parent widget's state
                    if (isEditing) {
                      final index = medications.indexWhere(
                        (
                          m,
                        ) =>
                            m.id ==
                            medication.id,
                      );
                      if (index !=
                          -1) {
                        setState(
                          () {
                            medications[index] =
                                newMedication;
                          },
                        );
                      }
                    } else {
                      setState(
                        () {
                          medications.add(
                            newMedication,
                          );
                        },
                      );
                    }

                    await _saveMedications();

                    medicationAdded =
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

    return medicationAdded;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medication Schedule',
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
              : medications.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.medication_outlined,
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
                      'No medications scheduled',
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
                          _addMedication,
                      icon: const Icon(
                        Icons.add,
                      ),
                      label: const Text(
                        'Add Medication',
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
              : ListView.builder(
                padding: const EdgeInsets.all(
                  16,
                ),
                itemCount:
                    medications.length,
                itemBuilder: (
                  context,
                  index,
                ) {
                  final medication =
                      medications[index];
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
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  medication.name,
                                  style: const TextStyle(
                                    fontSize:
                                        18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                    ),
                                    onPressed:
                                        () => _editMedication(
                                          medication,
                                        ),
                                    tooltip:
                                        'Edit',
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                    ),
                                    onPressed:
                                        () => _deleteMedication(
                                          medication.id,
                                        ),
                                    tooltip:
                                        'Delete',
                                    color:
                                        Colors.red,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              const Icon(
                                Icons.medication,
                                size:
                                    20,
                              ),
                              const SizedBox(
                                width:
                                    8,
                              ),
                              Text(
                                'Dosage: ${medication.dosage}',
                                style: const TextStyle(
                                  fontSize:
                                      16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height:
                                8,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size:
                                    20,
                              ),
                              const SizedBox(
                                width:
                                    8,
                              ),
                              Text(
                                'Time: ${medication.getTimeString()}',
                                style: const TextStyle(
                                  fontSize:
                                      16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height:
                                8,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size:
                                    20,
                              ),
                              const SizedBox(
                                width:
                                    8,
                              ),
                              Expanded(
                                child: Text(
                                  'Days: ${medication.getDaysString()}',
                                  style: const TextStyle(
                                    fontSize:
                                        16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (medication.notes.isNotEmpty) ...[
                            const SizedBox(
                              height:
                                  8,
                            ),
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.note,
                                  size:
                                      20,
                                ),
                                const SizedBox(
                                  width:
                                      8,
                                ),
                                Expanded(
                                  child: Text(
                                    'Notes: ${medication.notes}',
                                    style: const TextStyle(
                                      fontSize:
                                          16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton:
          medications.isEmpty
              ? null
              : FloatingActionButton(
                onPressed:
                    _addMedication,
                child: const Icon(
                  Icons.add,
                ),
              ),
    );
  }
}
