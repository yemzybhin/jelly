enum StatusCode {
  success,
  userError,
  inaccessibleResource,
  expiredToken,
  invalidHeader,
  serverError,
  userInvalidResponse,
  noInternet,
  invalidFormat,
  unknownError
}

extension StatusCodeExtension on StatusCode {
  int get code {
    switch (this) {
      case StatusCode.success:
        return 201;
      case StatusCode.userError:
        return 401;
      case StatusCode.inaccessibleResource:
        return 402;
      case StatusCode.expiredToken:
        return 403;
      case StatusCode.invalidHeader:
        return 404;
      case StatusCode.serverError:
        return 500;
      case StatusCode.userInvalidResponse:
        return 100;
      case StatusCode.noInternet:
        return 101;
      case StatusCode.invalidFormat:
        return 102;
      case StatusCode.unknownError:
        return 103;
    }
  }
}