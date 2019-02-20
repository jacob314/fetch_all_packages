import 'package:icetea_studio_core/domain/constants/global.dart' show StatusCodes;

class BadReportingRequestException implements Exception {
  final _message;
  final _code = StatusCodes.BAD_REPORTING_REQUEST;

  BadReportingRequestException([this._message]);

  String toString() {
    if (_message == null) return "BadReportingRequestException";
    return "BadReportingRequestException: $_message";
  }
}