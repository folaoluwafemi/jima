import 'package:equatable/equatable.dart';
import 'package:jima/src/modules/media/domain/entities/audio.dart';
import 'package:jima/src/modules/media/domain/entities/books.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media_type.dart';
import 'package:jima/src/modules/media/domain/entities/minister.dart';
import 'package:jima/src/modules/media/domain/entities/video.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class GenericMedia with EquatableMixin {
  final String id;
  final String title;
  final String url;
  final String? thumbnail;
  final DateTime dateReleased;
  final Minister minister;
  final int viewCount;
  final DateTime createdAt;
  final GenericMediaType type;

  const GenericMedia({
    required this.id,
    required this.title,
    required this.url,
    this.thumbnail,
    required this.dateReleased,
    required this.minister,
    required this.viewCount,
    required this.createdAt,
    required this.type,
  });

  GenericMedia copyWith({
    String? id,
    String? title,
    String? url,
    String? thumbnail,
    DateTime? dateReleased,
    Minister? minister,
    int? viewCount,
    DateTime? createdAt,
    GenericMediaType? type,
  }) {
    return GenericMedia(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      thumbnail: thumbnail ?? this.thumbnail,
      dateReleased: dateReleased ?? this.dateReleased,
      minister: minister ?? this.minister,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
    );
  }

  Video toVideo() => Video(
        id: id,
        title: title,
        url: url,
        dateReleased: dateReleased,
        minister: minister,
        viewCount: viewCount,
        createdAt: createdAt,
        thumbnail: thumbnail,
      );

  Audio toAudio() => Audio(
        id: id,
        title: title,
        url: url,
        dateReleased: dateReleased,
        minister: minister,
        viewCount: viewCount,
        createdAt: createdAt,
        thumbnail: thumbnail,
      );

  Book toBook() => Book(
        id: id,
        title: title,
        url: url,
        dateReleased: dateReleased,
        minister: minister,
        viewCount: viewCount,
        createdAt: createdAt,
        thumbnail: thumbnail,
      );

  factory GenericMedia.fromOtherMedia(Object media) {
    return switch (media) {
      Video video => GenericMedia(
          id: video.id,
          title: video.title,
          url: video.url,
          dateReleased: video.dateReleased,
          minister: video.minister,
          viewCount: video.viewCount,
          createdAt: video.createdAt,
          type: GenericMediaType.video,
        ),
      Audio audio => GenericMedia(
          id: audio.id,
          title: audio.title,
          url: audio.url,
          dateReleased: audio.dateReleased,
          minister: audio.minister,
          viewCount: audio.viewCount,
          createdAt: audio.createdAt,
          type: GenericMediaType.video,
        ),
      Book book => GenericMedia(
          id: book.id,
          title: book.title,
          url: book.url,
          dateReleased: book.dateReleased,
          minister: book.minister,
          viewCount: book.viewCount,
          createdAt: book.createdAt,
          type: GenericMediaType.video,
        ),
      _ => throw UnimplementedError(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnail,
      'dateReleased': dateReleased,
      'minister': minister,
      'viewCount': viewCount,
      'createdAt': createdAt,
      'type': type,
    };
  }

  factory GenericMedia.fromMap(Map<String, dynamic> map) {
    return GenericMedia(
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
      type: ParseUtils.parseEnum(map['type'], GenericMediaType.values),
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
        type,
      ];
}
