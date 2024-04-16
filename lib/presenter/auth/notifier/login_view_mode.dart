import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel();
});

class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(LoginState());

  void updateFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void updateLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  bool validateFields() {
    if (state.firstName.isEmpty ||
        state.lastName.isEmpty ||
        state.username.isEmpty ||
        state.password.isEmpty) {
      return false;
    }
    return true;
  }

  void login() {
    print('Logging in with username: ${state.username}');
    // Add your login logic here
  }
}

class LoginState {
  final String firstName;
  final String lastName;
  final String username;
  final String password;

  LoginState({
    this.firstName = '',
    this.lastName = '',
    this.username = '',
    this.password = '',
  });

  LoginState copyWith({
    String? firstName,
    String? lastName,
    String? username,
    String? password,
  }) {
    return LoginState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
