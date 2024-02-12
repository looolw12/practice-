import 'package:flutter/material.dart';

class AudioControls extends StatelessWidget {
  final bool isRunning;
  final Function() stopTimer;
  final Function() startTimer;

  const AudioControls({
    required this.isRunning,
    required this.stopTimer,
    required this.startTimer,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isRunning ? stopTimer : startTimer,
      child: Text(isRunning ? 'Stop' : 'Start'),
    );
  }
}
