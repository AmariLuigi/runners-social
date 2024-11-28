import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io';
import '../../features/run/data/models/location_model.dart';

class SocketService {
  IO.Socket? _socket;
  final _storage = const FlutterSecureStorage();
  bool _isConnected = false;

  SocketService() {
    _initSocket();
  }

  bool get isConnected => _isConnected;
  
  IO.Socket get socket {
    if (_socket == null) {
      throw StateError('Socket not initialized. Wait for initialization to complete.');
    }
    return _socket!;
  }

  Future<void> _initSocket() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        print('No token found');
        return;
      }

      _socket = IO.io('http://localhost:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'auth': {'token': token},
      });

      _socket!.onConnect((_) {
        print('Socket connected');
        _isConnected = true;
      });

      _socket!.onDisconnect((_) {
        print('Socket disconnected');
        _isConnected = false;
      });

      _socket!.onError((error) {
        print('Socket error: $error');
        _isConnected = false;
      });

      _socket!.onConnectError((error) {
        print('Socket connection error: $error');
        _isConnected = false;
      });

      _socket!.connect();
    } catch (e) {
      print('Error initializing socket: $e');
      _isConnected = false;
    }
  }

  Future<void> ensureConnected() async {
    if (_socket == null) {
      await _initSocket();
    }
    
    if (_socket != null && !_socket!.connected) {
      _socket!.connect();
      // Wait for connection or timeout
      for (int i = 0; i < 5; i++) {
        if (_socket!.connected) break;
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }
  }

  Future<void> joinRun(String runId) async {
    await ensureConnected();
    if (!isConnected) return;
    
    _socket!.emit('joinRun', {'runId': runId});
  }

  Future<void> startRun(String runId) async {
    await ensureConnected();
    if (!isConnected) return;
    
    final String? userId = await _storage.read(key: 'userId');
    if (userId == null) {
      throw Exception('User ID not found in storage');
    }
    
    print('Emitting startRun event with userId: $userId, runSessionId: $runId');
    _socket!.emit('startRun', {
      'userId': userId,
      'runSessionId': runId,
    });
  }

  Future<void> emitLocationUpdate({
    required String runId,
    required LocationModel location,
  }) async {
    await ensureConnected();
    if (!isConnected) return;

    final String? userId = await _storage.read(key: 'userId');
    if (userId == null) {
      throw Exception('User ID not found in storage');
    }

    _socket!.emit('locationUpdate', {
      'userId': userId,
      'runSessionId': runId,
      'location': location.toJson(),
      'isActive': true,
    });
  }

  Future<void> endRun(String runId) async {
    await ensureConnected();
    if (!isConnected) return;

    final String? userId = await _storage.read(key: 'userId');
    if (userId == null) {
      throw Exception('User ID not found in storage');
    }

    print('Emitting endRun event with runSessionId: $runId');
    _socket!.emit('endRun', {
      'userId': userId,
      'runSessionId': runId,
      'stats': {
        'distance': 0,
        'duration': 0,
        'averagePace': 0,
      },
    });
  }

  void dispose() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _isConnected = false;
    }
  }
}
