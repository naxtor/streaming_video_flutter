import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_video_flutter/domain/usecases/get_videos.dart';
import 'package:streaming_video_flutter/presentation/bloc/video_event.dart';
import 'package:streaming_video_flutter/presentation/bloc/video_state.dart';
import 'package:video_player/video_player.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  GetVideos getVideos;

  VideoBloc(this.getVideos) : super(VideoEmpty()) {
    on<GetVideosEvent>((event, emit) async {
      try {
        emit(VideoLoading());

        final videos = await getVideos.execute();

        emit(HasVideo(videos));
      } catch (e) {
        emit(HasError(e.toString()));
        rethrow;
      }
    });
    on<SelectVideoEvent>((event, emit) async {
      if (state is HasVideo) {
        final currentState = state as HasVideo;

        final controller = VideoPlayerController.network(
          currentState.musicVideos[event.index].previewUrl,
        );

        emit(currentState.copyWith(
          selectedVideo: event.index,
          controller: controller,
          isVideoControllerHidden: false,
        ));
      }
    });
    on<PlayOrPauseVideoEvent>((event, emit) async {
      if (state is HasVideo) {
        final currentState = state as HasVideo;

        if (currentState.controller!.value.isPlaying) {
          currentState.controller!.pause();

          emit(VideoLoading());
          emit(currentState.copyWith());
        } else {
          currentState.controller!.play();

          emit(currentState.copyWith(
            isVideoControllerHidden: true,
          ));
        }
      }
    });
    on<ToggleVideoControllerEvent>((event, emit) async {
      if (state is HasVideo) {
        final currentState = state as HasVideo;

        emit(currentState.copyWith(
          isVideoControllerHidden: !currentState.isVideoControllerHidden,
        ));
      }
    });
    on<ToggleFullscreenEvent>((event, emit) async {
      if (state is HasVideo) {
        final currentState = state as HasVideo;

        if (currentState.isFullscreen) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          SystemChrome.restoreSystemUIOverlays();
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]);
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.immersive,
          );
        }

        emit(currentState.copyWith(
          isFullscreen: !currentState.isFullscreen,
        ));
      }
    });
  }
}
