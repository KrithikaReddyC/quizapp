import 'package:flutter/material.dart';
import 'quiz_setup_screen.dart';
import 'quiz_screen.dart';
import 'result_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/setup',
      routes: {
        '/setup': (context) => QuizSetupScreen(),
        '/quiz': (context) {
          // Fetch arguments and ensure that all values are correctly passed as the correct types
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;

          // Ensure the categoryId is a String (it is passed as a String from the setup screen)
          return QuizScreen(
            questionsCount: args['questionsCount'] as int,
            categoryId:
                args['categoryId'] as String, // Treat categoryId as String
            difficulty: args['difficulty'] as String,
            type: args['type'] as String,
          );
        },
        '/result': (context) {
          final score = ModalRoute.of(context)!.settings.arguments as int;
          return ResultScreen(score: score);
        },
      },
    );
  }
}