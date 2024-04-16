abstract class BaseAuth {
  Future<dynamic> login(
      String username, String password, String firstName, String lastName);
}
