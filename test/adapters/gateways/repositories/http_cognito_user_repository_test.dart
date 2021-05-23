import 'package:cognito_custom_auth/adapters/gateways/repositories/http_cognito_user_repository.dart';
import 'package:cognito_custom_auth/usecases/errors/username_exists_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:random_string/random_string.dart';

void main() {
  const cognito_user_pool_client_id = '2mfvavfcn6bel8t888efcvruqn';
  final repository = HttpCognitoUserRepository(cognito_user_pool_client_id);
  final email =
      'autotest+cognitocustomauth-newuser+${DateTime.now().millisecondsSinceEpoch}@uminoseisaku.com';
  test('CognitoUserRepository - signUp - successful', () async {
    await repository
        .signUp(email, randomAlphaNumeric(30), userAttributes: {'name': email});
  });
  // test('CognitoUserRepository - signUp - exists', () async {
  //   try {
  //     await repository.signUp(email, randomAlphaNumeric(30),
  //         userAttributes: {'name': email});
  //     fail('should throw UsernameExistsError');
  //   } on UsernameExistsError catch (e) {
  //     expect(e.errorType, 'UsernameExistsException:');
  //     expect(e.message, null);
  //     expect(e.details,
  //         '{"__type":"UsernameExistsException","message":"An account with the given email already exists."}');
  //   } catch (e) {
  //     throw e;
  //   }
  // });
  // test('CognitoUserRepository - signIn - successful', () async {
  //   final email =
  //       'autotest+cognitocustomauth-newuser1@uminoseisaku.com';
  //   await repository.signIn(email);
  // });
}
