import 'dart:async';

import 'package:icetea_studio_core/domain/errors/missing_token_exception.dart';
import 'package:icetea_studio_core/domain/errors/network_timeout_exception.dart';
import 'package:icetea_studio_core/domain/errors/not_authorized_exception.dart';
import 'package:icetea_studio_core/domain/errors/token_invalid_exception.dart';
import 'package:icetea_studio_core/domain/errors/unauthenticated_exception.dart';
import 'package:icetea_studio_core/domain/services/logger/logger_manager.dart';
import 'package:icetea_studio_core/ui/base/base_view_contract.dart';

abstract class BasePresenter<T extends IBaseViewContract> {
  T _view;
  String _tag;
  LoggerManager _logger;

  BasePresenter(this._view, this._tag, this._logger);

  String get tag => _tag;

  T get view => _view;

  LoggerManager get logger => _logger;

  var industries, interests, skills;


  handleError(e) {
    switch (e.runtimeType) {
      case UnAuthenticatedException:
//        eventEmitter.publishUserLogout();
        return _view.onUnAuthenticated();

      case NotAuthorizedException:
        return _view.onNotAuthorized();

      case MissingTokenException:
      case TokenInvalidException:
        return _view.onAuthInvalid();

      case NetworkTimeoutException:
//        eventEmitter.publishUserLogout();
        return _view.onNetworkTimeout();

      default:
        if(_logger != null) {
          _logger.log("BasePresenter", e.toString());
        }
    }
  }

  /// Should call dispose when did pop a state
  void dispose(){

  }
}
