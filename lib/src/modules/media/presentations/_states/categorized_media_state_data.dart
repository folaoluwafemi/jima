import 'package:equatable/equatable.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/media/domain/entities/audio.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:jima/src/modules/media/domain/entities/video.dart';

class CategorizedMediaStateData with EquatableMixin {
  final Category category;
  final PaginationData<Audio> audios;
  final PaginationData<Video> videos;

  const CategorizedMediaStateData({
    required this.category,
    required this.audios,
    required this.videos,
  });

  CategorizedMediaStateData copyWith({
    Category? category,
    PaginationData<Audio>? audios,
    PaginationData<Video>? videos,
  }) {
    return CategorizedMediaStateData(
      category: category ?? this.category,
      audios: audios ?? this.audios,
      videos: videos ?? this.videos,
    );
  }

  @override
  List<Object?> get props => [
        category,
        audios,
        videos,
      ];
}
