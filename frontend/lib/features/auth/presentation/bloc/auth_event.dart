part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.checkAuthStatus() = CheckAuthStatus;
  
  const factory AuthEvent.login({
    required String email,
    required String password,
  }) = Login;
  
  const factory AuthEvent.register({
    required String email,
    required String password,
    required String username,
  }) = Register;
  
  const factory AuthEvent.logout() = Logout;
  
  const factory AuthEvent.updateProfile({
    String? username,
    String? bio,
    String? profileImageUrl,
  }) = UpdateProfile;
  
  const factory AuthEvent.resetPassword({
    required String email,
  }) = ResetPassword;
  
  const factory AuthEvent.verifyEmail({
    required String token,
  }) = VerifyEmail;
  
  const factory AuthEvent.refreshToken() = RefreshToken;
}
