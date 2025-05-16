import 'package:equatable/equatable.dart';

class Category with EquatableMixin {
  final String id;
  final String name;

  const Category({
    required this.id,
    required this.name,
  });

  Category copyWith({
    String? id,
    String? name,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
