import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../global/session_controller.dart';
import 'controller.dart';
import 'view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => HomeController(session: context.read<SessionController>()),
    child: const HomeView(),
  );
}
