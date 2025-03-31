import 'dart:io';

extension FileSizeExtension on File {
  double get size {
    final bytes = readAsBytesSync().lengthInBytes;
    final kb = bytes / 1024;
    return kb / 1024;
  }
}
