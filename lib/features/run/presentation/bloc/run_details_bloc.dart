import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/run.dart';
import '../../data/datasources/run_api_service.dart';

// Events
abstract class RunDetailsEvent extends Equatable {
  const RunDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadRunDetailsEvent extends RunDetailsEvent {
  final String runId;

  const LoadRunDetailsEvent(this.runId);

  @override
  List<Object> get props => [runId];
}

class JoinRunEvent extends RunDetailsEvent {
  final String runId;

  const JoinRunEvent(this.runId);

  @override
  List<Object> get props => [runId];
}

class LeaveRunEvent extends RunDetailsEvent {
  final String runId;

  const LeaveRunEvent(this.runId);

  @override
  List<Object> get props => [runId];
}

// States
abstract class RunDetailsState extends Equatable {
  const RunDetailsState();

  @override
  List<Object> get props => [];
}

class RunDetailsInitial extends RunDetailsState {}

class RunDetailsLoading extends RunDetailsState {}

class RunDetailsLoaded extends RunDetailsState {
  final Run run;

  const RunDetailsLoaded(this.run);

  @override
  List<Object> get props => [run];
}

class RunDetailsError extends RunDetailsState {
  final String message;

  const RunDetailsError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class RunDetailsBloc extends Bloc<RunDetailsEvent, RunDetailsState> {
  final RunApiService _apiService;

  RunDetailsBloc({RunApiService? apiService})
      : _apiService = apiService ?? RunApiService(),
        super(RunDetailsInitial()) {
    on<LoadRunDetailsEvent>(_onLoadRunDetails);
    on<JoinRunEvent>(_onJoinRun);
    on<LeaveRunEvent>(_onLeaveRun);
  }

  Future<void> _onLoadRunDetails(
    LoadRunDetailsEvent event,
    Emitter<RunDetailsState> emit,
  ) async {
    emit(RunDetailsLoading());
    try {
      final run = await _apiService.getRun(event.runId);
      emit(RunDetailsLoaded(run));
    } catch (e) {
      emit(RunDetailsError(e.toString()));
    }
  }

  Future<void> _onJoinRun(
    JoinRunEvent event,
    Emitter<RunDetailsState> emit,
  ) async {
    try {
      final updatedRun = await _apiService.joinRun(event.runId);
      emit(RunDetailsLoaded(updatedRun));
    } catch (e) {
      emit(RunDetailsError(e.toString()));
      // Reload run details to ensure consistent state
      add(LoadRunDetailsEvent(event.runId));
    }
  }

  Future<void> _onLeaveRun(
    LeaveRunEvent event,
    Emitter<RunDetailsState> emit,
  ) async {
    try {
      final updatedRun = await _apiService.leaveRun(event.runId);
      emit(RunDetailsLoaded(updatedRun));
    } catch (e) {
      emit(RunDetailsError(e.toString()));
      // Reload run details to ensure consistent state
      add(LoadRunDetailsEvent(event.runId));
    }
  }
}
