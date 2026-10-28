import 'package:flutter/material.dart';

import '../utils/countries.dart';

// A country field with search: type a few letters and pick from the list.
// Uses Flutter's built-in Autocomplete widget (no extra packages).
class CountrySearchField extends StatelessWidget {
  final TextEditingController controller;

  const CountrySearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Autocomplete<String>(
        initialValue: TextEditingValue(text: controller.text),
        optionsBuilder: (TextEditingValue value) {
          if (value.text.isEmpty) {
            return countries;
          }
          return countries.where(
            (country) =>
                country.toLowerCase().contains(value.text.toLowerCase()),
          );
        },
        onSelected: (String country) {
          controller.text = country;
        },
        fieldViewBuilder: (context, fieldController, focusNode, onSubmit) {
          return TextFormField(
            controller: fieldController,
            focusNode: focusNode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) => controller.text = value,
            decoration: InputDecoration(
              labelText: 'Country',
              hintText: 'Type to search...',
              prefixIcon: const Icon(Icons.public),
              suffixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Country is required';
              }
              if (!countries.contains(value)) {
                return 'Please pick a country from the list';
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
