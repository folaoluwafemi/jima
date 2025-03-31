import 'package:jima/src/tools/tools_barrel.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart' as uuid;

abstract class UtilFunctions {
  static String generateUuid([int length = 16]) {
    return const uuid.Uuid().v4();
  }

  static bool compareQueries(String value, String query) {
    final String formattedValue = value.trim().toLowerCase();
    final List<String> queryWords = query.split(' ');
    if (queryWords.length == 1) {
      return formattedValue.contains(query.trim().toLowerCase());
    }
    bool hasMatch = false;
    for (final String queryWord in queryWords) {
      hasMatch = formattedValue.contains(queryWord.trim().toLowerCase());
      if (hasMatch) return true;
    }
    return false;
  }

  static String formatNumberInput(num number) {
    String trailingDecimal = '';
    if (number is double) {
      trailingDecimal = '.${'$number'.split('.').last}';
    }
    final String numText = number.toInt().toString();
    final int numLength = numText.length;

    String fullNumText = '';
    for (int i = _getHighestThreeMultiple(numLength); i >= 0; i -= 3) {
      bool onHighestPlaceValue = (_getHighestThreeMultiple(numLength) - i) < 3;
      bool onLowestPlaceValue = i <= 3;
      fullNumText += numText.substring(
        onHighestPlaceValue ? 0 : (numLength - i),
        onLowestPlaceValue ? null : numLength - (i - 3),
      );
      if (onLowestPlaceValue) return '$fullNumText$trailingDecimal';
      fullNumText += ',';
    }
    return '$fullNumText$trailingDecimal';
  }

  static String formatMoneyInput(
    double number, {
    String currency = '\$',
  }) {
    String trailingDecimal = '.${'$number'.split('.').last}';
    trailingDecimal = trailingDecimal.length > 3
        ? trailingDecimal.substring(0, 3)
        : trailingDecimal.padRight(3, '0');
    final String numText = number.toInt().toString();
    final int numLength = numText.length;

    String fullNumText = '';
    for (int i = _getHighestThreeMultiple(numLength); i >= 0; i -= 3) {
      bool onHighestPlaceValue = (_getHighestThreeMultiple(numLength) - i) < 3;
      bool onLowestPlaceValue = i <= 3;
      fullNumText += numText.substring(
        onHighestPlaceValue ? 0 : (numLength - i),
        onLowestPlaceValue ? null : numLength - (i - 3),
      );
      if (onLowestPlaceValue) return '$currency$fullNumText$trailingDecimal';
      fullNumText += ',';
    }
    return '$currency$fullNumText$trailingDecimal';
  }

  static String formatFollowers(num number) {
    final String formatted = formatNumberInput(number);

    final List<String> thousands = formatted.split(',');

    final String trailing = switch (thousands.skip(1).length) {
      1 => 'k',
      2 => 'm',
      3 => 'b',
      4 => 'tr',
      _ => '',
    };
    return '${thousands.first}$trailing';
  }

  static int _getHighestThreeMultiple(int numString) {
    if (numString % 3 == 0) return numString;
    return numString + (3 - (numString % 3));
  }

  static String getTimeAgo(
    DateTime date, {
    bool showNow = false,
  }) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);
    if (difference.inDays > 7) return DateFormat.yMd().format(date);
    if (difference.inDays > 0) {
      return '${difference.inDays}day${difference.inDays.resolvePlurality}';
    }
    if (difference.inHours > 0) {
      return '${difference.inHours}hr${difference.inHours.resolvePlurality}';
    }
    if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min${difference.inMinutes.resolvePlurality}';
    }
    if (difference.inSeconds > 0 || !showNow) {
      return '${difference.inSeconds}sec${difference.inSeconds.resolvePlurality}';
    }
    return 'now';
  }
}
