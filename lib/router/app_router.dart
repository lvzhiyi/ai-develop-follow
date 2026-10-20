import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../global/session_controller.dart';
import '../pages/home/page.dart';
import '../pages/login/page.dart';

class SessionRefresh extends ChangeNotifier {
  SessionRefresh(SessionController session) {
    _subscription = session.stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<String?> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter createRouter(SessionController session, SessionRefresh refresh) => GoRouter(
  initialLocation: '/home',
  refreshListenable: refresh,
  redirect: (context, state) {
    final atLogin = state.matchedLocation == '/login';
    if (!session.isAuthenticated) return atLogin ? null : '/login';
    if (atLogin || state.matchedLocation == '/') return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/', redirect: (_, _) => '/home'),
    GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
    GoRoute(path: '/home', builder: (_, _) => const HomePage()),
  ],
);
