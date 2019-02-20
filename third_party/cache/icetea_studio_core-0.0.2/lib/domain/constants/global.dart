class StatusCodes {
  static const UNKNOWN_ERROR = 0,
      SUCCESS = 1,
      ITEM_NOT_FOUND = 2,
      AUTH_ERROR = 3,
      MISSING_AUTH_TOKEN = 4,
      TOKEN_INVALID = 5,
      NOT_AUTHORIZED = 6,

      //Socket status codes
      NOT_CONVERSATION_MEMBER = 7,
      USER_UNAVAILABLE = 8,
      BAD_REPORTING_REQUEST = 9,
      NOT_ALLOWED_SEND_MESSAGE = 10;
}


class CacheKeys {
  static const JWT = 'jwt';
}

const Duration HTTP_TIMEOUT = const Duration(seconds: 30);