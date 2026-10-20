import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/auth/auth_repository.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_form_field.dart';
import 'controller.dart';
import 'state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      context.read<LoginController>().submit(_email.text, _password.text);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: BlocBuilder<LoginController, LoginState>(
              builder: (context, state) => Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.auto_awesome,
                        size: 44,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CommonText('欢迎回来', style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 8),
                    const CommonText('Flutter AI Template · 从一个干净的起点开始'),
                    const SizedBox(height: 32),
                    CommonTextFormField(
                      controller: _email,
                      label: '邮箱',
                      enabled: !state.isLoading,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value != null &&
                              RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())
                          ? null
                          : '请输入有效邮箱',
                    ),
                    const SizedBox(height: 16),
                    CommonTextFormField(
                      controller: _password,
                      label: '密码',
                      enabled: !state.isLoading,
                      obscureText: state.obscurePassword,
                      onFieldSubmitted: (_) => _submit(),
                      validator: (value) => value != null && value.length >= 8 ? null : '密码至少 8 位',
                      suffixIcon: IconButton(
                        tooltip: state.obscurePassword ? '显示密码' : '隐藏密码',
                        onPressed: () => context.read<LoginController>().togglePassword(),
                        icon: Icon(
                          state.obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    if (state.error != null) ...[
                      const SizedBox(height: 16),
                      Semantics(
                        liveRegion: true,
                        child: CommonText(
                          state.error!,
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    CommonButton(label: '登录', onPressed: _submit, isLoading: state.isLoading),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CommonText('本地演示，不连接业务后台'),
                            const SizedBox(height: 8),
                            const SelectableText(
                              '${DemoAuthRepository.email} / ${DemoAuthRepository.password}',
                            ),
                            TextButton(
                              onPressed: state.isLoading
                                  ? null
                                  : () {
                                      _email.text = DemoAuthRepository.email;
                                      _password.text = DemoAuthRepository.password;
                                    },
                              child: const Text('填入演示账号'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
