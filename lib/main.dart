import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_video_flutter/injector.dart';
import 'package:streaming_video_flutter/presentation/bloc/video_bloc.dart';
import 'package:streaming_video_flutter/presentation/screens/video_list.dart';

void main() {
  Injector.inject();

  runApp(const StreamingVideo());
}

class StreamingVideo extends StatelessWidget {
  const StreamingVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => Injector.getIt<VideoBloc>(),
        child: const VideoListScreen(),
      ),
    );
  }
}
