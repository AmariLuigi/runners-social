import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SocketService {
  static const String baseUrl = 'http://localhost:3000';
  IO.Socket? _socket;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isAuthenticated = false;

  IO.Socket get socket {
    if (_socket == null) {
      throw StateError('Socket not initialized. Call connect() first.');
    }
    return _socket!;
  }

  Future<void> connect() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        print('No token available for socket connection');
        return;
      }

      print('Connecting socket with token: ${token.substring(0, 20)}...');
      
      // Disconnect existing socket if any
      if (_socket != null) {
        _socket!.disconnect();
        _socket = null;
      }

      // Remove 'Bearer ' prefix if present
      final cleanToken = token.replaceAll('Bearer ', '');

      _socket = IO.io(
        baseUrl, 
        IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': cleanToken})
          .setExtraHeaders({'authorization': cleanToken})
          .enableForceNew()
          .enableAutoConnect()
          .build()
      );

      _socket!.onConnect((_) {
        print('Socket connected successfully');
        _isAuthenticated = true;
      });

      _socket!.onConnectError((data) {
        print('Socket connection error: $data');
        _isAuthenticated = false;
      });

      _socket!.on('error', (data) {
        print('Socket error received: $data');
        _isAuthenticated = false;
      });

      _socket!.onDisconnect((_) {
        print('Socket disconnected');
        _isAuthenticated = false;
      });

      // Wait for connection
      await Future.delayed(const Duration(milliseconds: 1000));
      
      if (!_socket!.connected) {
        print('Socket failed to connect after timeout');
        _isAuthenticated = false;
      }

    } catch (e, stackTrace) {
      print('Error connecting socket: $e');
      print('Stack trace: $stackTrace');
      _isAuthenticated = false;
      _socket = null;
    }
  }

  Future<bool> _ensureAuthenticated() async {
    if (_socket == null || !_socket!.connected || !_isAuthenticated) {
      print('Socket not initialized, connected, or not authenticated. Reconnecting...');
      await connect();
      return _socket != null && _socket!.connected && _isAuthenticated;
    }
    return true;
  }

  Future<void> startRun(String runId) async {
    print('Starting run with ID: $runId');
    final isAuth = await _ensureAuthenticated();
    if (!isAuth) {
      print('Failed to authenticate socket');
      return;
    }
    
    print('Emitting startRun event with runSessionId: $runId');
    socket.emit('startRun', {'runSessionId': runId});
  }

  void updateLocation(String runId, Map<String, dynamic> location, bool isActive, String userId) async {
    final isAuth = await _ensureAuthenticated();
    if (!isAuth) return;
    
    socket.emit('updateLocation', {
      'runSessionId': runId,
      'location': location,
      'isActive': isActive,
      'userId': userId,
    });
  }

  void endRun(String runId, String userId) async {
    final isConnected = await _ensureAuthenticated();
    if (!isConnected) return;
    
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

  void joinRun(String runId) async {
    final isConnected = await _ensureAuthenticated();
    if (!isConnected) return;
    
    socket.emit('joinRun', {'runId': runId});
  }

  void leaveRun(String runId) async {
    final isConnected = await _ensureAuthenticated();
    if (!isConnected) return;
    
    socket.emit('leaveRun', {'runId': runId});
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
    }
    _isAuthenticated = false;
  }

  bool isConnected() {
    return _socket?.connected ?? false;
  }
}
