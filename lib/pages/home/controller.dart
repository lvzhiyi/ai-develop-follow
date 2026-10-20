import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../global/session_controller.dart';
import 'model.dart';
import 'state.dart';

/// Owns a page-local snapshot; production starts with no records.
class HomeController extends Cubit<HomeState> {
  HomeController({SessionController? session, Iterable<TodoItem> initialTodos = const []})
    : super(HomeState(todos: initialTodos)) {
    // Observe every transition, including logout/login with the same email.
    _sessionSubscription = session?.sessionChanges.listen((_) => emit(HomeState()));
  }

  StreamSubscription<void>? _sessionSubscription;

  @override
  Future<void> close() async {
    await _sessionSubscription?.cancel();
    await super.close();
  }
}
