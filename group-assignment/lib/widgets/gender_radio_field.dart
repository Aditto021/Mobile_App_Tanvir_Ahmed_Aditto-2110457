import 'package:flutter/material.dart';

const List<String> genders = ['Male', 'Female', 'Other'];

// Gender radio buttons that show an error message when nothing is chosen.
class GenderRadioField extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const GenderRadioField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: value,
      validator: (_) => value == null ? 'Please select your gender' : null,
      builder: (field) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Gender', style: TextStyle(fontSize: 16)),
              RadioGroup<String>(
                groupValue: value,
                onChanged: (newValue) {
                  onChanged(newValue);
                  field.didChange(newValue);
                },
                child: Row(
                  children: genders.map((gender) {
                    return Expanded(
                      child: RadioListTile<String>(
                        value: gender,
                        title: Text(gender),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (field.hasError)
                Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
