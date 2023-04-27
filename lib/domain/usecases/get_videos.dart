import 'package:streaming_video_flutter/domain/entities/music_video.dart';
import 'package:streaming_video_flutter/domain/repositories/video_repository.dart';

class GetVideos {
  VideoRepository videoRepository;

  GetVideos(this.videoRepository);

  Future<List<MusicVideo>> execute() async {
    try {
      final result = await videoRepository.getVideos();

      return result;
    } catch (_) {
      rethrow;
    }
  }
}
