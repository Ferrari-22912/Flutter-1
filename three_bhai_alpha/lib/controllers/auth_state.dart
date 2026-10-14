import 'package:three_bhai/models/auth_user.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);
  final AuthUser user;
}

final class AuthFailure extends AuthState {
  const AuthFailure(this.message);
  final String message;
}
