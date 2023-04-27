import 'package:streaming_video_flutter/domain/entities/music_video.dart';

abstract class VideoRepository {
  Future<List<MusicVideo>> getVideos();
}
