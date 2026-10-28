// Small helpers for showing and checking dates without extra packages.
String formatDate(DateTime date) {
  final String day = date.day.toString().padLeft(2, '0');
  final String month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

int ageFromBirthDate(DateTime birthDate) {
  final DateTime today = DateTime.now();
  int age = today.year - birthDate.year;
  final bool birthdayNotYet =
      today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day);
  if (birthdayNotYet) {
    age--;
  }
  return age;
}
