import 'package:get_it/get_it.dart';
import 'package:news_assistant/managers/news_manager.dart';
import 'package:news_assistant/services/news_service.dart';

final getIt = GetIt.instance;

void setupInjector() async {
  getIt.registerLazySingleton<NewsServices>(() => NewsServicesImpl());
  getIt.registerSingleton<NewsManager>(NewsManager(getIt.get()));
}
