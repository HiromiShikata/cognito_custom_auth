abstract class CognitoUserRepository {
  Future<void> signIn(String email);

  Future<void> signUp(String username, String password,
      {Map<String, String>? userAttributes});
}
