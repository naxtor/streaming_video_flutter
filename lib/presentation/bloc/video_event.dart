import 'package:equatable/equatable.dart';

abstract class VideoEvent extends Equatable {
  @override
  List get props => [];
}

class GetVideosEvent extends VideoEvent {}

class SelectVideoEvent extends VideoEvent {
  final int index;

  SelectVideoEvent(this.index);

  @override
  List get props => [
        index,
      ];
}

class PlayOrPauseVideoEvent extends VideoEvent {}

class ToggleVideoControllerEvent extends VideoEvent {}

class ToggleFullscreenEvent extends VideoEvent {}
