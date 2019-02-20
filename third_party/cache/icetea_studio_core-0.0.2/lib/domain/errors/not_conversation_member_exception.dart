import 'package:icetea_studio_core/domain/constants/global.dart' show StatusCodes;

class NotConversationMemberException implements Exception {
  final _message;
  final _code = StatusCodes.NOT_CONVERSATION_MEMBER;

  NotConversationMemberException([this._message]);

  String toString() {
    if (_message == null) return "NotConversationMemberException";
    return "NotConversationMemberException: $_message";
  }
}