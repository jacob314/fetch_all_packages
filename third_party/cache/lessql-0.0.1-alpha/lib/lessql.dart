import 'dart:async';

import 'package:flutter/services.dart';
import 'package:lessql/db/db.dart';

export 'package:lessql/db/db.dart';


class MethodContract{
  static const String METHOD_INIT_DB = 'init_db';
  static const String METHOD_INSERT = "insert";

  static const String METHOD_SHOW_DB_IP = "db_ip";
}

class LesSQL {
  static const MethodChannel _channel =
      const MethodChannel('lessql');


  static Future<String> initLesDB(LesDB lesDB,List<LesTable> lesTables) async{
    String data = getInitDBData(lesDB, lesTables);
    return await _channel.invokeMethod(MethodContract.METHOD_INIT_DB,data);
  }

  static Future<String> insert(LesTable table,List values) async{
    String data = getInsertData(table, values);
    return await _channel.invokeMethod(MethodContract.METHOD_INSERT,data);
  }

  static initSelf(LesSQLCallback callback){
    _channel.setMethodCallHandler((MethodCall call){
      if(call.method == MethodContract.METHOD_SHOW_DB_IP){
        callback.initDBIP(call.arguments);
      }
    });
  }
}

abstract class LesSQLCallback{
  initDBIP(String ipAddress);
}
