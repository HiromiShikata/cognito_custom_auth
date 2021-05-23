import 'dart:convert';

import 'package:cognito_custom_auth/usecases/errors/cognito_error.dart';
import 'package:cognito_custom_auth/usecases/errors/user_not_found_error.dart';
import 'package:cognito_custom_auth/usecases/errors/username_exists_error.dart';
import 'package:cognito_custom_auth/usecases/repositories/user_repository.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

class HttpCognitoUserRepository implements CognitoUserRepository {
  final _url = Uri.https('cognito-idp.us-east-1.amazonaws.com', '/');
  final String clientId;

  HttpCognitoUserRepository(this.clientId);

  @override
  Future<void> signIn(String email) async {
    await _callAPI('AWSCognitoIdentityProviderService.InitiateAuth', {
      'AuthParameters': {
        'USERNAME': email,
      },
      'AuthFlow': 'CUSTOM_AUTH',
      'ClientId': this.clientId,
    });
  }

  Future<void> signUp(String username, String password,
      {Map<String, String>? userAttributes}) async {
    await _callAPI('AWSCognitoIdentityProviderService.SignUp', {
      'ClientId': this.clientId,
      'Password': password,
      'UserAttributes': userAttributes != null
          ? userAttributes.entries
              .map((e) => {'Name': e.key, 'Value': e.value})
              .toList()
          : [],
      'Username': username,
    });
  }

  Future<http.Response> _callAPI(String target, Object body) async {
    final http.Response response;
    try {
      response = await http.post(_url,
          headers: {
            'X-Amz-Target': target,
            'Content-Type': 'application/x-amz-json-1.1'
          },
          body: jsonEncode(body));
    } catch (e) {
      print(e);
      throw e;
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }
    final errorType = _findErrorTypeFromResponse(response);
    if (errorType == 'UserNotFoundException:') {
      throw new UserNotFoundError(
        errorType: errorType,
        message: _findErrorMessageFromResponse(response),
        details: _findErrorDetailsFromResponse(response),
      );
    } else if (errorType == 'UsernameExistsException:') {
      throw new UsernameExistsError(
        errorType: errorType,
        message: _findErrorMessageFromResponse(response),
        details: _findErrorDetailsFromResponse(response),
      );
    }
    print(response.statusCode);
    print(response.headers);
    print(response.body);
    throw _createErrorFromResponse(response);
  }

  CognitoError _createErrorFromResponse(http.Response response) =>
      new CognitoError(
          errorType: _findErrorTypeFromResponse(response),
          message: _findErrorMessageFromResponse(response),
          details: _findErrorDetailsFromResponse(response));

  String? _findErrorTypeFromResponse(http.Response response) =>
      response.headers['x-amzn-errortype'];

  String? _findErrorMessageFromResponse(http.Response response) =>
      response.headers[''];

  String? _findErrorDetailsFromResponse(http.Response response) =>
      response.body;
}
