import 'package:flutter/material.dart';

import '../utils/validators.dart';

// Password field with a show/hide button and an optional strength bar.
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool showStrength;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    required this.controller,
    this.labelText = 'Password',
    this.showStrength = false,
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (_) => setState(() {}), // redraw the strength bar
            decoration: InputDecoration(
              labelText: widget.labelText,
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: widget.validator,
          ),
          if (widget.showStrength) _buildStrengthBar(),
        ],
      ),
    );
  }

  Widget _buildStrengthBar() {
    final int score = Validators.passwordStrength(widget.controller.text);

    String label = 'Too weak';
    Color color = Colors.red;
    if (widget.controller.text.isEmpty) {
      label = '-';
      color = Colors.grey;
    } else if (score >= 5) {
      label = 'Strong';
      color = Colors.green;
    } else if (score >= 3) {
      label = 'Medium';
      color = Colors.orange;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: score / 5,
              minHeight: 6,
              color: color,
              backgroundColor: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Strength: $label',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
