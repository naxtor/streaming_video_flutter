import 'package:equatable/equatable.dart';
import 'package:streaming_video_flutter/domain/entities/music_video.dart';
import 'package:video_player/video_player.dart';

abstract class VideoState extends Equatable {
  @override
  List get props => [];
}

class VideoEmpty extends VideoState {}

class VideoLoading extends VideoState {}

class HasVideo extends VideoState {
  final List<MusicVideo> musicVideos;
  final int? selectedVideo;
  final VideoPlayerController? controller;
  final bool isVideoControllerHidden;
  final bool isFullscreen;

  HasVideo(
    this.musicVideos, {
    this.selectedVideo,
    this.controller,
    this.isVideoControllerHidden = false,
    this.isFullscreen = false,
  });

  HasVideo copyWith({
    List<MusicVideo>? musicVideos,
    int? selectedVideo,
    VideoPlayerController? controller,
    bool? isVideoControllerHidden,
    bool? isFullscreen,
  }) =>
      HasVideo(
        musicVideos ?? this.musicVideos,
        selectedVideo: selectedVideo ?? this.selectedVideo,
        controller: controller ?? this.controller,
        isVideoControllerHidden:
            isVideoControllerHidden ?? this.isVideoControllerHidden,
        isFullscreen: isFullscreen ?? this.isFullscreen,
      );

  @override
  List get props => [
        musicVideos,
        selectedVideo,
        controller,
        isVideoControllerHidden,
        isFullscreen,
      ];
}

class HasError extends VideoState {
  final String error;

  HasError(this.error);

  @override
  List get props => [
        error,
      ];
}
