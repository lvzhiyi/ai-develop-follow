import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/auth/auth_repository.dart';
import '../../global/session_controller.dart';
import 'state.dart';

class LoginController extends Cubit<LoginState> {
  LoginController({required AuthRepository authRepository, required SessionController session})
    : _authRepository = authRepository,
      _session = session,
      super(const LoginState());

  final AuthRepository _authRepository;
  final SessionController _session;

  void togglePassword() => emit(
    LoginState(
      isLoading: state.isLoading,
      obscurePassword: !state.obscurePassword,
      error: state.error,
    ),
  );

  Future<void> submit(String email, String password) async {
    if (state.isLoading) return;
    emit(LoginState(isLoading: true, obscurePassword: state.obscurePassword));
    try {
      final user = await _authRepository.login(email: email, password: password);
      if (isClosed) return;
      emit(LoginState(obscurePassword: state.obscurePassword));
      _session.signIn(user);
    } on AuthException catch (error) {
      if (!isClosed) {
        emit(LoginState(obscurePassword: state.obscurePassword, error: error.message));
      }
    } catch (_) {
      if (!isClosed) {
        emit(LoginState(obscurePassword: state.obscurePassword, error: '登录暂时不可用，请重试'));
      }
    }
  }
}
