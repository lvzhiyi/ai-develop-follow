import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/auth/auth_repository.dart';
import '../../global/session_controller.dart';
import 'controller.dart';
import 'view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => LoginController(
      authRepository: context.read<AuthRepository>(),
      session: context.read<SessionController>(),
    ),
    child: const LoginView(),
  );
}
