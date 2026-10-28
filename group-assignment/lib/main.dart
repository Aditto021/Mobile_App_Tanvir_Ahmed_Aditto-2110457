import 'package:flutter/material.dart';

import 'screens/form_wizard_page.dart';
import 'screens/registration_form_page.dart';

void main() {
  runApp(const FormApp());
}

class FormApp extends StatelessWidget {
  const FormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project 1: Forms with Validation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/register': (context) => const RegistrationFormPage(),
        '/wizard': (context) => const FormWizardPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project 1: Forms with Validation')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          ProjectCard(
            number: 1,
            title: 'User Registration Form',
            subtitle: 'All fields with complete validation',
            icon: Icons.app_registration,
            route: '/register',
          ),
          ProjectCard(
            number: 2,
            title: 'Multi-Step Form Wizard',
            subtitle: '4 steps, progress bar and save draft',
            icon: Icons.linear_scale,
            route: '/wizard',
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final int number;
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  const ProjectCard({
    super.key,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          child: Icon(icon),
        ),
        title: Text(
          'Part $number: $title',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
