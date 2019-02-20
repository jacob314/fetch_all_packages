
class EventDetails {
  int code;
  String description ;

  static final int FORCEFUL_DISCONNECTION = 101,
      EXTERNAL_DISCONNECTION = 201,
      INTERPRET_ERROR = 202,
      PACKETPROCESSING_FAILED = 203,
      DECODING_FAILED = 204,
      UNABLE_TO_CONNECT = 301;

  static int getForcefulDisconnection() {
    return FORCEFUL_DISCONNECTION;
  }

  int getCode() {
    return code;
  }

  void setCode(int code) {
    this.code = code;
  }

  String getDescription() {
    return description;
  }

  void setDescription(String description) {
    this.description = description;
  }
}