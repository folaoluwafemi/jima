import 'package:jima/src/tools/tools_barrel.dart';
import 'package:flutter/foundation.dart';

abstract final class Regexes {
  static final RegExp numbers = RegExp(r'\d');
  static final RegExp lowerCase = RegExp(r'[a-z]');
  static final RegExp upperCase = RegExp(r'[A-Z]');
  static final RegExp email = RegExp(
    r"^[a-zA-Z\d_.+-]+@[a-zA-Z\d-]+\.[a-zA-Z\d-.]+$",
  );
  static final RegExp extractEmail = RegExp(r'\S*@\S*');
  static final RegExp specialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
}

typedef ValidatorResponse = ({String? message, bool isError});

abstract final class Validators {
  static ValidatorResponse? simpleValidator(
    String? value, {
    bool showSuccess = false,
    ValueChanged<bool>? onValidated,
  }) {
    if (value?.isEmpty ?? true) {
      onValidated?.call(false);
      return (message: 'Field cannot be empty!', isError: true);
    }
    onValidated?.call(true);
    return showSuccess ? (message: null, isError: false) : null;
  }

  static bool validateAll(List<String?> values) {
    for (final String? value in values) {
      if (value?.isEmpty ?? true) {
        return false;
      }
    }
    return true;
  }

  static ValidatorResponse? passwordValidator(
    String? value, {
    bool showSuccess = false,
    bool showText = true,
    ValueChanged<bool>? onValidated,
  }) {
    if (value?.isEmpty ?? true) {
      onValidated?.call(false);
      return !showText
          ? null.errorResponse
          : 'Field cannot be empty!'.errorResponse;
    }
    final String? validateValue = _computePasswordErrorText(value ?? '');

    if (validateValue != null) {
      onValidated?.call(false);
      return !showText ? null.errorResponse : validateValue.errorResponse;
    }

    onValidated?.call(true);
    return showSuccess ? null.successResponse : null;
  }

  static ValidatorResponse? lengthLimitValidator(
    String? value, {
    required int limit,
    bool showSuccess = false,
    ValueChanged<bool>? onValidated,
  }) {
    // validate to have 8 characters and above
    if (value?.isEmpty ?? true) {
      onValidated?.call(false);
      return 'Field cannot be empty!'.errorResponse;
    }
    if (value!.length < limit) {
      onValidated?.call(false);
      return 'Must be $limit characters!'.errorResponse;
    }
    onValidated?.call(true);
    return showSuccess ? null.successResponse : null;
  }

  static ValidatorResponse? expiryDateValidator(
    String? value, {
    bool showSuccess = false,
    ValueChanged<bool>? onValidated,
  }) {
    if (value?.isEmpty ?? true) {
      onValidated?.call(false);
      return 'Field cannot be empty!'.errorResponse;
    }
    if (value!.length < 5) {
      onValidated?.call(false);
      return (message: 'Enter a valid expiry date', isError: true);
    }
    if (value.length == 5) {
      final now = DateTime.now().copyAsDate().copyWith(day: 1);
      final initials = now.year.toString().substring(0, 2);
      final date = DateTime(
        int.parse('$initials${value.split('/').last}'),
        int.parse(value.split('/').first),
      );

      if (now == date || now.isAfter(date)) {
        onValidated?.call(false);
        return (message: 'Expiry date is invalid', isError: true);
      }
    }
    onValidated?.call(true);
    return showSuccess ? null.successResponse : null;
  }

  static ValidatorResponse? confirmPasswordValidator(
    String? value,
    String password, {
    bool showSuccess = false,
    ValueChanged<bool>? onValidated,
  }) {
    if (value?.isEmpty ?? true) {
      onValidated?.call(false);
      return 'Field cannot be empty!'.errorResponse;
    }
    if (value != password) {
      onValidated?.call(false);
      return 'Password does not match'.errorResponse;
    }
    onValidated?.call(true);
    return showSuccess ? null.successResponse : null;
  }

  static String? _computePasswordErrorText(String value) {
    final bool containsNumbers = Regexes.numbers.hasMatch(value);
    final bool containsLowercase = Regexes.lowerCase.hasMatch(value);
    final bool containsUppercase = Regexes.upperCase.hasMatch(value);
    final bool containsSpecialCharacters = Regexes.specialCharacters.hasMatch(
      value,
    );
    final bool lengthMatches = value.length >= 8;

    const String seed = 'Password must contain';

    if (!containsLowercase) return '$seed lowercase letter';
    if (!containsUppercase) return '$seed capital letter';
    if (!containsNumbers) return '$seed a number';
    if (!containsSpecialCharacters) {
      return '$seed a special letter. eg, !@#\$%^&*(),.?":{}|<>';
    }
    if (!lengthMatches) return 'Password must longer than 8 characters';
    return null;
  }

  static ValidatorResponse? emailValidator(
    value, {
    bool showSuccess = false,
    ValueChanged<bool>? onValidated,
  }) {
    if (value?.isEmpty ?? true) {
      onValidated?.call(false);
      return 'Field cannot be empty!'.errorResponse;
    }
    final RegExp regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    bool hasMatch = regExp.hasMatch('$value');
    if (value == null || !hasMatch) {
      onValidated?.call(false);
      return 'Please enter a valid email'.errorResponse;
    }
    onValidated?.call(true);
    return showSuccess ? null.successResponse : null;
  }
}

extension on String? {
  ValidatorResponse get errorResponse {
    return (message: this, isError: true);
  }

  ValidatorResponse get successResponse {
    return (message: this, isError: false);
  }
}
