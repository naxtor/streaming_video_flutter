import 'package:streaming_video_flutter/data/datasources/remote_data_source.dart';
import 'package:streaming_video_flutter/domain/entities/music_video.dart';
import 'package:streaming_video_flutter/domain/repositories/video_repository.dart';

class VideoRepositoryImplement extends VideoRepository {
  RemoteDataSource remoteDataSource;

  VideoRepositoryImplement(this.remoteDataSource);

  @override
  Future<List<MusicVideo>> getVideos() async {
    try {
      final result = await remoteDataSource.getVideos();

      return List<MusicVideo>.from(result.map((e) => e.toEntity()));
    } catch (_) {
      rethrow;
    }
  }
}
