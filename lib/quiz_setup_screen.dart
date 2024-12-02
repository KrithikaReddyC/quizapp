import 'package:flutter/material.dart';
import 'api_service.dart';

class QuizSetupScreen extends StatefulWidget {
  @override
  _QuizSetupScreenState createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  int _questionsCount = 5;
  String _categoryId = '9'; // Default: General Knowledge (string id)
  String _difficulty = 'easy';
  String _type = 'multiple'; // 'multiple' or 'true/false'

  List<Map<String, dynamic>> categories = [];

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      List<Map<String, dynamic>> categoryList =
          await _apiService.getCategories();
      setState(() {
        categories = categoryList;
      });
    } catch (e) {
      print("Failed to load categories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Light gray background
      appBar: AppBar(
        backgroundColor: Color(0xFF8B4513), // Dark brown color
        title: Text(
          'Quiz Setup',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Count
              _buildSectionTitle('Questions'),
              _buildDropdown<int>(
                value: _questionsCount,
                items: [5, 10, 15],
                onChanged: (value) {
                  setState(() {
                    _questionsCount = value!;
                  });
                },
                label: 'Select Number of Questions',
              ),

              // Category
              _buildSectionTitle('Category'),
              categories.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : _buildDropdown<String>(
                      value: _categoryId,
                      items: categories.map((category) {
                        return category['id'].toString();
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _categoryId = value!;
                        });
                      },
                      label: 'Select Category',
                      displayItems: categories.map((category) {
                        return '${category['name']} (${category['id']})';
                      }).toList(),
                    ),

              // Difficulty Level
              _buildSectionTitle('Difficulty Level'),
              _buildDropdown<String>(
                value: _difficulty,
                items: ['easy', 'medium', 'hard'],
                onChanged: (value) {
                  setState(() {
                    _difficulty = value!;
                  });
                },
                label: 'Select Difficulty',
              ),

              // Question Type
              _buildSectionTitle('Question Type'),
              _buildDropdown<String>(
                value: _type,
                items: ['multiple', 'boolean'], // Change here
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
                label: 'Select Question Type',
              ),

              // Start Quiz Button
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B4513), // Brown color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Pass categoryId as String
                    Navigator.pushNamed(
                      context,
                      '/quiz',
                      arguments: {
                        'questionsCount': _questionsCount,
                        'categoryId': _categoryId, // categoryId is now String
                        'difficulty': _difficulty,
                        'type': _type, // Pass the updated type value
                      },
                    );
                  },
                  child: Text(
                    'Start Quiz',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Method: Build Dropdown with Labels
  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String label,
    List<String>? displayItems, // Optional display items for categories
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF8B4513), // Brown color for labels
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<T>>((T value) {
              int index = items.indexOf(value);
              String displayText =
                  displayItems != null && index < displayItems.length
                      ? displayItems[index]
                      : value.toString();
              return DropdownMenuItem<T>(
                value: value,
                child: Text(displayText),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Helper Method: Build Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8B4513), // Brown color for titles
        ),
      ),
    );
  }
}