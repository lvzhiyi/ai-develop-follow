class LoginState {
  const LoginState({this.isLoading = false, this.obscurePassword = true, this.error});
  final bool isLoading;
  final bool obscurePassword;
  final String? error;
}
