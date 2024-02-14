import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'audio_controls.dart'; // Import the AudioControls widget
import 'text_fields.dart'; // Import the TextFields widget

class AudioTimer extends StatefulWidget {
  @override
  _AudioTimerState createState() => _AudioTimerState();
}

class _AudioTimerState extends State<AudioTimer> {
  final player = AudioPlayer();
  TextEditingController delayController = TextEditingController();
  TextEditingController parController = TextEditingController();
  TextEditingController repeatsController = TextEditingController();
  bool randomizeDelay = false; // Flag to randomize delay time
  Timer? _timer;
  int _currentRepeat = 0;
  bool _isRunning = false;

  @override
  void dispose() {
    player.dispose();
    _timer?.cancel();
    delayController.dispose();
    parController.dispose();
    repeatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dry Fire Par Timer'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFields( // Render the text input fields
                delayController: delayController,
                parController: parController,
                repeatsController: repeatsController,
                randomizeDelay: randomizeDelay,
                isRunning: _isRunning,
                onRandomizeDelayChanged: _onRandomizeDelayChanged, // Callback function for randomize delay checkbox
              ),
              const SizedBox(height: 20),
              AudioControls( // Render the start/stop button
                isRunning: _isRunning,
                stopTimer: _stopTimer,
                startTimer: _startTimer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _playSound() async {
    await player.setAsset('assets/a.mp3');
    await player.play();
  }

  void _startTimer() {
    final delayTime = int.tryParse(delayController.text) ?? 0;
    final parTime = int.tryParse(parController.text) ?? 0;
    final repeats = int.tryParse(repeatsController.text) ?? 0;

    if (delayTime <= 0 || parTime <= 0 || repeats <= 0) {
      return;
    }

    _timer = Timer.periodic(Duration(seconds: delayTime), (timer) {
      if (randomizeDelay) { // Check if randomize delay flag is enabled
        final randomOffset = delayTime ~/ 4;
        final randomDelay = randomOffset != 0
            ? delayTime - randomOffset + (2 * randomOffset * DateTime.now().microsecondsSinceEpoch % randomOffset) ~/ 1000000
            : delayTime;
        timer.cancel();
        _timer = Timer.periodic(Duration(seconds: randomDelay), _timerCallback); // Set a timer with randomized delay
      } else {
        _timerCallback(timer);
      }
    });
    setState(() {
      _isRunning = true;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _timerCallback(Timer timer) {
    final parTime = int.tryParse(parController.text) ?? 0;
    final repeats = int.tryParse(repeatsController.text) ?? 0;

    if (_currentRepeat < repeats) {
      _playSound();
      _currentRepeat++;
      if (_currentRepeat <= repeats) {
        Future.delayed(Duration(seconds: parTime), () {
          _playSound();
        });
      }
    } else {
      Future.delayed(const Duration(seconds: 0), () {
        timer.cancel();
        _currentRepeat = 0;
        setState(() {
          _isRunning = false;
        });
      });
    }
  }

  void _onRandomizeDelayChanged(bool? value) { // Callback function for randomize delay checkbox
    setState(() {
      randomizeDelay = value ?? false; // Update randomizeDelay flag
    });
  }
}
