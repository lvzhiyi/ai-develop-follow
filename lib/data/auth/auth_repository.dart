/// Replace this boundary with a real API implementation when adding authentication.
abstract interface class AuthRepository {
  Future<String> login({required String email, required String password});
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
}

/// Local demonstration only: no server, tokens, persisted session or password storage.
class DemoAuthRepository implements AuthRepository {
  static const email = 'demo@example.com';
  static const password = 'demo12345';

  @override
  Future<String> login({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (email.trim().toLowerCase() != DemoAuthRepository.email ||
        password != DemoAuthRepository.password) {
      throw const AuthException('邮箱或密码错误，请使用下方演示账号');
    }
    return DemoAuthRepository.email;
  }
}
