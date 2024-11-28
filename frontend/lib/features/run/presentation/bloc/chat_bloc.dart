import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';
import '../../data/datasources/run_api_service.dart';
import '../../data/datasources/chat_websocket_service.dart';

// Events
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChatEvent extends ChatEvent {
  final String runId;

  const LoadChatEvent(this.runId);

  @override
  List<Object> get props => [runId];
}

class SendMessageEvent extends ChatEvent {
  final String runId;
  final String content;

  const SendMessageEvent({
    required this.runId,
    required this.content,
  });

  @override
  List<Object> get props => [runId, content];
}

class NewMessageReceivedEvent extends ChatEvent {
  final ChatMessage message;

  const NewMessageReceivedEvent(this.message);

  @override
  List<Object> get props => [message];
}

// States
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatMessagesLoaded extends ChatState {
  final List<ChatMessage> messages;

  const ChatMessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final RunApiService _apiService;
  final ChatWebSocketService _wsService;
  final List<ChatMessage> _messages = [];
  StreamSubscription<ChatMessage>? _chatSubscription;

  ChatBloc({
    RunApiService? apiService,
    ChatWebSocketService? wsService,
  })  : _apiService = apiService ?? RunApiService(),
        _wsService = wsService ?? ChatWebSocketService(),
        super(ChatInitial()) {
    on<LoadChatEvent>(_onLoadChat);
    on<SendMessageEvent>(_onSendMessage);
    on<NewMessageReceivedEvent>(_onNewMessageReceived);

    // Listen to WebSocket messages
    _chatSubscription = _wsService.messageStream.listen(
      (message) => add(NewMessageReceivedEvent(message)),
    );
  }

  Future<void> _onLoadChat(
    LoadChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // Connect to WebSocket
      await _wsService.connectToRun(event.runId);

      // Load chat history
      final messages = await _apiService.getChatMessages(event.runId);
      _messages
        ..clear()
        ..addAll(messages);
      
      emit(ChatMessagesLoaded(_messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final message = await _apiService.sendChatMessage(
        event.runId,
        event.content,
      );
      _messages.add(message);
      emit(ChatMessagesLoaded(_messages));
    } catch (e) {
      emit(ChatError(e.toString()));
      emit(ChatMessagesLoaded(_messages));
    }
  }

  void _onNewMessageReceived(
    NewMessageReceivedEvent event,
    Emitter<ChatState> emit,
  ) {
    _messages.add(event.message);
    emit(ChatMessagesLoaded(_messages));
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    _wsService.dispose();
    return super.close();
  }
}
