import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../global/session_controller.dart';
import '../../widgets/common_text.dart';
import 'controller.dart';
import 'state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Home'),
      actions: [
        TextButton.icon(
          onPressed: () => context.read<SessionController>().signOut(),
          icon: const Icon(Icons.logout),
          label: const Text('退出登录'),
        ),
      ],
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                CommonText('你好，开发者', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 8),
                CommonText(context.watch<SessionController>().state ?? ''),
                const SizedBox(height: 24),
                CommonText('我的待办', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                BlocBuilder<HomeController, HomeState>(
                  builder: (context, state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: state.todos.isEmpty
                        ? const [
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: CommonText('还没有待办，添加第一项吧'),
                              ),
                            ),
                          ]
                        : [
                            for (final todo in state.todos)
                              Card(
                                key: ValueKey('todo-${todo.id}'),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CommonText(
                                        todo.title,
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          decoration: todo.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      CommonText(
                                        todo.isCompleted ? '已完成' : '未完成',
                                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                  ),
                ),
                const SizedBox(height: 32),
                const CommonText('Codex · OpenSpec · Superpowers · Context7'),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
