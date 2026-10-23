


/// Shared form-field validators for the auth screens (Login, Sign Up,
/// Forgot Password). Each function matches Flutter's
/// `FormFieldValidator<String>` signature (`String? Function(String?)`),
/// so they plug straight into `AppTextField(validator: ...)`.
class Validators {
  Validators._();

  static final RegExp _emailPattern =
  RegExp(r'^[\w\.\-\+]+@[\w\-]+(\.[\w\-]+)+$');


  static final RegExp _phonePattern = RegExp(r'^\+?[0-9\s\-\(\)]{7,16}$');

  static final RegExp _dobPattern =
  RegExp(r'^\s*(\d{1,2})\s*/\s*(\d{1,2})\s*/\s*(\d{4})\s*$');

  /// Non-empty, trimmed, at least 2 characters — used for "Full Name".
  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your full name';
    if (v.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  /// Basic but solid email-shape check (local@domain.tld).
  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your email address';
    if (!_emailPattern.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  /// Just requires a non-empty password — used on the Login screen, where
  /// we're checking credentials the user already chose, not their strength.
  static String? passwordRequired(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    return null;
  }

  /// Enforces a minimum length — used on Sign Up, matching the "Min. 8
  /// characters" hint shown in the field.
  static String? passwordStrength(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }
  static  String? stateRequired(String? value){
    if(value==null||value.isEmpty){
      return 'Please enter a state';
    }
    return null;
  }

  static  String? cityRequired(String? value){
    if(value==null||value.isEmpty){
      return 'Please enter a city';
    }
    return null;
  }
  static  String? categoryRequired(String? value){
    if(value==null||value.isEmpty){
      return 'Please enter a category';
    }
    return null;
  }

  /// Builds a validator that checks a "confirm password" field matches the
  /// live text in [passwordController].
  static String? Function(String?) matches(
      String Function() otherValue, {
        String message = 'Passwords do not match',
        String emptyMessage = 'Please confirm your password',
      }) {
    return (value) {
      if (value == null || value.isEmpty) return emptyMessage;
      if (value != otherValue()) return message;
      return null;
    };
  }

  /// Generic non-empty check for simple required fields.
  static String? required(String? value, [String message = 'This field is required']) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  /// Accepts digits with optional leading `+`, spaces, dashes and
  /// parentheses, 7–16 characters long — used for "Phone Number".
  static String? phone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your phone number';
    if (!_phonePattern.hasMatch(v)) return 'Enter a valid phone number';
    return null;
  }

  /// Validates a "DD / MM / YYYY" date of birth: correct format, a real
  /// calendar date, and (by default) at least [minAge] years old — used on
  /// the Edit Profile screen, matching the "14 / 09 / 1995" field format.
  static String? dateOfBirth(String? value, {int minAge = 18}) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your date of birth';

    final match = _dobPattern.firstMatch(v);
    if (match == null) return 'Use the format DD / MM / YYYY';

    final day = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final year = int.parse(match.group(3)!);

    if (month < 1 || month > 12) return 'Enter a valid month';
    final daysInMonth = DateTime(year, month + 1, 0).day;
    if (day < 1 || day > daysInMonth) return 'Enter a valid day';

    final dob = DateTime(year, month, day);
    final now = DateTime.now();
    if (dob.isAfter(now)) return 'Date of birth cannot be in the future';

    var age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    if (age < minAge) return 'You must be at least $minAge years old';
    if (age > 120) return 'Enter a valid date of birth';

    return null;
  }
}
