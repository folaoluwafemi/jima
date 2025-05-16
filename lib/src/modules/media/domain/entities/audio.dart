import 'package:equatable/equatable.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:jima/src/modules/media/domain/entities/minister.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class Audio with EquatableMixin {
  final String id;
  final String title;
  final String url;
  final String? thumbnail;
  final DateTime dateReleased;
  final Minister minister;
  final int viewCount;
  final DateTime createdAt;
  final Category? category;

  const Audio({
    required this.id,
    required this.title,
    required this.url,
    this.thumbnail,
    required this.dateReleased,
    required this.minister,
    required this.viewCount,
    required this.createdAt,
    this.category,
  });

  Audio copyWith({
    String? id,
    String? title,
    String? url,
    String? thumbnail,
    DateTime? dateReleased,
    Minister? minister,
    int? viewCount,
    DateTime? createdAt,
    Category? category,
  }) {
    return Audio(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      thumbnail: thumbnail ?? this.thumbnail,
      dateReleased: dateReleased ?? this.dateReleased,
      minister: minister ?? this.minister,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
    );
  }

  static String get columns => '''
  id,
  title,
  url,
  dateReleased,
  minister:Ministers!inner(*),
  viewCount,
  createdAt,
  thumbnailUrl,
  category:Category(*)
  ''';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnail,
      'dateReleased': dateReleased.toIso8601String(),
      'minister': minister.toMap(),
      'viewCount': viewCount,
      'createdAt': createdAt.toIso8601String(),
      'category': category?.toMap(),
    };
  }

  factory Audio.fromMap(Map<String, dynamic> map) {
    return Audio(
      id: map['id'] as String,
      title: map['title'] as String,
      url: map['url'] as String,
      thumbnail: map['thumbnailUrl'] as String?,
      dateReleased: ParseUtils.parseDateTime(map['dateReleased']),
      minister: ParseUtils.parseJson(
        map['minister'],
        mapper: Minister.fromMap,
      ),
      viewCount: map['viewCount'] as int,
      createdAt: ParseUtils.parseDateTime(map['createdAt']),
      category: map['category'] != null
          ? Category.fromMap(map['category'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        url,
        thumbnail,
        dateReleased,
        minister,
        viewCount,
        createdAt,
        category,
      ];
}
