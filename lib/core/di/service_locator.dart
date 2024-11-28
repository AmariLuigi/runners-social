import 'package:get_it/get_it.dart';
import '../services/socket_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<SocketService>(() => SocketService());
}
