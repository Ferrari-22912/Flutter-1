import 'package:get/get.dart';
import 'package:three_bhai/controllers/auth_state.dart';
import 'package:three_bhai/core/error/failures.dart';
import 'package:three_bhai/models/auth_user.dart';
import 'package:three_bhai/repositories/auth_repository.dart';

/// Lecture 3: the controller owns state, while the repository owns data access.
class AuthController extends GetxController {
  AuthController(this._repository);

  final AuthRepository _repository;
  final observable = Rx<AuthState>(const AuthInitial());
  AuthState get state => observable.value;

  void _updateState(AuthState next) {
    if (!isClosed) observable.value = next;
  }

  Future<void> signIn({required String email, required String password}) =>
      _run(() => _repository.signIn(email: email, password: password));

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) =>
      _run(
        () => _repository.signUp(name: name, email: email, password: password),
      );

  Future<void> signOut() async {
    await _repository.signOut();
    _updateState(const AuthInitial());
  }

  Future<void> _run(Future<AuthUser> Function() action) async {
    if (state is AuthLoading || isClosed) return;
    _updateState(const AuthLoading());
    try {
      _updateState(AuthSuccess(await action()));
    } on Failure catch (e) {
      _updateState(AuthFailure(e.message));
    } catch (_) {
      _updateState(
        const AuthFailure('Something went wrong. Please try again.'),
      );
    }
  }
}
