import 'package:ct_shopping_list_challenge/services/database_service.dart';
import 'package:ct_shopping_list_challenge/services/file_storage_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DatabaseService());
  locator.registerLazySingleton(() => FileStorageService());
}
