import 'package:equatable/equatable.dart';
import 'package:jima/src/modules/media/domain/entities/minister.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class Book with EquatableMixin {
  final String id;
  final String title;
  final String url;
  final String? thumbnail;
  final DateTime dateReleased;
  final Minister minister;
  final int viewCount;
  final DateTime createdAt;

  const Book({
    required this.id,
    required this.title,
    required this.url,
    required this.dateReleased,
    required this.minister,
    required this.viewCount,
    required this.createdAt,
    this.thumbnail,
  });

  static String get columns => '''
  id,
  title,
  url,
  dateReleased,
  minister:Ministers!inner(*),
  viewCount,
  createdAt,
  thumbnailUrl
  ''';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'thumbnail': thumbnail,
      'dateReleased': dateReleased,
      'minister_id': minister.id,
      'viewCount': viewCount,
      'createdAt': createdAt,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
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
      ];
}
