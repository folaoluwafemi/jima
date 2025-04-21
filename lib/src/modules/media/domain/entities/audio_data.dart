class AudioData {
  final String podcastName;
  final String podcastUrl;
  final String podcastCoverImage;

  const AudioData({
    required this.podcastName,
    required this.podcastUrl,
    required this.podcastCoverImage,
  });

  AudioData.initial()
      : podcastUrl =
            'https://open.spotify.com/show/3LosKcNpWjnmNhBQ6I3iLg?si=341f9e30befb4978',
        podcastName = 'JOSHUA IGINLA MINISTRIES PODCAST',
        podcastCoverImage =
            'https://i.scdn.co/image/ab67656300005f1f52c01eceffac692551a02957';

  Map<String, dynamic> toMap() {
    return {
      'podcastName': podcastName,
      'podcastUrl': podcastUrl,
      'podcastCoverImage': podcastCoverImage,
    };
  }

  factory AudioData.fromMap(Map<String, dynamic> map) {
    return AudioData(
      podcastName: map['podcastName'] as String,
      podcastUrl: map['podcastUrl'] as String,
      podcastCoverImage: map['coverImage'] as String,
    );
  }
}
