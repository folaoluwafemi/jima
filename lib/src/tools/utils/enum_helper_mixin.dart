mixin EnumHelper on Enum {
  String get enumValue;

  String get capitalizeEnumName =>
      _enumName[0].toUpperCase() + _enumName.substring(1);

  String get enumNameAllCaps => _enumName.toUpperCase();

  String get _enumName => name;
}
