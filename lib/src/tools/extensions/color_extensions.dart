import 'dart:ui';

extension ColorExtensions on Color {
  ColorFilter get toColorFilter {
    return ColorFilter.mode(this, BlendMode.srcIn);
  }

  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  //
  // ignore: deprecated_member_use
  String get hexCode => '#${value.toRadixString(16).substring(2).toUpperCase()}';
}
