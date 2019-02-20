import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:progress_hud/progress_hud.dart';

import 'api/api_client.dart';
import 'auth/auth.dart';
import 'config/magic_config.dart';
import 'contracts/auth/guard.dart';
import 'data/base_data_receiver.dart';
import 'foundation/magic.dart';
import 'lang/lang.dart';
import 'validators/base_validator.dart';

typedef dynamic FetchModelMapCallback(dynamic data);

/// The cache keys.
final authUserCacheKey = 'auth.user';
final authBearerTokenCacheKey = 'auth.token';

/// The loader is showing?
bool _loaderShowing = false;

/// Resolve the given type from the magic.
T make<T>() {
  return Magic.getInstance().make<T>();
}

/// Get the specified configuration value.
dynamic config(String key) {
  return make<MagicConfig>().get(key);
}

/// Get the active auth guard.
Guard guard() {
  return make<Auth>().guard;
}

/// Get the active auth instance.
Auth auth() {
  return make<Auth>();
}

/// Get the base data receiver instance.
BaseDataReceiver dataReceiver() {
  return make<BaseDataReceiver>();
}

/// Get the current api client instance.
ApiClient apiClient() {
  return make<ApiClient>();
}

/// Fetch the models by the given queries.
Future<List<T>> fetchModels<T>(FetchModelMapCallback mapCallback, {Map<String, dynamic> queries}) async {
  final List<T> models = new List<T>();

  (await fetchItems(mapCallback(null).resourceKey(), queries: queries)).forEach((dynamic data) {
    models.add(
      mapCallback(data)
    );
  });

  return models;
}

/// Fetch the data from the given resource key.
Future<List<dynamic>> fetchItems(String resourceKey, {Map<String, dynamic> queries}) async {
  return await dataReceiver().index(resourceKey, queries: queries);
}

/// Translate the given key from the localization
String trans(BuildContext context, String key, {Map<String, String> replaces}) {
  return Lang.of(context).trans(key, replaces: replaces);
}

/// Let's validate!
String validates(BuildContext context, Object value, String attribute, List<BaseValidator> validators) {
  String result;

  validators.takeWhile((BaseValidator validator) {
    return result == null;
  }).forEach((BaseValidator validator) {
    result = validator.validate(context, value, attribute);
  });

  return result;
}

/// Get instance of the secure storage.
FlutterSecureStorage secureStorage() {
  return make<FlutterSecureStorage>();
}


/// Get instance of the router.
Router router() {
  return make<Router>();
}

/// Get cache variable.
Future<String> cache(String key) {
  return secureStorage().read(key: key);
}

/// Set cache variable.
Future<void> cacheSet(String key, String value) {
  return secureStorage().write(key: key, value: value);
}

/// Delete cache variable.
Future<void> cacheDelete(String key) {
  return secureStorage().delete(key: key);
}

/// Let's start to show the loader
void showLoader(BuildContext context) {
  _loaderShowing = true;

  showDialog(context: context, builder: (BuildContext context) => new ProgressHUD(
    color: Colors.white,
    containerColor: Theme.of(context).primaryColor,
  ));
}

/// Hide the loader.
void hideLoader(BuildContext context) {
  if (_loaderShowing) {
    _loaderShowing = false;

    Navigator.pop(context);
  }
}

// Show snackBar
void showSnackBar(BuildContext context, Widget title, {Widget content, List<Widget> actions}) {
  showDialog(context: context, builder: (BuildContext context) => new AlertDialog(
    title: title,
    content: content,
    actions: actions,
  ));
}

/// Show error
void showError(BuildContext context, String error) {
  hideLoader(context);

  showSnackBar(
    context,
    new Text(
      Lang.of(context).trans('error'),
      style: new TextStyle(color: Theme.of(context).errorColor),
    ),
    content: new SingleChildScrollView(
      child: new Text(error)
    ),
    actions: <Widget>[
      new FlatButton(
        child: new Text(
          Lang.of(context).trans('ok'),
          style: new TextStyle(
            color: Colors.white
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        color: Theme.of(context).errorColor,
      ),
    ]
  );
}

/// Pop all routes and replace
void replaceTo(BuildContext context, String routeName) {
  while (Navigator.of(context).canPop()) {
    Navigator.pop(context);
  }

  Navigator.of(context).pushReplacementNamed(routeName);
}

/// Redirect to current page
void redirectTo(BuildContext context, String routeName) {
  Navigator.of(context).pushNamed(routeName);
}