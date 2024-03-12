import 'package:flutter/material.dart';

class TextFields extends StatefulWidget {
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
  _TextFieldsState createState() => _TextFieldsState();
}

class _TextFieldsState extends State<TextFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTextField(
          label: 'Delay time:',
          hintText: 'Enter delay time in seconds',
          controller: widget.delayController,
          step: 0.25,
          readOnly: true,
        ),
        _buildTextField(
          label: 'Par time:',
          hintText: 'Enter par time in seconds',
          controller: widget.parController,
          step: 0.25,
          readOnly: true,
        ),
        _buildTextField(
          label: 'Repeats:',
          hintText: 'Enter number of repeats',
          controller: widget.repeatsController,
          step: 1, // Step should be integer for repeats
          readOnly: true,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: widget.randomizeDelay,
              onChanged: widget.onRandomizeDelayChanged,
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
    required double step,
    bool readOnly = false,
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
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _decrementValue(controller, step);
                },
                icon: const Icon(Icons.remove),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _ensureNonNegativeValue(controller);
                  },
                  readOnly: readOnly,
                ),
              ),
              IconButton(
                onPressed: () {
                  _incrementValue(controller, step);
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _ensureNonNegativeValue(TextEditingController controller) {
    final double? parsedValue = double.tryParse(controller.text);
    if (parsedValue != null && parsedValue < 0) {
      controller.text = '0';
    }
  }

  void _incrementValue(TextEditingController controller, double step) {
    final double value = (double.tryParse(controller.text) ?? 0) + step;
    controller.text = value.toStringAsFixed(2);
  }

  void _decrementValue(TextEditingController controller, double step) {
    final double value = (double.tryParse(controller.text) ?? 0) - step;
    if (value >= 0) {
      controller.text = value.toStringAsFixed(2);
    }
  }
}
