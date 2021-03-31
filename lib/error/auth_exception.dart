class AuthException implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "The email address is already in use by another account.",
    "OPERATION_NOT_ALLOWED": "Password sign-in is disabled for this project.",
    "TOO_MANY_ATTEMPTS_TRY_LATER":
        "We have blocked all requests from this device due to unusual activity. Try again later.",
    "EMAIL_NOT_FOUND":
        "There is no user record corresponding to this identifier. The user may have been deleted.",
    "INVALID_EMAIL":
        "The e-mail/password is invalid or the user does not have a e-mail / password.",
    "INVALID_PASSWORD":
        "The e-mail/password is invalid or the user does not have a e-mail / password.",
    "WEAK_PASSWORD": "Password should be at least 6 characters.",
    "USER_DISABLED": "The user account has been disabled by an administrator.",
  };

  final String key;

  const AuthException({this.key});

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    } else {
      return "An Unknow error occured!";
    }
  }
}
