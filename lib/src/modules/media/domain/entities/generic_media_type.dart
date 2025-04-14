import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/tools/tools_barrel.dart';

enum GenericMediaType with EnumHelper {
  video(AppRoute.videoPreview),
  audio(AppRoute.audioPreview),
  book(AppRoute.bookPreview),
  ;

  @override
  String get enumValue => name;

  String get tableName => '${name.toFirstUppercase()}s';

  final AppRoute? previewRoute;

  const GenericMediaType(this.previewRoute);
}
