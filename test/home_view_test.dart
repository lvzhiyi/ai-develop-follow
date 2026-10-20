import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ai_template/global/session_controller.dart';
import 'package:flutter_ai_template/pages/home/controller.dart';
import 'package:flutter_ai_template/pages/home/model.dart';
import 'package:flutter_ai_template/pages/home/view.dart';
import 'package:flutter_ai_template/resources/theme.dart';

const fixtures = [
  TodoItem(id: 1, title: '重复标题', isCompleted: true, creationOrder: 1),
  TodoItem(id: 2, title: '重复标题', creationOrder: 2),
  TodoItem(id: 3, title: '最新任务', creationOrder: 3),
];

Future<void> showHome(
  WidgetTester tester, {
  List<TodoItem> todos = fixtures,
  ThemeMode mode = ThemeMode.light,
}) async {
  final session = SessionController()..signIn('demo@example.com');
  final home = HomeController(initialTodos: todos, session: session);
  addTearDown(home.close);
  addTearDown(session.close);
  await tester.pumpWidget(
    BlocProvider.value(
      value: session,
      child: BlocProvider.value(
        value: home,
        child: MaterialApp(
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: mode,
          home: const HomeView(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('real view shows fixture titles, states and creation order', (tester) async {
    await showHome(tester);
    expect(find.text('重复标题'), findsNWidgets(2));
    expect(find.text('已完成'), findsOneWidget);
    expect(find.text('未完成'), findsNWidgets(2));
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('todo-3'))).dy,
      lessThan(tester.getTopLeft(find.byKey(const ValueKey('todo-2'))).dy),
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('todo-2'))).dy,
      lessThan(tester.getTopLeft(find.byKey(const ValueKey('todo-1'))).dy),
    );
    expect(find.text('demo@example.com'), findsOneWidget);
    expect(find.text('退出登录'), findsOneWidget);
    expect(find.textContaining('Cubit 示例'), findsNothing);
    expect(find.byType(Checkbox), findsNothing);
    expect(find.text('还没有待办，添加第一项吧'), findsNothing);
  });

  testWidgets('empty fixture renders required empty message', (tester) async {
    await showHome(tester, todos: []);
    expect(find.text('还没有待办，添加第一项吧'), findsOneWidget);
    expect(find.text('我的待办'), findsOneWidget);
  });

  testWidgets('retained view clears old tasks after identity replacement', (tester) async {
    await showHome(tester);
    tester.element(find.byType(HomeView)).read<SessionController>().signIn('next@example.com');
    await tester.pumpAndSettle();
    expect(find.text('重复标题'), findsNothing);
    expect(find.text('next@example.com'), findsOneWidget);
    expect(find.text('还没有待办，添加第一项吧'), findsOneWidget);
  });

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('320px, keyboard and enlarged text remain scrollable in $mode', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      tester.view.viewInsets = const FakeViewPadding(bottom: 220);
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await showHome(
        tester,
        mode: mode,
        todos: [
          ...fixtures,
          const TodoItem(id: 4, title: '这是一条很长的任务标题用于验证窄屏与文字放大后的自动换行和滚动可达性', creationOrder: 4),
        ],
      );
      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('todo-1')),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.byKey(const ValueKey('todo-1')).hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
