import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Quiz Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

// HomeScreen - where the user can start the game
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Math Quiz Game"),
        backgroundColor: Colors.blueAccent,
        elevation: 10,
        shadowColor: Colors.blueGrey.withOpacity(0.5),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school,
                color: Colors.white,
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                "Welcome to Math Quiz!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: Colors.blueAccent.withOpacity(0.5),
                  elevation: 5,
                ),
                onPressed: () {
                  // Navigate to the GameScreen when pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen()),
                  );
                },
                child: Text(
                  "Start Game",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Let's test your math skills!",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// GameScreen - where the quiz logic happens
class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  int _level = 1;
  int _stars = 0;
  Map<String, dynamic> _currentQuestion = {};
  late AnimationController _controller;
  late Animation<double> _buttonAnimation; // Specify type as double

  @override
  void initState() {
    super.initState();
    _generateQuestion();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _buttonAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      // Use Tween<double> here
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _generateQuestion() {
    final question = generateQuestion(_level);
    setState(() {
      _currentQuestion = question;
    });
  }

  void _checkAnswer(int answer) {
    if (answer == _currentQuestion['correctAnswer']) {
      setState(() {
        _stars += 1;
      });
      _showFeedback("Correct!", Colors.green);
    } else {
      _showFeedback("Try Again", Colors.red);
    }
  }

  void _showFeedback(String message, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: color,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (message == "Correct!") {
                _level += 1;
                _generateQuestion();
              } else {
                _generateQuestion();
              }
            },
            child: Text("Next", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Level $_level"),
        backgroundColor: Colors.blueAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.yellow),
                Text(" $_stars", style: TextStyle(fontSize: 18)),
              ],
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Level Progress Bar
              LinearProgressIndicator(
                value: _level / 10,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
              ),
              SizedBox(height: 20),
              Text(
                _currentQuestion['question'],
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              ..._currentQuestion['answers'].map<Widget>((answer) {
                return ScaleTransition(
                  scale: _buttonAnimation,
                  child: AnswerButton(
                    answer: answer,
                    onPressed: () {
                      _controller.forward().then((value) {
                        _controller.reverse();
                      });
                      _checkAnswer(answer);
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget for answer options (buttons)
class AnswerButton extends StatelessWidget {
  final int answer;
  final VoidCallback onPressed;

  AnswerButton({required this.answer, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          "$answer",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          shadowColor: Colors.orangeAccent.withOpacity(0.5),
          elevation: 5,
        ),
      ),
    );
  }
}

// Function to generate a random question based on level and mixed operations
Map<String, dynamic> generateQuestion(int level) {
  int num1 = generateRandomNumber(level * 10);
  int num2 = generateRandomNumber(level * 10);

  // Randomly select the operation
  String operation = getRandomOperation();
  int correctAnswer;

  // Generate the problem based on the selected operation
  String question;
  switch (operation) {
    case 'add':
      correctAnswer = num1 + num2;
      question = "$num1 + $num2 = ?";
      break;
    case 'subtract':
      correctAnswer = num1 - num2;
      question = "$num1 - $num2 = ?";
      break;
    case 'multiply':
      correctAnswer = num1 * num2;
      question = "$num1 × $num2 = ?";
      break;
    case 'divide':
      correctAnswer = (num1 ~/ num2); // Integer division for simplicity
      question = "$num1 ÷ $num2 = ?";
      break;
    default:
      correctAnswer = num1 + num2;
      question = "$num1 + $num2 = ?";
  }

  // Generate wrong answers
  int wrongAnswer1 = correctAnswer + Random().nextInt(3) + 1;
  int wrongAnswer2 = correctAnswer - Random().nextInt(3) - 1;

  List<int> answers = [correctAnswer, wrongAnswer1, wrongAnswer2];
  answers.shuffle();

  return {
    "question": question,
    "answers": answers,
    "correctAnswer": correctAnswer,
  };
}

// Function to generate a random number (based on level)
int generateRandomNumber(int max) {
  return Random().nextInt(max) + 1;
}

// Function to get a random operation
String getRandomOperation() {
  List<String> operations = ['add', 'subtract', 'multiply', 'divide'];
  return operations[Random().nextInt(operations.length)];
}
