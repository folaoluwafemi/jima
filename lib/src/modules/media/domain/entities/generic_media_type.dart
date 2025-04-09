import 'package:jima/src/tools/tools_barrel.dart';

enum GenericMediaType with EnumHelper {
  video,
  audio,
  book,
  ;

  @override
  String get enumValue => name;
}
