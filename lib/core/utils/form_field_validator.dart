
class CustomFormFieldValidator {
  String? isNotEmpty(String? data) {
    return (data?.isNotEmpty ?? false)
        ? null
        : "Cannot be empty";
  }

  String? phoneValidator(String? data) {
    if (data?.isNotEmpty ?? false) {
      if (data!.length < 8) {
        return "Type it completely";
      } else {
        return null;
      }
    } else {
      return "Cannot be empty";
    }
  }
  String? emailValidator(String? data) {
  if (data == null || data.isEmpty) {
    return "Cannot be empty";
  }

  // Regular expression for email validation
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  if (!emailRegex.hasMatch(data.trim())) {
    return "Please enter a valid email address";
  }

  return null; // Valid email
}
  String? passwordValidator(String? data) {
    if (data?.isNotEmpty ?? false) {
      if (data!.length < 6) {
        return "Must be at least 6 character";
      } else {
        return null;
      }
    } else {
      return "Cannot be empty";
    }
  }
}
