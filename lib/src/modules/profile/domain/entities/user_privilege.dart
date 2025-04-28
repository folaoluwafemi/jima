import 'package:jima/src/tools/tools_barrel.dart';

enum UserPrivilege with EnumHelper {
  admin,
  user,
  none,
  ;

  bool get isNone => this == none;

  bool get isAdmin => this == admin;

  bool get isUser => this == user;

  @override
  String get enumValue => name;

  factory UserPrivilege.fromName(String name) {
    return values.firstWhere(
      (element) => element.name == name,
      orElse: () => none,
    );
  }
}
