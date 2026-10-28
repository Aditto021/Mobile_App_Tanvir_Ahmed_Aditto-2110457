import 'package:flutter/material.dart';

import '../utils/date_helper.dart';

// Read-only field that opens a date picker when tapped.
class BirthDateField extends StatelessWidget {
  final TextEditingController controller;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDatePicked;

  const BirthDateField({
    super.key,
    required this.controller,
    required this.selectedDate,
    required this.onDatePicked,
  });

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select your birth date',
    );
    if (picked != null) {
      controller.text = formatDate(picked);
      onDatePicked(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () => _pickDate(context),
        decoration: InputDecoration(
          labelText: 'Birth Date',
          hintText: 'Tap to pick a date',
          prefixIcon: const Icon(Icons.cake),
          suffixIcon: const Icon(Icons.calendar_month),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (_) {
          if (selectedDate == null) {
            return 'Birth date is required';
          }
          if (ageFromBirthDate(selectedDate!) < 13) {
            return 'You must be at least 13 years old';
          }
          return null;
        },
      ),
    );
  }
}
