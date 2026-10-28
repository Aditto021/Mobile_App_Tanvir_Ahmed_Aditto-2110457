import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_app/main.dart';
import 'package:form_app/screens/form_wizard_page.dart';
import 'package:form_app/screens/registration_form_page.dart';
import 'package:form_app/utils/draft_storage.dart';

Widget wrap(Widget page) => MaterialApp(home: page);

void main() {
  setUp(DraftStorage.clear);

  testWidgets('Home page shows both projects', (tester) async {
    await tester.pumpWidget(const FormApp());

    expect(find.textContaining('User Registration Form'), findsOneWidget);
    expect(find.textContaining('Multi-Step Form Wizard'), findsOneWidget);
  });

  testWidgets('Registration: empty submit shows error messages', (
    tester,
  ) async {
    // A tall screen so the whole form (and the Register button) is built.
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(wrap(const RegistrationFormPage()));

    await tester.tap(find.text('Register'));
    await tester.pump();

    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Please select your gender'), findsOneWidget);
    expect(find.text('Please pick at least one interest'), findsOneWidget);
    expect(find.text('Birth date is required'), findsOneWidget);
  });

  testWidgets('Wizard: Next is blocked until step 1 is valid', (tester) async {
    await tester.pumpWidget(wrap(const FormWizardPage()));

    expect(find.text('Step 1 of 4'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pump();

    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Step 1 of 4'), findsOneWidget);
  });

  testWidgets('Wizard: Save Draft is restored when reopened', (tester) async {
    await tester.pumpWidget(wrap(const FormWizardPage()));
    await tester.enterText(find.byType(TextFormField).first, 'Tanvir Ahmed');
    await tester.tap(find.text('Save Draft'));
    await tester.pump();
    expect(DraftStorage.hasDraft, isTrue);

    // Reopen the page: the saved name comes back.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(wrap(const FormWizardPage()));
    await tester.pump();
    expect(find.text('Tanvir Ahmed'), findsOneWidget);
  });
}
