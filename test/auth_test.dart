import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ai_template/data/auth/auth_repository.dart';
import 'package:flutter_ai_template/global/session_controller.dart';
import 'package:flutter_ai_template/pages/login/controller.dart';
import 'package:flutter_ai_template/pages/home/controller.dart';

class PendingAuth implements AuthRepository {
  final result = Completer<String>();
  int calls = 0;
  @override
  Future<String> login({required String email, required String password}) {
    calls++;
    return result.future;
  }
}

void main() {
  test('demo login accepts the documented credentials', () async {
    expect(
      await DemoAuthRepository().login(email: ' demo@example.com ', password: 'demo12345'),
      'demo@example.com',
    );
  });
  test('demo login rejects incorrect credentials', () async {
    await expectLater(
      DemoAuthRepository().login(email: 'demo@example.com', password: 'incorrect'),
      throwsA(isA<AuthException>()),
    );
  });
  test('submit is guarded against duplicates and updates the session', () async {
    final auth = PendingAuth();
    final session = SessionController();
    final controller = LoginController(authRepository: auth, session: session);
    final pending = controller.submit('demo@example.com', 'demo12345');
    await controller.submit('demo@example.com', 'demo12345');
    expect(auth.calls, 1);
    expect(controller.state.isLoading, true);
    auth.result.complete('demo@example.com');
    await pending;
    expect(session.isAuthenticated, true);
    expect(controller.state.isLoading, false);
    await controller.close();
    await session.close();
  });
  test('failed submit clears loading and allows retry', () async {
    final auth = PendingAuth();
    final session = SessionController();
    final controller = LoginController(authRepository: auth, session: session);
    final pending = controller.submit('demo@example.com', 'wrong');
    auth.result.completeError(const AuthException('Invalid credentials'));
    await pending;
    expect(controller.state.isLoading, false);
    expect(controller.state.error, 'Invalid credentials');
    expect(session.isAuthenticated, false);
    await controller.close();
    await session.close();
  });
  test('a late login result cannot sign in after its controller is closed', () async {
    final auth = PendingAuth();
    final session = SessionController();
    final controller = LoginController(authRepository: auth, session: session);
    final pending = controller.submit('demo@example.com', 'demo12345');
    await controller.close();
    auth.result.complete('demo@example.com');
    await pending;
    expect(session.isAuthenticated, false);
    await session.close();
  });
  test('sign out clears memory and a new session starts logged out', () async {
    final session = SessionController();
    session.signIn('demo@example.com');
    session.signOut();
    expect(session.state, isNull);
    final fresh = SessionController();
    expect(fresh.isAuthenticated, false);
    await session.close();
    await fresh.close();
  });
  test('home starts with an empty page-local todo snapshot', () async {
    final home = HomeController();
    expect(home.state.todos, isEmpty);
    await home.close();
  });
}
