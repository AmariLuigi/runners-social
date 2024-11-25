import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.map(
        checkAuthStatus: (e) => _checkAuthStatus(e, emit),
        login: (e) => _login(e, emit),
        register: (e) => _register(e, emit),
        logout: (e) => _logout(e, emit),
        updateProfile: (e) => _updateProfile(e, emit),
        resetPassword: (e) => _resetPassword(e, emit),
        verifyEmail: (e) => _verifyEmail(e, emit),
        refreshToken: (e) => _refreshToken(e, emit),
      );
    });
  }

  Future<void> _checkAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(const AuthState.unauthenticated()),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _login(
    Login event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _authRepository.login(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _register(
    Register event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _authRepository.register(
      email: event.email,
      password: event.password,
      username: event.username,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _logout(
    Logout event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _authRepository.logout();
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> _updateProfile(
    UpdateProfile event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _authRepository.updateProfile(
      username: event.username,
      bio: event.bio,
      profileImageUrl: event.profileImageUrl,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) async {
        final userResult = await _authRepository.getCurrentUser();
        userResult.fold(
          (failure) => emit(AuthState.error(failure.message)),
          (user) => emit(AuthState.authenticated(user)),
        );
      },
    );
  }

  Future<void> _resetPassword(
    ResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _authRepository.resetPassword(
      email: event.email,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.resetPasswordSuccess()),
    );
  }

  Future<void> _verifyEmail(
    VerifyEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _authRepository.verifyEmail(
      token: event.token,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.verifyEmailSuccess()),
    );
  }

  Future<void> _refreshToken(
    RefreshToken event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _authRepository.refreshToken();
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) async {
        final userResult = await _authRepository.getCurrentUser();
        userResult.fold(
          (failure) => emit(AuthState.error(failure.message)),
          (user) => emit(AuthState.authenticated(user)),
        );
      },
    );
  }
}
