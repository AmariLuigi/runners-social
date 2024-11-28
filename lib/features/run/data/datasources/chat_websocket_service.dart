import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../core/config/api_config.dart';
import '../../domain/entities/chat_message.dart';

class ChatWebSocketService {
  WebSocketChannel? _channel;
  final _messageController = StreamController<ChatMessage>.broadcast();
  String? _currentRunId;

  Stream<ChatMessage> get messageStream => _messageController.stream;

  Future<void> connectToRun(String runId) async {
    if (_channel != null) {
      await disconnectFromRun();
    }

    final token = await ApiConfig.getAuthToken();
    final wsUrl = '${ApiConfig.wsUrl}/runs/$runId/chat?token=$token';
    
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    _currentRunId = runId;

    _channel!.stream.listen(
      (message) {
        final data = jsonDecode(message);
        if (data['type'] == 'chat_message') {
          final chatMessage = ChatMessage.fromJson(data['payload']);
          _messageController.add(chatMessage);
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
        _reconnect();
      },
      onDone: () {
        print('WebSocket connection closed');
        _reconnect();
      },
    );
  }

  Future<void> disconnectFromRun() async {
    await _channel?.sink.close();
    _channel = null;
    _currentRunId = null;
  }

  void sendMessage(String content) {
    if (_channel == null || _currentRunId == null) {
      throw Exception('Not connected to a run chat');
    }

    final message = {
      'type': 'chat_message',
      'payload': {
        'content': content,
        'runId': _currentRunId,
      },
    };

    _channel!.sink.add(jsonEncode(message));
  }

  Future<void> _reconnect() async {
    if (_currentRunId != null) {
      await Future.delayed(const Duration(seconds: 2));
      await connectToRun(_currentRunId!);
    }
  }

  void dispose() {
    disconnectFromRun();
    _messageController.close();
  }
}
