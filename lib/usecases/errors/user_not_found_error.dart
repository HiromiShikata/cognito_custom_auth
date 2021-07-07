import 'package:cognito_custom_auth/usecases/errors/cognito_error.dart';

class UserNotFoundError extends CognitoError {
  UserNotFoundError({errorType, message, details})
      : super(errorType: errorType, message: message, details: details);
}
