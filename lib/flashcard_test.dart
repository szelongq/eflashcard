import 'package:flutter/material.dart';

class FlashcardTest extends StatefulWidget {
  String answer = "";

  FlashcardTest({Key? key}) : super(key: key);

  @override
  State<FlashcardTest> createState() => _FlashcardTestState();
}

class _FlashcardTestState extends State<FlashcardTest> {
  String result = "";
  Color resultColor = Colors.green;

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SizedBox(
        width: 250,
        child: TextField(
          controller: _controller,
          onSubmitted: (String input) async {
            checkAnswer(input);
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Your Answer',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          result,
          style: TextStyle(
            color: resultColor,
            fontSize: 24.0,
          ),
        ),
      ),
    ]);
  }

  // Runs whenever input is submitted from the TextField
  void checkAnswer(String input) {
    print("Entered: " + input + " Answer: " + widget.answer);
    if (input == widget.answer) {
      setState(() {
        result = "Correct!";
        resultColor = Colors.green;
      });
    } else {
      setState(() {
        result = "Incorrect, try again.";
        resultColor = Colors.red;
      });
    }
  }

  void resetAnswer() {
    setState(() {
      _controller.clear();
      result = "";
    });
  }
}
