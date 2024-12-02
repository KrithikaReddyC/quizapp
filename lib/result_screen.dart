import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;

  ResultScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Finished'),
        backgroundColor: Color(0xFF8B4513),
        foregroundColor:
            Color.fromARGB(255, 255, 255, 255), // Dark brown color for app bar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align the content at the top
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            // Highlighted Score Circle at the top
            Container(
              decoration: BoxDecoration(
                color:
                    Color(0xFF8B4513), // Dark brown background for the circle
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(30.0),
              child: Text(
                '$score', // Display the score
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Score text, now below the circle
            Text(
              'Your Score',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4E3629), // Lighter brown color for the text
              ),
            ),
            SizedBox(height: 40),

            // Centered Option Buttons
            Spacer(), // Pushes the buttons down to the center
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B4513), // Dark brown button
                foregroundColor: Colors.white, // White text on button
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/setup');
              },
              child: Text('Go to Setup'),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color(0xFF8B4513), // Medium brown for the retry button
                foregroundColor: Colors.white, // White text on button
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/quiz',
                  arguments: {
                    'questionsCount': 5,
                    'categoryId': '9',
                    'difficulty': 'medium',
                    'type': 'multiple',
                  },
                );
              },
              child: Text('Retry Quiz'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}