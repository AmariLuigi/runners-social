import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/services/user_service.dart';
import 'core/services/api_service.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/feed/data/repositories/feed_repository_impl.dart';
import 'features/feed/domain/repositories/feed_repository.dart';
import 'core/di/service_locator.dart';
import 'core/providers/theme_provider.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Core
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());
  getIt.registerSingleton<AppRouter>(AppRouter());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      client: getIt<http.Client>(),
      storage: getIt<FlutterSecureStorage>(),
      baseUrl: 'http://localhost:3000',
    ),
  );

  getIt.registerLazySingleton<FeedRepository>(
    () => FeedRepositoryImpl(
      client: getIt<http.Client>(),
      storage: getIt<FlutterSecureStorage>(),
      baseUrl: 'http://localhost:3000',
    ),
  );

  // Blocs
  getIt.registerFactory(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );

  // Register services as singletons
  getIt.registerLazySingleton<UserService>(() => UserService());
  getIt.registerLazySingleton<ApiService>(() => ApiService());
}

void main() {
  setupServiceLocator();
  setupDependencies();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt<AuthBloc>(),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            unauthenticated: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            orElse: () {},
          );
        },
        child: MaterialApp(
          title: 'Runners Social',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: '/',
        ),
      ),
    );
  }
}
