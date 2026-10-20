import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ai_template/global/session_controller.dart';
import 'package:flutter_ai_template/pages/home/controller.dart';
import 'package:flutter_ai_template/pages/home/model.dart';

const fixtures = [
  TodoItem(id: 1, title: '同名任务', isCompleted: true, creationOrder: 1),
  TodoItem(id: 3, title: '后创建任务', creationOrder: 3),
  TodoItem(id: 2, title: '同名任务', creationOrder: 2),
];

void main() {
  test('production controller starts empty', () async {
    final home = HomeController();
    expect(home.state.todos, isEmpty);
    await home.close();
  });

  test('same titles retain stable identity and newest creation order', () async {
    final home = HomeController(initialTodos: fixtures);
    expect(home.state.todos.map((item) => item.id), [3, 2, 1]);
    expect(home.state.todos.map((item) => item.creationOrder), [3, 2, 1]);
    expect(home.state.todos.where((item) => item.title == '同名任务'), hasLength(2));
    expect(home.state.todos.last.isCompleted, true);
    expect(identical(home.state.todos.last, fixtures.first), true);
    await home.close();
  });

  test('snapshots copy input and reject external list mutations', () async {
    final input = fixtures.toList();
    final home = HomeController(initialTodos: input);
    final snapshot = home.state;
    input.clear();
    expect(snapshot.todos, hasLength(3));
    expect(() => snapshot.todos.clear(), throwsUnsupportedError);
    expect(() => snapshot.todos[0] = fixtures.first, throwsUnsupportedError);
    await home.close();
  });

  test('duplicate identities are rejected even with different titles', () {
    expect(
      () => HomeController(
        initialTodos: [
          fixtures.first,
          const TodoItem(id: 1, title: '不同标题', creationOrder: 9),
        ],
      ),
      throwsArgumentError,
    );
  });

  test('session boundary immediately followed by disposal cancels safely', () async {
    final session = SessionController()..signIn('demo@example.com');
    final home = HomeController(session: session, initialTodos: fixtures);
    session.signOut();
    expect(home.state.todos, isEmpty);
    await home.close();
    session.signIn('demo@example.com');
    await session.close();
    expect(home.isClosed, true);
  });

  for (final change in [
    'logout',
    'replace identity',
    'same-email relogin',
    'same-email replacement',
  ]) {
    test('$change clears existing records without requiring page disposal', () async {
      final session = SessionController()..signIn('demo@example.com');
      // Drain the initial broadcast event before attaching the Home subscriber.
      await Future<void>.delayed(Duration.zero);
      final home = HomeController(session: session, initialTodos: fixtures);
      final oldSnapshot = home.state;
      if (change == 'same-email replacement') {
        session.signIn('demo@example.com');
      } else if (change == 'replace identity') {
        session.signIn('another@example.com');
      } else {
        session.signOut();
        if (change == 'same-email relogin') session.signIn('demo@example.com');
      }
      await Future<void>.delayed(Duration.zero);
      expect(home.state.todos, isEmpty);
      expect(oldSnapshot.todos, hasLength(3));
      await home.close();
      session.signIn('after-close@example.com');
      await Future<void>.delayed(Duration.zero);
      await session.close();
    });
  }
}
