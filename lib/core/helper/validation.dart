class Validator {
  static String? validateEmail(String value) {
    const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    final regExp = RegExp(pattern);

    if (value == null ||value.isEmpty) {
      return "Please enter an email";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter a valid email";
    } else {
      return null;
    }
  }

  static String? validatePassword(String value) {
    if (value == null ||value.isEmpty) {
      return "Please enter password";
    } else {
      return null;
    }
  }
   
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }
    if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }

  static String? validateMobile(String value) {
    // String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    // RegExp regExp = RegExp(pattern);
    if (value == null ||value.isEmpty) {
      return 'Please enter mobile number';
    }
    // else if (!regExp.hasMatch(value)) {
    //   return 'Please enter valid mobile number';
    // }
    else if (value.length < 8) {
      return 'Phone number can\'t be greater than 8 digit';
    }
    return null;
  }
  static String? validateRequiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your $fieldName";
    }
    if (value.trim().length < 2) {
      return "$fieldName must be at least 2 characters";
    }
    return null;
  }
  static String? validateBirthDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select your date of birth";
    }
    return null;
  }
}
