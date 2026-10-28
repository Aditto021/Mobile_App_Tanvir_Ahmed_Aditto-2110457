import 'package:flutter/material.dart';

import '../utils/validators.dart';
import '../widgets/birth_date_field.dart';
import '../widgets/country_search_field.dart';
import '../widgets/gender_radio_field.dart';
import '../widgets/password_input_widget.dart';
import '../widgets/section_title.dart';
import '../widgets/simple_input_widget.dart';

// Part 1: User Registration Form
class RegistrationFormPage extends StatefulWidget {
  const RegistrationFormPage({super.key});

  @override
  State<RegistrationFormPage> createState() => _RegistrationFormPageState();
}

class _RegistrationFormPageState extends State<RegistrationFormPage> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final nidController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final countryController = TextEditingController();
  final birthDateController = TextEditingController();

  String? gender;
  DateTime? birthDate;
  final List<String> interestOptions = [
    'Sports',
    'Music',
    'Reading',
    'Travel',
    'Gaming',
    'Coding',
  ];
  final List<String> selectedInterests = [];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    ageController.dispose();
    nidController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    countryController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Successful 🎉'),
          content: Text(
            'Name: ${nameController.text}\n'
            'Email: ${emailController.text}\n'
            'Phone: ${phoneController.text}\n'
            'Age: ${ageController.text}\n'
            'NID: ${nidController.text}\n'
            'Country: ${countryController.text}\n'
            'Gender: $gender\n'
            'Birth Date: ${birthDateController.text}\n'
            'Interests: ${selectedInterests.join(', ')}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in red'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Registration')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SectionTitle('Personal Information'),
            SimpleInputWidget(
              controller: nameController,
              labelText: 'Full Name',
              hintText: 'e.g. Tanvir Ahmed',
              prefixIcon: Icons.person,
              validator: Validators.nameValidator,
            ),
            SimpleInputWidget(
              controller: emailController,
              labelText: 'Email',
              hintText: 'e.g. name@gmail.com',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.emailValidation,
            ),
            SimpleInputWidget(
              controller: phoneController,
              labelText: 'Phone Number',
              hintText: 'e.g. 01712345678',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: Validators.bangladeshNumberValidator,
            ),
            SimpleInputWidget(
              controller: ageController,
              labelText: 'Age',
              hintText: 'e.g. 22',
              prefixIcon: Icons.numbers,
              keyboardType: TextInputType.number,
              validator: Validators.ageValidator,
            ),
            SimpleInputWidget(
              controller: nidController,
              labelText: 'NID Number',
              hintText: '10, 13 or 17 digits',
              prefixIcon: Icons.badge,
              keyboardType: TextInputType.number,
              validator: Validators.nidValidator,
            ),
            BirthDateField(
              controller: birthDateController,
              selectedDate: birthDate,
              onDatePicked: (date) => setState(() => birthDate = date),
            ),
            GenderRadioField(
              value: gender,
              onChanged: (value) => setState(() => gender = value),
            ),
            CountrySearchField(controller: countryController),
            const SectionTitle('Interests'),
            buildInterests(),
            const SectionTitle('Password'),
            PasswordField(
              controller: passwordController,
              showStrength: true,
              validator: Validators.passwordValidator,
            ),
            PasswordField(
              controller: confirmPasswordController,
              labelText: 'Confirm Password',
              validator: (value) => Validators.confirmPasswordValidator(
                passwordController.text,
                value,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: submitForm,
                icon: const Icon(Icons.check),
                label: const Text('Register', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Interest checkboxes; at least one must be ticked.
  Widget buildInterests() {
    return FormField<List<String>>(
      validator: (_) => selectedInterests.isEmpty
          ? 'Please pick at least one interest'
          : null,
      builder: (field) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: interestOptions.map((interest) {
                  return SizedBox(
                    width: 160,
                    child: CheckboxListTile(
                      title: Text(interest),
                      value: selectedInterests.contains(interest),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            selectedInterests.add(interest);
                          } else {
                            selectedInterests.remove(interest);
                          }
                        });
                        field.didChange(selectedInterests);
                      },
                    ),
                  );
                }).toList(),
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
