import 'package:cognito_custom_auth/usecases/errors/cognito_error.dart';

class UsernameExistsError extends CognitoError {
  UsernameExistsError({errorType, message, details})
      : super(errorType: errorType, message: message, details: details);
}
