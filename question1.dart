// Question 1: Basic Data Types & Functions (Difficulty: 1/5) ⭐
/**
 * EXPECTED OUTPUT:
 * Name: John Doe, Age: 25, Height: 5.9, Is Student: true
 * BMI: 22.5
 * Grade: B
 */

// 1. Create variables of different data types: String, int, double, bool
String name = "John Doe";
int age = 25;
double height = 5.9; // in feet
bool isStudent = true;

// 2. Calculate BMI = weight (kg) / height (m)^2
double calculateBMI(double weight, double height) {
  return weight / (height * height);
}

// 3. Convert a numeric score into a letter grade
String getGrade(int score) {
  if (score >= 90) return "A";
  if (score >= 80) return "B";
  if (score >= 70) return "C";
  if (score >= 60) return "D";
  return "F";
}

void main() {
  const double weightKg = 72.9;
  const double feetToMeters = 0.3048;
  const int score = 85;

  // Height is stored in feet, so convert to meters (5.9 ft ≈ 1.8 m) before calculating BMI
  double heightInMeters = double.parse((height * feetToMeters).toStringAsFixed(1));
  double bmi = double.parse(
      calculateBMI(weightKg, heightInMeters).toStringAsFixed(1));
  String grade = getGrade(score);

  print("Name: $name, Age: $age, Height: $height, Is Student: $isStudent");
  print("BMI: $bmi");
  print("Grade: $grade");
}
