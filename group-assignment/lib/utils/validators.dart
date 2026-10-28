// All form validation rules in one place.
// Each method returns an error message, or null when the value is valid.
class Validators {
  static String? nameValidator(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }
    if (!RegExp(r'^[a-zA-Z\s.]+$').hasMatch(name.trim())) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  static String? emailValidation(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Accepts 01XXXXXXXXX, +8801XXXXXXXXX or 8801XXXXXXXXX
  static String? bangladeshNumberValidator(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return 'Phone number is required';
    }
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.startsWith('880')) {
      cleanPhone = cleanPhone.substring(2); // keep the leading 0
    }
    if (cleanPhone.length != 11) {
      return 'Phone number must be 11 digits (e.g. 01712345678)';
    }
    const validPrefixes = ['013', '014', '015', '016', '017', '018', '019'];
    if (!validPrefixes.contains(cleanPhone.substring(0, 3))) {
      return 'Please enter a valid Bangladesh mobile number';
    }
    return null;
  }

  static String? ageValidator(String? age) {
    if (age == null || age.trim().isEmpty) {
      return 'Age is required';
    }
    final int? ageValue = int.tryParse(age.trim());
    if (ageValue == null) {
      return 'Please enter a valid age';
    }
    if (ageValue < 13) {
      return 'You must be at least 13 years old';
    }
    if (ageValue > 120) {
      return 'Please enter a valid age';
    }
    return null;
  }

  // Bangladesh NID is 10, 13 or 17 digits
  static String? nidValidator(String? nid) {
    if (nid == null || nid.trim().isEmpty) {
      return 'NID is required';
    }
    final String cleanNid = nid.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanNid.length != 10 &&
        cleanNid.length != 13 &&
        cleanNid.length != 17) {
      return 'NID must be 10, 13 or 17 digits';
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? confirmPasswordValidator(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? minLengthValidator(
    String? value,
    int minLength,
    String fieldName,
  ) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.trim().length < minLength) {
      return '$fieldName must be at least $minLength characters long';
    }
    return null;
  }

  // Password strength from 0 (empty) to 5 (meets every rule)
  static int passwordStrength(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]'))) score++;
    return score;
  }
}
