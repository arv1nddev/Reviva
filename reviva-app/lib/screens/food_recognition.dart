import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class FoodRecognitionScreen extends StatefulWidget {
  const FoodRecognitionScreen({super.key});

  @override
  _FoodRecognitionScreenState createState() => _FoodRecognitionScreenState();
}

class _FoodRecognitionScreenState extends State<FoodRecognitionScreen> {
  File? _image;
  List<ImageLabel> _foodLabels = [];
  bool _isProcessing = false;

  final ImagePicker _picker = ImagePicker();
  late ImageLabeler _imageLabeler;

  // List of food-related labels
  final List<String> foodItems = [
    "Food", "Fruit", "Vegetable", "Pizza", "Burger", "Pasta", "Bread", "Salad", "Rice", 
    "Soup", "Sandwich", "Cheese", "Meat", "Chicken", "Fish", "Seafood", "Egg", "Sushi", 
    "Cake", "Dessert", "Beverage", "Coffee", "Tea", "Juice", "Alcohol", "Pauwa"
  ];

  @override
  void initState() {
    super.initState();
    _imageLabeler = ImageLabeler(options: ImageLabelerOptions());
  }

  @override
  void dispose() {
    _imageLabeler.close();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _isProcessing = true;
          _foodLabels.clear();
        });
        await _processImage();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _processImage() async {
    if (_image == null) return;

    try {
      final inputImage = InputImage.fromFile(_image!);
      final labels = await _imageLabeler.processImage(inputImage);

      setState(() {
        _foodLabels = labels.where((label) {
          return foodItems.contains(label.label);
        }).toList();
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Food Recognition", 
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Display Area
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[300]!),
                image: _image != null 
                  ? DecorationImage(
                      image: FileImage(_image!), 
                      fit: BoxFit.cover
                    )
                  : null,
              ),
              child: _image == null 
                ? Center(
                    child: Text(
                      'No image selected',
                      style: TextStyle(color: Colors.grey[600]),
                    )
                  )
                : null,
            ),
            SizedBox(height: 16),
            
            // Image Pick Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () => pickImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library),
                      label: Text('Gallery'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () => pickImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt),
                      label: Text('Camera'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Results or Loading
            Expanded(
              child: _isProcessing
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Processing image...',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    )
                  : _foodLabels.isNotEmpty
                      ? ListView.builder(
                          itemCount: _foodLabels.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(
                                  _foodLabels[index].label,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "Confidence: ${(_foodLabels[index].confidence * 100).toStringAsFixed(2)}%",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                leading: Icon(
                                  Icons.food_bank_outlined, 
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'No food items detected',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}