import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Questionnaire',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MentalHealthScreen(),
    );
  }
}

class MentalHealthScreen extends StatelessWidget {
  const MentalHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Questionnaire'),
      ),
      body: QuestionnaireHomePage(),
    );
  }
}

class QuestionnaireHomePage extends StatefulWidget {
  const QuestionnaireHomePage({super.key});

  @override
  _QuestionnaireHomePageState createState() => _QuestionnaireHomePageState();
}

class _QuestionnaireHomePageState extends State<QuestionnaireHomePage> {
  final List<String> categories = [
    'General',
    'Kidney',
    'Liver',
    'Lungs',
    'Pancreas',
    'Heart',
    'Cornea',
  ];

  final Map<String, Map<String, List<QuestionAnswer>>> categoryQuestions = {
    'General': {
      'More than a month': [
        QuestionAnswer(
          question: "Select ongoing health concerns",
          answers: [
            "Chronic fatigue",
            "Persistent pain",
            "Sleep disturbances",
            "Mood changes",
            "Weight fluctuations",
          ],
        ),
      ],
      'Less than a month': [
        QuestionAnswer(
          question: "Recent health symptoms",
          answers: [
            "Sudden fever",
            "Unexpected weight loss",
            "New skin rash",
            "Digestive issues",
            "Unexplained headaches",
          ],
        ),
      ],
    },
    // Add other categories similarly
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Questionnaire'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(categories[index]),
            children: [
              if (categories[index] == 'General')
                Column(
                  children: _buildGeneralQuestionWidgets(
                    categoryQuestions['General']?['More than a month'] ?? []
                  ),
                )
              else
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Has the condition been present for more than a month?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _navigateToQuestionPage(
                              context, 
                              categories[index], 
                              'More than a month'
                            );
                          },
                          child: Text('Yes'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _navigateToQuestionPage(
                              context, 
                              categories[index], 
                              'Less than a month'
                            );
                          },
                          child: Text('No'),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToQuestionPage(BuildContext context, String category, String timePeriod) {
    // Safely access the questions
    final questions = categoryQuestions[category]?[timePeriod];
    if (questions != null && questions.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionPage(
            category: category,
            questions: questions,
            timePeriod: timePeriod,
          ),
        ),
      );
    } else {
      // Show an error or handle the case of no questions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No questions available for this category.'))
      );
    }
  }

  List<Widget> _buildGeneralQuestionWidgets(List<QuestionAnswer> questions) {
    return questions.map((qa) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              qa.question,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionPage(
                      category: 'General',
                      questions: [qa],
                      timePeriod: 'More than a month',
                    ),
                  ),
                );
              },
              child: Text('Proceed to Questionnaire'),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class QuestionPage extends StatefulWidget {
  final String category;
  final List<QuestionAnswer> questions;
  final String timePeriod;

  const QuestionPage({
    super.key,
    required this.category,
    required this.questions,
    required this.timePeriod,
  });

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late Map<String, List<String>> selectedAnswers;

  @override
  void initState() {
    super.initState();
    // Initialize selectedAnswers with empty lists for each question
    selectedAnswers = {
      for (var question in widget.questions)
        question.question: []
    };
  }

  void _analyzeHealthSeverity() {
    int totalSelectedOptions = selectedAnswers.values
        .fold(0, (total, answers) => total + answers.length);

    String severityMessage;
    Color severityColor;

    if (totalSelectedOptions == 0) {
      severityMessage = "No health concerns detected.";
      severityColor = Colors.green;
    } else if (totalSelectedOptions <= 2) {
      severityMessage = "Low severity. Mild health concerns.";
      severityColor = Colors.green;
    } else if (totalSelectedOptions <= 4) {
      severityMessage = "Moderate severity. Consult a healthcare professional.";
      severityColor = Colors.orange;
    } else {
      severityMessage = "High severity. Immediate medical attention recommended.";
      severityColor = Colors.red;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Health Severity Analysis'),
          content: Text(
            severityMessage,
            style: TextStyle(color: severityColor),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Questionnaire'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Time Period: ${widget.timePeriod}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                ...widget.questions.map((qa) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          qa.question,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...qa.answers.map((answer) {
                          return CheckboxListTile(
                            title: Text(answer),
                            value: selectedAnswers[qa.question]!.contains(answer),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedAnswers[qa.question]!.add(answer);
                                } else {
                                  selectedAnswers[qa.question]!.remove(answer);
                                }
                              });
                            },
                          );
                        }),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _analyzeHealthSeverity,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Analyze Health Severity'),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionAnswer {
  final String question;
  final List<String> answers;

  const QuestionAnswer({
    required this.question,
    required this.answers,
  });
}