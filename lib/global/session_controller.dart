import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Memory-only demo session. Authentication on a server must be enforced by that server.
class SessionController extends Cubit<String?> {
  SessionController() : super(null);

  final _sessionChanges = StreamController<void>.broadcast(sync: true);

  /// Every explicit session boundary, even when the new email equals the old one.
  /// Consumers must not trigger another session change from this callback.
  Stream<void> get sessionChanges => _sessionChanges.stream;

  bool get isAuthenticated => state != null;

  void signIn(String email) {
    emit(email);
    _sessionChanges.add(null);
  }

  void signOut() {
    emit(null);
    _sessionChanges.add(null);
  }

  @override
  Future<void> close() async {
    await _sessionChanges.close();
    await super.close();
  }
}
