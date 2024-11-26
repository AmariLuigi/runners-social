import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io';
import '../../features/run/data/models/location_model.dart';

class SocketService {
  static const String baseUrl = 'http://localhost:3000';
  IO.Socket? _socket;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isAuthenticated = false;
  bool _isEndingRun = false;
  String? _userId;

  IO.Socket get socket {
    if (_socket == null) {
      throw StateError('Socket not initialized. Call connect() first.');
    }
    return _socket!;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Invalid base64 string');
    }
    return output;
  }

  Future<void> connect() async {
    if (_socket != null) {
      print('Socket already connected');
      return;
    }

    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        print('No token found in storage with key: token');
        throw Exception('No auth token found');
      }

      print('Found token: ${token.substring(0, token.length < 20 ? token.length : 20)}...');

      // Decode the JWT token to get the userId
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid token format');
      }

      try {
        final normalizedPayload = _decodeBase64(parts[1]);
        final payloadJson = utf8.decode(base64.decode(normalizedPayload));
        final payload = json.decode(payloadJson);
        _userId = payload['userId'];

        if (_userId == null) {
          throw Exception('No userId found in token');
        }

        print('Connecting socket with userId: $_userId');

        // Remove 'Bearer ' prefix if present
        final cleanToken = token.replaceAll('Bearer ', '');

        _socket = IO.io(
          baseUrl,
          IO.OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({'authorization': 'Bearer $cleanToken'})
            .setAuth({'token': cleanToken})
            .enableAutoConnect()
            .enableReconnection()
            .build(),
        );

        _setupSocketListeners();
        
        // Wait for connection
        bool connected = false;
        for (int i = 0; i < 5; i++) {
          await Future.delayed(const Duration(seconds: 1));
          if (_socket?.connected == true) {
            connected = true;
            break;
          }
        }

        if (!connected) {
          throw Exception('Failed to connect to socket server after 5 seconds');
        }

      } catch (e) {
        print('Error decoding token or connecting: $e');
        rethrow;
      }
    } catch (e) {
      print('Socket connection error: $e');
      rethrow;
    }
  }

  void _setupSocketListeners() {
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

  Future<void> emitLocationUpdate(
    String runId,
    LocationModel location,
    {bool isActive = true}
  ) async {
    try {
      if (!isConnected) {
        throw SocketException('Socket is not connected');
      }

      _socket?.emit('locationUpdate', {
        'runSessionId': runId,
        'location': location.toJson(),
        'isActive': isActive,
      });
    } catch (e) {
      print('Error emitting location update: $e');
      rethrow;
    }
  }

  Future<void> endRun(String runId, String userId, [Map<String, dynamic>? stats]) async {
    if (_isEndingRun) {
      print('Run end already in progress');
      return;
    }

    try {
      _isEndingRun = true;
      print('Ending run: $runId for user: $userId with stats: $stats');

      final isAuth = await _ensureAuthenticated();
      if (!isAuth) {
        print('Failed to authenticate socket for ending run');
        return;
      }
      
      socket.emit('endRun', {
        'runSessionId': runId,
        'userId': userId,
        'finalStats': stats,
      });

      // Wait for server acknowledgment
      await Future.delayed(const Duration(seconds: 2));
    } finally {
      _isEndingRun = false;
    }
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

  bool get isConnected => _socket?.connected ?? false;
}

class LocationData {
  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;

  LocationData({required this.latitude, required this.longitude, required this.altitude, required this.speed});
}
