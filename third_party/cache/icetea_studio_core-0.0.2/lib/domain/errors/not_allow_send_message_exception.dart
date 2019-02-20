import 'package:icetea_studio_core/domain/constants/global.dart' show StatusCodes;
class NotAllowedSendMessageException implements Exception {
    final _message;
    final _code = StatusCodes.NOT_ALLOWED_SEND_MESSAGE;

    NotAllowedSendMessageException([this._message]);

    String toString() {
        if (_message == null) return "NotAllowedSendMessageException";
        return "NotAllowedSendMessageException: $_message";
    }
}