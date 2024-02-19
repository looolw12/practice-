import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
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

  Future<void> _playSound() async {
    var content = await rootBundle.load("assets/sound.mp3");
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/sound.mp3");
    file.writeAsBytesSync(content.buffer.asUint8List());

    await player.setFilePath(file.path);
    await player.play();
  }

  void _startTimer() {
    final delayTime = int.tryParse(delayController.text) ?? 0;
    final parTime = int.tryParse(parController.text) ?? 0;
    final repeats = int.tryParse(repeatsController.text) ?? 0;

    if (delayTime <= 0 || parTime <= 0 || repeats <= 0) {
      return;
    }

    _timer = Timer.periodic(Duration(seconds: delayTime + parTime), (timer) {
      _playSound();
      Future.delayed(Duration(seconds: parTime), () {
        _playSound();
      });
      _currentRepeat++;
      if (_currentRepeat >= repeats) {
        timer.cancel();
        _currentRepeat = 0;
        setState(() {
          _isRunning = false;
        });
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
      _playSound().then((_) {
        _currentRepeat++;
        if (_currentRepeat < repeats) { // Проверяем, есть ли еще повторы
          Future.delayed(Duration(seconds: parTime), () {
            _timerCallback(timer);
          });
        } else {
          Future.delayed(Duration(seconds: parTime), () {
            timer.cancel(); // Останавливаем таймер после последнего повтора
            _currentRepeat = 0;
            setState(() {
              _isRunning = false;
            });
          });
        }
      });
    }
  }

  void _onRandomizeDelayChanged(bool? value) { // Callback function for randomize delay checkbox
    setState(() {
      randomizeDelay = value ?? false; // Update randomizeDelay flag
    });
  }
}
