import 'package:icetea_studio_core/domain/errors/item_not_found_exception.dart';
import 'package:icetea_studio_core/domain/errors/missing_token_exception.dart';
import 'package:icetea_studio_core/domain/errors/network_timeout_exception.dart';
import 'package:icetea_studio_core/domain/errors/not_authorized_exception.dart';
import 'package:icetea_studio_core/domain/errors/token_invalid_exception.dart';
import 'package:icetea_studio_core/domain/errors/unauthenticated_exception.dart';
import 'package:icetea_studio_core/domain/services/logger/logger_manager.dart';

abstract class BaseServiceImpl {

  LoggerManager logger;

  BaseServiceImpl(this.logger);

  handleError(e) {
    switch (e.runtimeType) {
      case ItemNotFoundException:
      case UnAuthenticatedException:
      case MissingTokenException:
      case TokenInvalidException:
      case NotAuthorizedException:
      case NetworkTimeoutException:
        throw e;

      default:
        logger.log("BaseService", e.toString());
    }
  }
}
