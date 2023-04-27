import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_video_flutter/presentation/bloc/video_bloc.dart';
import 'package:streaming_video_flutter/presentation/bloc/video_event.dart';
import 'package:streaming_video_flutter/presentation/bloc/video_state.dart';
import 'package:video_player/video_player.dart';

class VideoListScreen extends StatelessWidget {
  const VideoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videoBloc = context.watch<VideoBloc>();

    return Scaffold(
      appBar: videoBloc.state is HasVideo &&
              (videoBloc.state as HasVideo).isFullscreen
          ? null
          : AppBar(
              title: const Text(
                'Video Player',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
            ),
      body: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          if (state is VideoEmpty) {
            context.read<VideoBloc>().add(GetVideosEvent());
          } else if (state is HasError) {
            return Center(
              child: Text(state.error),
            );
          } else if (state is HasVideo) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        AnimatedContainer(
                          height: state.selectedVideo != null
                              ? state.isFullscreen
                                  ? MediaQuery.of(context).size.height
                                  : 200
                              : 0,
                          color: Colors.black,
                          duration: const Duration(milliseconds: 300),
                          child: Builder(builder: (context) {
                            if (state.selectedVideo == null) {
                              return Container();
                            } else if (!state.controller!.value.isInitialized) {
                              state.controller!.initialize().then((_) {
                                context
                                    .read<VideoBloc>()
                                    .add(PlayOrPauseVideoEvent());
                              });

                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            state.controller!.addListener(
                              () {
                                // Looping the video
                                if (state.controller!.value.position ==
                                    state.controller!.value.duration) {
                                  state.controller!
                                      .seekTo(const Duration(seconds: 0));
                                  state.controller!.play();
                                }
                              },
                            );

                            return GestureDetector(
                              onTap: () => context
                                  .read<VideoBloc>()
                                  .add(ToggleVideoControllerEvent()),
                              child: VideoPlayer(
                                state.controller!,
                              ),
                            );
                          }),
                        ),
                        Positioned.fill(
                          child: Builder(builder: (context) {
                            if (state.selectedVideo == null) {
                              return Container();
                            }

                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: state.isVideoControllerHidden ? 0 : 1,
                              // onEnd: () {
                              //   if (!state.isVideoControllerHidden) {
                              //     Future.delayed(
                              //       const Duration(seconds: 2),
                              //       () => context
                              //           .read<VideoBloc>()
                              //           .add(ToggleVideoControllerEvent()),
                              //     );
                              //   }
                              // },
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (!state.isVideoControllerHidden) {
                                      context
                                          .read<VideoBloc>()
                                          .add(PlayOrPauseVideoEvent());
                                    }
                                  },
                                  child: Icon(
                                    state.controller!.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Builder(builder: (context) {
                            if (state.selectedVideo == null) {
                              return Container();
                            }

                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: state.isVideoControllerHidden ? 0 : 1,
                              child: GestureDetector(
                                onTap: () => context
                                    .read<VideoBloc>()
                                    .add(ToggleFullscreenEvent()),
                                child: const Icon(
                                  Icons.fullscreen,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    Builder(builder: (context) {
                      if (state.selectedVideo == null || state.isFullscreen) {
                        return Container();
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              state.musicVideos[state.selectedVideo!].trackName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 4,
                              ),
                              child: Text(
                                state.musicVideos[state.selectedVideo!]
                                    .artistName,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
                Expanded(
                  child: Builder(
                    builder: (_) {
                      if (state.musicVideos.isNotEmpty) {
                        return ListView(
                          children:
                              List.generate(state.musicVideos.length, (index) {
                            final musicVideo = state.musicVideos[index];

                            return InkWell(
                              onTap: () => context
                                  .read<VideoBloc>()
                                  .add(SelectVideoEvent(index)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                                child: Row(
                                  children: [
                                    Ink(
                                      height: 60,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            musicVideo.artworkUrl100,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              musicVideo.trackName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 4,
                                              ),
                                              child: Text(
                                                musicVideo.artistName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                        left: 12,
                                      ),
                                      child: Icon(
                                        Icons.play_arrow,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      }

                      return const Center(
                        child: Text('No video here'),
                      );
                    },
                  ),
                )
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
