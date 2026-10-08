part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}


// =========================
// Sign In States
// =========================

class SignInSuccess extends AuthState {
  final ClsSignInResponseDTO response;

  SignInSuccess(this.response);
}

class SignInInvalidCredentials extends AuthState {}

class SignInTooManyRequests extends AuthState {}

class SignInInternalServerError extends AuthState {}

class SignInFailure extends AuthState {
  final int statusCode;

  SignInFailure(this.statusCode);
}


// =========================
// Sign Up States
// =========================

class SignUpSuccess extends AuthState {}

class SignUpEmailAlreadyExists extends AuthState {}

class SignUpTooManyRequests extends AuthState {}

class SignUpInternalServerError extends AuthState {}

class SignUpFailure extends AuthState {
  final int statusCode;

  SignUpFailure(this.statusCode);
}

// =========================
// Logout States
// =========================
class LogoutSuccess extends AuthState {}

class LogoutFailure extends AuthState {
  final int statusCode;

  LogoutFailure(this.statusCode);
}

class LogoutTooManyRequests extends AuthState {}

class LogoutInternalServerError extends AuthState {}

class LogoutBadRequest extends AuthState {}

