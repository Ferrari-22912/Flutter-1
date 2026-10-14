import 'package:three_bhai/models/auth_user.dart';

/// Contract implemented in the data layer (a real backend in the final phase).
/// Implementations throw [Failure] subclasses on error.
abstract interface class AuthRepository {
  /// The signed-in user, or null.
  AuthUser? get currentUser;

  Future<AuthUser> signIn({required String email, required String password});

  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signOut();
}
