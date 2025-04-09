import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:jima/src/tools/components/svg_widget.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum PasswordValidationError {
  empty(
    'Password must be at least 8 characters and must\ncontain at least '
    'an uppercase character, a number\nand a special character.',
  ),
  tooShort('Password must be at least 8 characters'),
  noCapitalLetter('Password must contain at least an uppercase character'),
  noNumber('Password must contain at least a number'),
  specialCharacter('Password must contain at least a special character');

  const PasswordValidationError(this.errorText);

  final String errorText;
}

extension StringEx on String {
  num get formattedToNumber {
    return num.parse(cleanForNum);
  }

  String get cleanForNum => replaceAll(',', '').replaceAll(' ', '');

  String toFirstUppercase() {
    return isEmpty ? '' : '${this[0].toFirstUppercase()}${substring(1)}';
  }

  String get titleCase {
    if (isEmpty) return this;

    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() +
          (word.length > 1 ? word.substring(1).toLowerCase() : '');
    }).join(' ');
  }

  String get toEmoji {
    // 0x41 is Letter A
    // 0x1F1E6 is Regional Indicator Symbol Letter A
    // Example :
    // firstLetter U => 20 + 0x1F1E6
    // secondLetter S => 18 + 0x1F1E6
    // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
    final firstLetter = codeUnitAt(0) - 0x41 + 0x1F1E6;
    final secondLetter = codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  // String capit

  bool compareAgainst(String query) {
    final value = this;
    final formattedValue = value.trim().toLowerCase();
    final queryWords = query.split(' ');
    if (queryWords.length == 1) {
      return formattedValue.contains(query.trim().toLowerCase());
    }
    var hasMatch = false;
    for (final queryWord in queryWords) {
      hasMatch = formattedValue.contains(queryWord.trim().toLowerCase());
      if (hasMatch) return true;
    }
    return false;
  }

  String maskPhone() {
    final masked = MaskTextInputFormatter(
      initialText: this,
      mask: '+### ### ### ####',
      filter: {'#': RegExp('[0-9]')},
    ).getMaskedText();
    return masked.replaceRange(7, 15, '****');
  }

  String get toSnakeCase {
    if (isEmpty) {
      return '';
    }

    // Replace spaces and hyphens with underscores
    var replaced = replaceAll(RegExp(r'[\s-]'), '_');

    // Convert to lowercase
    replaced = replaced.toLowerCase();

    // Insert underscores before uppercase letters (except at the beginning)
    final snakeCase = replaced.replaceAllMapped(
      RegExp('(?<!^)([A-Z])'),
      (Match m) => '_${m[1]!.toLowerCase()}',
    );

    // Remove leading or trailing underscores
    return snakeCase.replaceAll(RegExp(r'^_+|_+$'), '');
  }

  Widget vectorAssetWidget({
    double? dimension,
    double? height,
    double? width,
    double? rotationAngle,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    return Transform.rotate(
      angle: rotationAngle?.toRadians ?? 0,
      child: SvgWidget(
        this,
        height: dimension ?? height,
        width: dimension ?? width,
        fit: fit,
        color: color,
      ),
    );
  }

  Widget imageAssetWidget({
    double? dimension,
    double? height,
    double? width,
    double? rotationAngle,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    return Transform.rotate(
      angle: rotationAngle?.toRadians ?? 0,
      child: Image.asset(
        this,
        height: dimension ?? height,
        width: dimension ?? width,
        fit: fit,
        color: color,
      ),
    );
  }
}

extension EmailValidator on String {
  bool get isValidEmail {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }

  String maskEmail([int minFill = 4, String fillChar = '*']) {
    final emailMaskRegExp = RegExp(r'^(.)(.*?)([^@]?)(?=@[^@]+$)');

    return replaceFirstMapped(emailMaskRegExp, (m) {
      final start = m.group(1)!;
      final middle = fillChar * max(minFill, m.group(2)!.length);
      final end = m.groupCount >= 3 ? m.group(3)! : start;
      return start + middle + end;
    });
  }

  String get cleanLower => trim().toLowerCase();

  List<String> get chars => split('');

  String? get nullIfEmpty => isEmpty ? null : this;

  String get reversed => chars.reversed.join();

  List<String> get words => split(' ');

  String get possessive => chars.last == 's' ? "$this'" : "$this's";
}

extension PasswordValidation on String? {
  String? validatePassword() {
    final value = this;
    if (value == null) {
      return PasswordValidationError.empty.errorText;
    } else if (value.isEmpty) {
      return PasswordValidationError.empty.errorText;
    } else if (value.length < 8) {
      return PasswordValidationError.tooShort.errorText;
    } else if (!value.contains(RegExp('[A-Z]'))) {
      return PasswordValidationError.noCapitalLetter.errorText;
    } else if (!value.contains(RegExp('[0-9]'))) {
      return PasswordValidationError.noNumber.errorText;
    } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return PasswordValidationError.specialCharacter.errorText;
    }
    return null;
  }
}

extension NullableStringExtension on String? {
  String get orEmpty => this ?? '';

  bool get isNullOrEmpty => orEmpty.isEmpty;

  bool get isNotNullOrEmpty => !isNullOrEmpty;
}

extension DurationEx on Duration {
  String get format {
    final min = inMinutes;
    if (min ~/ 60 < 60) {
      return '${(min ~/ 60).toString().padLeft(2, '0')}:'
          '${(min % 60).toString().padLeft(2, '0')}';
    } else {
      final hours = min ~/ 3600;
      return '${hours.toString().padLeft(2, '0')}:'
          '${((min - (hours * 3600)) ~/ 60).toString().padLeft(2, '0')}:'
          '${(min % 60).toString().padLeft(2, '0')}';
    }
  }
}

extension URLValidator on String {
  bool get isUrl => contains('http://') || contains('https://');

  bool get isValidURL {
    // Basic URL validation pattern
    final urlPattern = RegExp(
      r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-zA-Z0-9]+([\-\.]{1}[a-zA-Z0-9]+)*\.[a-zA-Z]{2,5}(:[0-9]{1,5})?(\/.*)?$',
      caseSensitive: false,
    );

    // Stricter URL validation using Uri.parse()
    var isValidUri = false;
    try {
      final uri = Uri.parse(this);
      isValidUri = uri.hasScheme && uri.hasAuthority;
    } on FormatException catch (_) {
      return false;
    }

    return urlPattern.hasMatch(this) && isValidUri;
  }
}
