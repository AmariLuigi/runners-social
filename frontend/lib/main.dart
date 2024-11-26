import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/services/user_service.dart';
import 'core/services/api_service.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/feed/data/repositories/feed_repository_impl.dart';
import 'features/feed/domain/repositories/feed_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Core
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());

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
  setupDependencies();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    _authBloc.add(const AuthEvent.checkAuthStatus());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: _authBloc,
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            unauthenticated: () {
              _appRouter.replaceAll([const LoginRoute()]);
            },
            orElse: () {},
          );
        },
        child: MaterialApp.router(
          title: 'Runners Social',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerDelegate: _appRouter.delegate(),
          routeInformationParser: _appRouter.defaultRouteParser(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }
}
