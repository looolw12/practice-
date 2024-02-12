import 'package:flutter/material.dart';
import 'widgets/audio_timer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dry Fire Par Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioTimer(),
    );
  }
}
