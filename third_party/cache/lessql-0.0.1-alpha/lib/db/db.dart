import 'dart:convert';

class Contract{
  static const String KEY_DB_NAME = "db_name";
  static const String KEY_DB_VERSION = "db_version";
  static const String KEY_TB_LIST = "tb_list";
  static const String KEY_TB_NAME = "tb_name";
  static const String KEY_TB_COL_NAMES = "col_names";
  static const String KEY_TB_COL_TYPES = "col_types";
  static const String KEY_TB_COL_PRIMARY_INDEX = "col_primary";
  static const String KEY_TB_AUTO_INCREMENT_FIELD = "col_auto_increate";

  static const String KEY_VALUES = "values";
  static const String TYPE_NUMBER = "INTEGER";
  static const String TYPE_STRING = "TEXT";
}

abstract class LesDB{
  String getName();

  int getVersion();
}

abstract class LesTable{
  String getTableName();

  List<String> getColumnNames();

  List<String> getColumnTypes();

  int getPrimaryColumnIndex();

  String getAutoIncrementID();
}

abstract class LesEntity{
  List getValues();
}

String getInitDBData(LesDB lesDB,List<LesTable> lesTables){

  Map data = {};

  assert(lesDB != null);

  data[Contract.KEY_DB_NAME] = lesDB.getName();
  data[Contract.KEY_DB_VERSION] = lesDB.getVersion().toString();

  List<Map> tableList = [];

  assert(lesTables != null && lesTables.length>0);

  for(var table in lesTables){
    Map tableMap = {};
    tableMap[Contract.KEY_TB_NAME] = table.getTableName();
    tableMap[Contract.KEY_TB_COL_NAMES] = table.getColumnNames();
    tableMap[Contract.KEY_TB_COL_TYPES] = table.getColumnTypes();
    tableMap[Contract.KEY_TB_COL_PRIMARY_INDEX] = table.getPrimaryColumnIndex();
    tableMap[Contract.KEY_TB_AUTO_INCREMENT_FIELD] = table.getAutoIncrementID()??'';
    tableList.add(tableMap);
  }

  data[Contract.KEY_TB_LIST] = tableList;

  return JSON.encode(data);

}

String getInsertData(LesTable table,List values){
  Map data = {};
  data[Contract.KEY_TB_NAME] = table.getTableName();
  data[Contract.KEY_VALUES] = values;
  return JSON.encode(data);
}
