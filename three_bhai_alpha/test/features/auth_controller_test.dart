import 'package:flutter_test/flutter_test.dart';
import 'package:three_bhai/controllers/auth_controller.dart';
import 'package:three_bhai/controllers/auth_state.dart';
import 'package:three_bhai/repositories/mock_auth_repository.dart';

void main() {
  late AuthController controller;

  setUp(() => controller = AuthController(MockAuthRepository()));
  tearDown(() => controller.onDelete());

  test('sign in updates reactive state from loading to success', () async {
    final request = controller.signIn(
      email: 'chef@3bhai.app',
      password: 'secret123',
    );
    expect(controller.state, isA<AuthLoading>());
    await request;
    expect(controller.state, isA<AuthSuccess>());
    expect(controller.observable.value, same(controller.state));
  });

  test('sign in updates reactive state from loading to failure', () async {
    final request = controller.signIn(
      email: 'fail@3bhai.app',
      password: 'secret123',
    );
    expect(controller.state, isA<AuthLoading>());
    await request;
    expect(controller.state, isA<AuthFailure>());
  });

  test(
    'sign up returns the new user and sign out clears the session',
    () async {
      await controller.signUp(
        name: 'Ali',
        email: 'ali@example.com',
        password: 'Chef1234',
      );
      expect((controller.state as AuthSuccess).user.displayName, 'Ali');
      await controller.signOut();
      expect(controller.state, isA<AuthInitial>());
    },
  );

  test('completion does not update a disposed controller', () async {
    final request = controller.signIn(
      email: 'chef@3bhai.app',
      password: 'secret123',
    );
    controller.onDelete();
    await request;
    expect(controller.state, isA<AuthLoading>());
  });
}
