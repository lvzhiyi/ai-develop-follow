import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_ai_template/app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ai_template/pages/home/controller.dart';
import 'package:flutter_ai_template/pages/home/state.dart';
import 'package:flutter_ai_template/pages/home/model.dart';
import 'package:flutter_ai_template/pages/home/view.dart';

Future<void> signIn(WidgetTester tester) async {
  await tester.tap(find.text('填入演示账号'));
  await tester.tap(find.widgetWithText(FilledButton, '登录'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('unauthenticated home redirects to login', (tester) async {
    await tester.pumpWidget(const TemplateApp());
    await tester.pumpAndSettle();
    expect(find.text('欢迎回来'), findsOneWidget);
    final context = tester.element(find.byType(Form));
    GoRouter.of(context).go('/home');
    await tester.pumpAndSettle();
    expect(find.text('欢迎回来'), findsOneWidget);
  });
  testWidgets('empty or malformed fields cannot sign in', (tester) async {
    await tester.pumpWidget(const TemplateApp());
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '登录'));
    await tester.pumpAndSettle();
    expect(find.text('请输入有效邮箱'), findsOneWidget);
    expect(find.text('密码至少 8 位'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
  });
  testWidgets('wrong password shows actual controller error', (tester) async {
    await tester.pumpWidget(const TemplateApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('填入演示账号'));
    await tester.enterText(find.byType(TextFormField).last, 'incorrect');
    await tester.tap(find.widgetWithText(FilledButton, '登录'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('邮箱或密码错误，请使用下方演示账号'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
  });
  testWidgets('login, empty todos and logout form a real widget flow', (tester) async {
    await tester.pumpWidget(const TemplateApp());
    await tester.pumpAndSettle();
    await signIn(tester);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('demo@example.com'), findsOneWidget);
    expect(find.text('还没有待办，添加第一项吧'), findsOneWidget);
    expect(find.textContaining('Cubit 示例'), findsNothing);
    final firstHome = tester.element(find.byType(HomeView)).read<HomeController>();
    // Test-only snapshot injection; production routes always create an empty controller.
    firstHome.emit(HomeState(todos: const [TodoItem(id: 1, title: '旧会话任务', creationOrder: 1)]));
    await tester.pumpAndSettle();
    expect(find.text('旧会话任务'), findsOneWidget);
    await tester.tap(find.text('退出登录'));
    await tester.pumpAndSettle();
    expect(find.text('欢迎回来'), findsOneWidget);
    GoRouter.of(tester.element(find.byType(Form))).go('/home');
    await tester.pumpAndSettle();
    expect(find.text('欢迎回来'), findsOneWidget);
    // Stream cancellation completes outside the fake frame clock.
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    expect(firstHome.isClosed, true);
    await signIn(tester);
    expect(find.text('旧会话任务'), findsNothing);
    expect(find.text('还没有待办，添加第一项吧'), findsOneWidget);
    expect(
      identical(firstHome, tester.element(find.byType(HomeView)).read<HomeController>()),
      false,
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const TemplateApp());
    await tester.pumpAndSettle();
    expect(find.text('欢迎回来'), findsOneWidget);
    await signIn(tester);
    expect(find.text('旧会话任务'), findsNothing);
    expect(find.text('还没有待办，添加第一项吧'), findsOneWidget);
  });
  testWidgets('password visibility can be toggled', (tester) async {
    await tester.pumpWidget(const TemplateApp());
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(find.byType(TextField).last).obscureText, true);
    await tester.tap(find.byTooltip('显示密码'));
    await tester.pump();
    expect(tester.widget<TextField>(find.byType(TextField).last).obscureText, false);
  });
  testWidgets('small screen, keyboard inset and scaled text do not overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 220);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const TemplateApp(themeMode: ThemeMode.dark));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('填入演示账号'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    expect(tester.takeException(), isNull);
  });
}
