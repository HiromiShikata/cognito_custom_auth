class CognitoError extends Error {
  CognitoError({this.errorType, this.message, this.details});

  final String? errorType;
  final String? message;
  final String? details;
}
