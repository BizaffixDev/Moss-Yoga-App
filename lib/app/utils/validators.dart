import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:moss_yoga/common/resources/strings.dart';


class Validator {
  Validator(this.context);

  final BuildContext context;


  static String? emailValidator(String? email) {
    final isEmailValid = EmailValidator.validate(email!);
    if (!isEmailValid) return Strings.errorInvalidEmailAddress;
    return null;
  }

  String? phoneNumberValidator(String? number) {
    if (number != null && number.isEmpty) {
      return '_localization.phone_required_error';
    } else if (number != null && number.length != 9) {
      return ' _localization.phone_length_error';
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password == null || password.trim().isEmpty) {
      return Strings.errorPasswordRequired;
    }
    return null;
  }

  static String? requiredFieldValidator(String? text, String? errorMessage) {
    if (text == null || text.trim().isEmpty) {
      return errorMessage;
    }
    return null;
  }

  static String? generalValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return Strings.errorRequireText;
    }
    return null;
  }
}
