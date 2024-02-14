import 'package:flutter/material.dart';

class AudioControls extends StatelessWidget {
  final bool isRunning;
  final Function() stopTimer;
  final Function() startTimer;

  const AudioControls({
    Key? key,
    required this.isRunning,
    required this.stopTimer,
    required this.startTimer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Make button as wide as its parent
      child: ElevatedButton(
        onPressed: isRunning ? stopTimer : startTimer,
        style: ElevatedButton.styleFrom(
          primary: Colors.blue, // Set button color to blue
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding to the button text
          child: Text(
            isRunning ? 'Stop' : 'Start',
            style: const TextStyle(
              fontSize: 20, // Increase font size for better visibility
              color: Colors.white, // Set text color to white
            ),
          ),
        ),
      ),
    );
  }
}
