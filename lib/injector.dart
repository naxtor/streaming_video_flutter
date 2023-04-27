import 'package:get_it/get_it.dart';
import 'package:streaming_video_flutter/data/datasources/remote_data_source.dart';
import 'package:streaming_video_flutter/data/repositories/video_repository_implement.dart';
import 'package:streaming_video_flutter/domain/repositories/video_repository.dart';
import 'package:streaming_video_flutter/domain/usecases/get_videos.dart';
import 'package:streaming_video_flutter/presentation/bloc/video_bloc.dart';

class Injector {
  static GetIt getIt = GetIt.instance;

  static void inject() {
    // Bloc
    getIt.registerFactory(
      () => VideoBloc(getIt()),
    );

    // Usecase
    getIt.registerLazySingleton(
      () => GetVideos(getIt()),
    );

    // Repository
    getIt.registerLazySingleton<VideoRepository>(
        () => VideoRepositoryImplement(getIt()));

    // Data source
    getIt.registerLazySingleton<RemoteDataSource>(
        () => RemoteDataSourceImplement());
  }
}
