import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuizScreen extends StatefulWidget {
  final int questionsCount;
  final String categoryId;
  final String difficulty;
  final String type;

  QuizScreen({
    required this.questionsCount,
    required this.categoryId,
    required this.difficulty,
    required this.type,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Map<String, dynamic>> questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  String _feedback = '';
  int _timeLeft = 10;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _startTimer();
  }

  Future<void> _loadQuestions() async {
    final url =
        'https://opentdb.com/api.php?amount=${widget.questionsCount}&category=${widget.categoryId}&difficulty=${widget.difficulty}&type=${widget.type}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        questions = List<Map<String, dynamic>>.from(data['results']);
      });
    } else {
      print('Failed to fetch questions');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0 && !_answered) {
        setState(() {
          _timeLeft--;
        });
      } else if (_timeLeft == 0 && !_answered) {
        setState(() {
          _answered = true;
          _feedback =
              'Time\'s up! Correct answer: ${questions[_currentQuestionIndex]['correct_answer']}';
        });
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.questionsCount - 1) {
      setState(() {
        _currentQuestionIndex++;
        _timeLeft = 10;
        _answered = false;
        _feedback = '';
      });
    } else {
      Navigator.pushReplacementNamed(context, '/result', arguments: _score);
    }
  }

  void _checkAnswer(String answer) {
    setState(() {
      _answered = true;
      if (answer == questions[_currentQuestionIndex]['correct_answer']) {
        _score++;
        _feedback = 'Correct!';
      } else {
        _feedback =
            'Incorrect! Correct answer: ${questions[_currentQuestionIndex]['correct_answer']}';
      }
    });
    _nextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
          backgroundColor: Colors.blueAccent, // New AppBar Color
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    var currentQuestion = questions[_currentQuestionIndex];
    List<String> answers = List.from(currentQuestion['incorrect_answers']);
    answers.add(currentQuestion['correct_answer']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentQuestionIndex + 1}'),
        backgroundColor: Colors.blueAccent, // Updated AppBar color
        foregroundColor: Colors.white, // White text on AppBar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Display
            Text(
              currentQuestion['question'],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Darker color for question text
              ),
            ),
            SizedBox(height: 20),

            // Answer Buttons
            ...answers.map((answer) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent, // Orange for buttons
                    foregroundColor: Colors.white, // White text on button
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _answered
                      ? null
                      : () {
                          _checkAnswer(answer);
                        },
                  child: Text(
                    answer,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            }).toList(),

            // Feedback Display
            SizedBox(height: 20),
            Text(
              _feedback,
              style: TextStyle(
                fontSize: 18,
                color: _feedback.contains('Correct') ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 20),

            // Timer
            Text(
              'Time Left: $_timeLeft seconds',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Progress Bar
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.questionsCount,
              backgroundColor: Colors.grey[200], // Light grey background for the progress bar
              color: Colors.blueAccent, // Blue color for the progress bar
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
