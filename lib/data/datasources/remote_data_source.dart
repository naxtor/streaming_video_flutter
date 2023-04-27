import 'dart:convert';

import 'package:streaming_video_flutter/data/models/music_video_model.dart';
import 'package:http/http.dart' as http;

abstract class RemoteDataSource {
  Future<List<MusicVideoModel>> getVideos();
}

class RemoteDataSourceImplement extends RemoteDataSource {
  @override
  Future<List<MusicVideoModel>> getVideos() async {
    try {
      final uri = Uri.parse(
          'https://itunes.apple.com/search?term=jack+johnson&entity=musicVideo');

      final result = await http.get(uri);
      final json = jsonDecode(result.body);

      final videos = json["results"] as List;

      return List<MusicVideoModel>.from(
          videos.map((e) => MusicVideoModel.fromJson(e)));
    } catch (_) {
      rethrow;
    }
  }
}
