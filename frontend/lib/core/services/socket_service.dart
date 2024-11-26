import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SocketService {
  static const String baseUrl = 'http://localhost:3000';
  late IO.Socket socket;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> connect() async {
    final token = await _storage.read(key: 'token');
    
    socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {'Authorization': 'Bearer $token'}
    });

    socket.connect();

    socket.onConnect((_) {
      print('Socket connected');
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket.onError((error) {
      print('Socket error: $error');
    });
  }

  void joinRun(String runId) {
    socket.emit('joinRun', {'runId': runId});
  }

  void startRun(String runId) {
    socket.emit('startRun', {'runSessionId': runId});
  }

  void updateLocation(String runId, Map<String, dynamic> location, bool isActive, String userId) {
    socket.emit('updateLocation', {
      'runSessionId': runId,
      'location': location,
      'isActive': isActive,
      'userId': userId,
    });
  }

  void endRun(String runId, String userId) {
    socket.emit('endRun', {
      'runSessionId': runId,
      'userId': userId,
    });
  }

  void onRunStarted(Function(Map<String, dynamic>) callback) {
    socket.on('runStarted', (data) => callback(data));
  }

  void onLocationUpdated(Function(Map<String, dynamic>) callback) {
    socket.on('locationUpdated', (data) => callback(data));
  }

  void onRunEnded(Function(Map<String, dynamic>) callback) {
    socket.on('runEnded', (data) => callback(data));
  }

  void onParticipantJoined(Function(Map<String, dynamic>) callback) {
    socket.on('participantJoined', (data) => callback(data));
  }

  void onParticipantLeft(Function(Map<String, dynamic>) callback) {
    socket.on('participantLeft', (data) => callback(data));
  }

  void onError(Function(dynamic) callback) {
    socket.on('error', callback);
  }

  void leaveRun(String runId) {
    socket.emit('leaveRun', {'runId': runId});
  }

  void disconnect() {
    socket.disconnect();
  }

  bool isConnected() {
    return socket.connected;
  }
}
