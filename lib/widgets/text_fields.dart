import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  final TextEditingController delayController;
  final TextEditingController parController;
  final TextEditingController repeatsController;
  final bool randomizeDelay;
  final bool isRunning;
  final void Function(bool?)? onRandomizeDelayChanged;

  TextFields({
    required this.delayController,
    required this.parController,
    required this.repeatsController,
    required this.randomizeDelay,
    required this.isRunning,
    required this.onRandomizeDelayChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Delay time:'),
            const SizedBox(width: 10),
            Flexible(
              child: TextField(
                controller: delayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter delay time in seconds',
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Par time:'),
            const SizedBox(width: 10),
            Flexible(
              child: TextField(
                controller: parController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter par time in seconds',
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Repeats:'),
            const SizedBox(width: 10),
            Flexible(
              child: TextField(
                controller: repeatsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter number of repeats',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: randomizeDelay,
              onChanged: onRandomizeDelayChanged,
            ),
            const Text('Randomize Delay time'),
          ],
        ),
      ],
    );
  }
}

