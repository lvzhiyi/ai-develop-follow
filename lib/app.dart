import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'data/auth/auth_repository.dart';
import 'global/session_controller.dart';
import 'resources/theme.dart';
import 'router/app_router.dart';

class TemplateApp extends StatefulWidget {
  const TemplateApp({super.key, this.authRepository, this.themeMode = ThemeMode.system});
  final AuthRepository? authRepository;
  final ThemeMode themeMode;
  @override
  State<TemplateApp> createState() => _TemplateAppState();
}

class _TemplateAppState extends State<TemplateApp> {
  late final SessionController _session;
  late final SessionRefresh _refresh;
  late final GoRouter _router;
  late final AuthRepository _repository;

  @override
  void initState() {
    super.initState();
    _session = SessionController();
    _repository = widget.authRepository ?? DemoAuthRepository();
    _refresh = SessionRefresh(_session);
    _router = createRouter(_session, _refresh);
  }

  @override
  void dispose() {
    _router.dispose();
    _refresh.dispose();
    _session.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepositoryProvider<AuthRepository>.value(
    value: _repository,
    child: BlocProvider.value(
      value: _session,
      child: MaterialApp.router(
        title: 'Flutter AI Template',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: widget.themeMode,
        routerConfig: _router,
      ),
    ),
  );
}
