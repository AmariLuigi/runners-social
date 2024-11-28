class ApiConstants {
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  
  // Run endpoints
  static const String runs = '/runs';
  static const String activeRuns = '/runs/active';
  static const String joinRun = '/runs/{id}/join';
  static const String leaveRun = '/runs/{id}/leave';
  static const String startRun = '/runs/{id}/start';
  static const String endRun = '/runs/{id}/end';
  static const String updateLocation = '/runs/{id}/location';
  
  // User endpoints
  static const String users = '/users';
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile';
  
  // Chat endpoints
  static const String chat = '/chat';
  static const String chatMessages = '/chat/messages';
  
  static String getEndpoint(String endpoint, String id) {
    return endpoint.replaceAll('{id}', id);
  }
}
