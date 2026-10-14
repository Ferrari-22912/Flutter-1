import 'package:three_bhai/core/config/app_config.dart';
import 'package:three_bhai/core/error/failures.dart';
import 'package:three_bhai/models/auth_user.dart';
import 'package:three_bhai/repositories/auth_repository.dart';

/// ALPHA / DEMO: no server. The sample account
/// (chef@threebhai.app / Chef1234) opens the app with pre-filled history and
/// chat. Any other valid email + password also works.
/// Tip: an email containing "fail" previews the error state.
class MockAuthRepository implements AuthRepository {
  AuthUser? _current;

  @override
  AuthUser? get currentUser => _current;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final e = email.trim().toLowerCase();
    if (e.contains('fail')) throw const AuthenticationFailure();
    if (e == AppConfig.demoEmail && password != AppConfig.demoPassword) {
      throw const AuthenticationFailure();
    }
    return _current = _user(email, e == AppConfig.demoEmail ? 'Ahmed' : 'Chef');
  }

  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    final e = email.trim().toLowerCase();
    if (e.contains('fail') || e == AppConfig.demoEmail) {
      throw const Failure('An account with this email already exists.');
    }
    return _current = _user(email, name);
  }

  @override
  Future<void> signOut() async => _current = null;

  AuthUser _user(String email, String name) => AuthUser(
        id: 'demo-${email.trim().toLowerCase()}',
        email: email.trim(),
        displayName: name,
      );
}
