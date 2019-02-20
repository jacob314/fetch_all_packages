import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

const MethodChannel _channel = const MethodChannel('ssh');
const EventChannel _eventChannel = const EventChannel('shell_sftp');
Stream<dynamic> _onStateChanged;

Stream<dynamic> get onStateChanged {
  if (_onStateChanged == null) {
    _onStateChanged =
        _eventChannel.receiveBroadcastStream().map((dynamic event) => event);
  }
  return _onStateChanged;
}

typedef void Callback(dynamic result);

class SSHClient {
  String id;
  String host;
  int port;
  String username;
  dynamic passwordOrKey;
  StreamSubscription<dynamic> stateSubscription;
  Callback shellCallback;
  Callback uploadCallback;
  Callback downloadCallback;

  SSHClient({
    @required this.host,
    @required this.port,
    @required this.username,
    @required
        this.passwordOrKey, // password or {privateKey: value, [publicKey: value, passphrase: value]}
  }) {
    var uuid = new Uuid();
    id = uuid.v4();
    stateSubscription = onStateChanged.listen((dynamic result) {
      _parseOutput(result);
    });
  }

  _parseOutput(dynamic result) {
    switch (result["name"]) {
      case "Shell":
        if (shellCallback != null && result["key"] == id)
          shellCallback(result["value"]);
        break;
      case "DownloadProgress":
        if (downloadCallback != null && result["key"] == id)
          downloadCallback(result["value"]);
        break;
      case "UploadProgress":
        if (uploadCallback != null && result["key"] == id)
          uploadCallback(result["value"]);
        break;
    }
  }

  Future<String> connect() async {
    return await _channel.invokeMethod('connectToHost', {
      "id": id,
      "host": host,
      "port": port,
      "username": username,
      "passwordOrKey": passwordOrKey,
    });
  }

  Future<String> execute(String cmd) async {
    return await _channel.invokeMethod('execute', {
      "id": id,
      "cmd": cmd,
    });
  }

  Future<String> startShell({
    String ptyType = "vanilla", // vanilla, vt100, vt102, vt220, ansi, xterm
    Callback callback,
  }) async {
    shellCallback = callback;
    return await _channel.invokeMethod('startShell', {
      "id": id,
      "ptyType": ptyType,
    });
  }

  Future<String> writeToShell(String cmd) async {
    return await _channel.invokeMethod('writeToShell', {
      "id": id,
      "cmd": cmd,
    });
  }

  Future closeShell() async {
    shellCallback = null;
    return await _channel.invokeMethod('closeShell', {
      "id": id,
    });
  }

  Future<String> connectSFTP() async {
    return await _channel.invokeMethod('connectSFTP', {
      "id": id,
    });
  }

  Future<List> sftpLs([String path = '.']) async {
    return await _channel.invokeMethod('sftpLs', {
      "id": id,
      "path": path,
    });
  }

  Future<String> sftpRename({
    @required String oldPath,
    @required String newPath,
  }) async {
    return await _channel.invokeMethod('sftpRename', {
      "id": id,
      "oldPath": oldPath,
      "newPath": newPath,
    });
  }

  Future<String> sftpMkdir(String path) async {
    return await _channel.invokeMethod('sftpMkdir', {
      "id": id,
      "path": path,
    });
  }

  Future<String> sftpRm(String path) async {
    return await _channel.invokeMethod('sftpRm', {
      "id": id,
      "path": path,
    });
  }

  Future<String> sftpRmdir(String path) async {
    return await _channel.invokeMethod('sftpRmdir', {
      "id": id,
      "path": path,
    });
  }

  Future<String> sftpDownload({
    @required String path,
    @required String toPath,
    Callback callback,
  }) async {
    downloadCallback = callback;
    return await _channel.invokeMethod('sftpDownload', {
      "id": id,
      "path": path,
      "toPath": toPath,
    });
  }

  Future sftpCancelDownload() async {
    await _channel.invokeMethod('sftpCancelDownload', {
      "id": id,
    });
  }

  Future<String> sftpUpload({
    @required String path,
    @required String toPath,
    Callback callback,
  }) async {
    uploadCallback = callback;
    return await _channel.invokeMethod('sftpUpload', {
      "id": id,
      "path": path,
      "toPath": toPath,
    });
  }

  Future sftpCancelUpload() async {
    await _channel.invokeMethod('sftpCancelUpload', {
      "id": id,
    });
  }

  Future disconnectSFTP() async {
    uploadCallback = null;
    downloadCallback = null;
    await _channel.invokeMethod('disconnectSFTP', {
      "id": id,
    });
  }

  Future disconnect() async {
    shellCallback = null;
    uploadCallback = null;
    downloadCallback = null;
    stateSubscription.cancel();
    await _channel.invokeMethod('disconnect', {
      "id": id,
    });
  }
}
