import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/features/web_view/data/repo/app_repo.dart';
import 'package:test_app/features/web_view/domain/app_usecase.dart';
import 'package:test_app/features/web_view/ui/bloc/app_bloc.dart';

final sl = GetIt.instance;
Future<void> init() async {
  sl.registerLazySingleton<AppRepo>(() => AppRepo());
  sl.registerLazySingleton<AppUsecase>(() => AppUsecase(repo: sl()));
  sl.registerLazySingleton<AppBloc>(() => AppBloc(usecase: sl()));
}
