import 'package:flutter/material.dart';

import '../utils/date_helper.dart';
import '../utils/draft_storage.dart';
import '../utils/validators.dart';
import '../widgets/birth_date_field.dart';
import '../widgets/country_search_field.dart';
import '../widgets/gender_radio_field.dart';
import '../widgets/section_title.dart';
import '../widgets/simple_input_widget.dart';

// Part 2: Multi-Step Form Wizard
class FormWizardPage extends StatefulWidget {
  const FormWizardPage({super.key});

  @override
  State<FormWizardPage> createState() => _FormWizardPageState();
}

class _FormWizardPageState extends State<FormWizardPage> {
  final List<String> stepTitles = [
    'Personal',
    'Contact',
    'Preferences',
    'Review',
  ];
  int currentStep = 0;

  // One form key for each step that has inputs (steps 1-3).
  final List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // Step 1: Personal Information
  final nameController = TextEditingController();
  final birthDateController = TextEditingController();
  DateTime? birthDate;
  String? gender;

  // Step 2: Contact Details
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  // Step 3: Preferences & Settings
  final countryController = TextEditingController();
  final List<String> languages = ['English', 'Bangla', 'Hindi', 'Arabic'];
  String? language;
  bool notifications = true;
  bool newsletter = false;

  @override
  void initState() {
    super.initState();
    if (DraftStorage.hasDraft) {
      loadDraft();
      // Show the message after the first frame is drawn.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showMessage('Draft restored — continue where you left off');
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    birthDateController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    countryController.dispose();
    super.dispose();
  }

  // ---------- Draft ----------

  void saveDraft() {
    DraftStorage.save({
      'step': currentStep,
      'name': nameController.text,
      'birthDate': birthDate,
      'gender': gender,
      'email': emailController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'country': countryController.text,
      'language': language,
      'notifications': notifications,
      'newsletter': newsletter,
    });
    showMessage('Draft saved ✔');
  }

  void loadDraft() {
    final draft = DraftStorage.load()!;
    currentStep = draft['step'];
    nameController.text = draft['name'];
    birthDate = draft['birthDate'];
    if (birthDate != null) {
      birthDateController.text = formatDate(birthDate!);
    }
    gender = draft['gender'];
    emailController.text = draft['email'];
    phoneController.text = draft['phone'];
    addressController.text = draft['address'];
    countryController.text = draft['country'];
    language = draft['language'];
    notifications = draft['notifications'];
    newsletter = draft['newsletter'];
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
    );
  }

  // ---------- Navigation ----------

  void goNext() {
    // Only move forward when the current step is valid.
    if (formKeys[currentStep].currentState!.validate()) {
      setState(() => currentStep++);
    } else {
      showMessage('Please fix the errors before continuing');
    }
  }

  void goBack() {
    setState(() => currentStep--);
  }

  void submit() {
    DraftStorage.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Submitted Successfully 🎉'),
        content: Text('Thank you, ${nameController.text}!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close the dialog
              Navigator.pop(this.context); // back to the home page
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Step Form'),
        actions: [
          TextButton.icon(
            onPressed: saveDraft,
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            icon: const Icon(Icons.save),
            label: const Text('Save Draft'),
          ),
        ],
      ),
      body: Column(
        children: [
          buildProgressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: buildCurrentStep(),
            ),
          ),
          buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          Row(
            children: List.generate(stepTitles.length, (index) {
              final bool isDone = index < currentStep;
              final bool isActive = index == currentStep;
              final Color color = isDone || isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade400;
              return Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      child: isDone
                          ? const Icon(Icons.check, size: 18)
                          : Text('${index + 1}'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stepTitles[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (currentStep + 1) / stepTitles.length,
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Step ${currentStep + 1} of ${stepTitles.length}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCurrentStep() {
    switch (currentStep) {
      case 0:
        return buildPersonalStep();
      case 1:
        return buildContactStep();
      case 2:
        return buildPreferencesStep();
      default:
        return buildReviewStep();
    }
  }

  Widget buildPersonalStep() {
    return Form(
      key: formKeys[0],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Step 1: Personal Information'),
          SimpleInputWidget(
            controller: nameController,
            labelText: 'Full Name',
            hintText: 'e.g. Tanvir Ahmed',
            prefixIcon: Icons.person,
            validator: Validators.nameValidator,
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
        ],
      ),
    );
  }

  Widget buildContactStep() {
    return Form(
      key: formKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Step 2: Contact Details'),
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
            controller: addressController,
            labelText: 'Address',
            hintText: 'House, road, area, city',
            prefixIcon: Icons.home,
            maxLines: 2,
            validator: (value) =>
                Validators.minLengthValidator(value, 5, 'Address'),
          ),
        ],
      ),
    );
  }

  Widget buildPreferencesStep() {
    return Form(
      key: formKeys[2],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Step 3: Preferences & Settings'),
          CountrySearchField(controller: countryController),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: DropdownButtonFormField<String>(
              initialValue: language,
              decoration: InputDecoration(
                labelText: 'Preferred Language',
                prefixIcon: const Icon(Icons.language),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: languages
                  .map(
                    (lang) => DropdownMenuItem(value: lang, child: Text(lang)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => language = value),
              validator: (value) =>
                  Validators.requiredValidator(value, 'Language'),
            ),
          ),
          SwitchListTile(
            title: const Text('Push notifications'),
            subtitle: const Text('Get updates about your account'),
            value: notifications,
            onChanged: (value) => setState(() => notifications = value),
          ),
          SwitchListTile(
            title: const Text('Email newsletter'),
            subtitle: const Text('Receive our monthly newsletter'),
            value: newsletter,
            onChanged: (value) => setState(() => newsletter = value),
          ),
        ],
      ),
    );
  }

  Widget buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle('Step 4: Review & Submit'),
        reviewCard('Personal Information', 0, {
          'Name': nameController.text,
          'Birth Date': birthDateController.text,
          'Gender': gender ?? '',
        }),
        reviewCard('Contact Details', 1, {
          'Email': emailController.text,
          'Phone': phoneController.text,
          'Address': addressController.text,
        }),
        reviewCard('Preferences & Settings', 2, {
          'Country': countryController.text,
          'Language': language ?? '',
          'Notifications': notifications ? 'On' : 'Off',
          'Newsletter': newsletter ? 'On' : 'Off',
        }),
      ],
    );
  }

  // A card listing one step's answers, with an Edit button to jump back.
  Widget reviewCard(String title, int step, Map<String, String> values) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => currentStep = step),
                  child: const Text('Edit'),
                ),
              ],
            ),
            ...values.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text(
                        '${entry.key}:',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                    Expanded(child: Text(entry.value)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavigationButtons() {
    final bool isFirst = currentStep == 0;
    final bool isLast = currentStep == stepTitles.length - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isFirst ? null : goBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isLast ? submit : goNext,
              icon: Icon(isLast ? Icons.send : Icons.arrow_forward),
              label: Text(isLast ? 'Submit' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}
