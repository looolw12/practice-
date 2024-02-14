import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  final TextEditingController delayController;
  final TextEditingController parController;
  final TextEditingController repeatsController;
  final bool randomizeDelay;
  final bool isRunning;
  final void Function(bool?)? onRandomizeDelayChanged;

  const TextFields({
    Key? key,
    required this.delayController,
    required this.parController,
    required this.repeatsController,
    required this.randomizeDelay,
    required this.isRunning,
    required this.onRandomizeDelayChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTextField(
          label: 'Delay time:',
          hintText: 'Enter delay time in seconds',
          controller: delayController,
        ),
        _buildTextField(
          label: 'Par time:',
          hintText: 'Enter par time in seconds',
          controller: parController,
        ),
        _buildTextField(
          label: 'Repeats:',
          hintText: 'Enter number of repeats',
          controller: repeatsController,
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

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16, // Adjust font size as necessary
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
