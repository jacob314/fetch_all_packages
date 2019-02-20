package com.zqlite.android.lessql.db

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import org.json.JSONArray
import org.json.JSONObject

/**
 * Created by scott on 2017/9/29.
 */
class DBInfo {
    val dbName: String
    val dbVersion: Int
    val tables: MutableList<Table> = mutableListOf()

    constructor(dbInfo: String) {
        val jsonObject = JSONObject(dbInfo)
        this.dbName = jsonObject.optString(Contract.KEY_DB_NAME)
        this.dbVersion = jsonObject.optInt(Contract.KEY_DB_VERSION)

        val jTableArray: JSONArray = jsonObject.optJSONArray(Contract.KEY_TB_LIST);
        for (i in 0 until jTableArray.length()) {
            val jTable = jTableArray[i]
            tables.add(Table(jTable as JSONObject))
        }
    }

    fun getCreateTableSQL():List<String>{
        return tables.map { it.toSQL() }
    }
}

class Contract {
    companion object KEYS {
        val KEY_DB_NAME: String = "db_name"
        val KEY_DB_VERSION: String = "db_version"
        val KEY_TB_LIST: String = "tb_list"
        val KEY_TB_NAME: String = "tb_name"
        val KEY_TB_COL_NAMES: String = "col_names"
        val KEY_TB_COL_TYPES: String = "col_types"
        val KEY_TB_COL_PRIMARY_INDEX: String = "col_primarys"
        val KEY_TB_AUTO_INCREMENT_FIELD : String = "col_auto_increate"
        val KEY_VALUES :String = "values"

        val TYPE_NUMBER :String = "INTEGER"
        val TYPE_STRING :String = "TEXT"
    }
}

class Table {
    var name: String = ""
    val colNames: MutableList<String> = mutableListOf()
    val colTypes: MutableList<String> = mutableListOf()
    var colPrimary: Int = -1
    var autoIncrementField = ""
    constructor(json: JSONObject) {
        try {
            name = json.optString(Contract.KEY_TB_NAME)

            autoIncrementField = json.optString(Contract.KEY_TB_AUTO_INCREMENT_FIELD)

            val jNames = json.optJSONArray(Contract.KEY_TB_COL_NAMES)

            for (i in 0 until jNames.length()) {
                colNames.add(jNames.optString(i))
            }

            val jTypes = json.optJSONArray(Contract.KEY_TB_COL_TYPES)
            for (i in 0 until jTypes.length()) {
                colTypes.add(jTypes.optString(i))
            }

            colPrimary = json.optInt(Contract.KEY_TB_COL_PRIMARY_INDEX,-1)

        }catch (e:Exception){
            e.printStackTrace()
        }

    }

    fun toSQL():String{
        val sqlBuilder = StringBuilder()
        sqlBuilder.append("CREATE TABLE ").append(name).append(" (")
        if(autoIncrementField.trim().isNotEmpty()){
            sqlBuilder.append(autoIncrementField).append(" INTEGER PRIMARY KEY AUTOINCREMENT ,")
        }
        for(i in 0 until colNames.size){
            sqlBuilder.append(colNames[i]).append(" ").append(colTypes[i])
            if(colPrimary == i){
                sqlBuilder.append(" PRIMARY KEY").append(" ,")
            }else{
                sqlBuilder.append(",")
            }
        }
        sqlBuilder.deleteCharAt(sqlBuilder.length-1)
        sqlBuilder.append(");")
        return sqlBuilder.toString()
    }
}

class InsertHelper(json: JSONObject){
    val tableName:String
    val values:MutableList<String>
    init {
        tableName = json.optString(Contract.KEY_TB_NAME)
        val jValues = json.optJSONArray(Contract.KEY_VALUES)
        values = mutableListOf()
        for(i in 0 until jValues.length()){
            values.add(jValues.optString(i))
        }
    }

    fun insert(dbInfo: DBInfo,db: SQLiteDatabase):String{
        val table = dbInfo.tables.find { it.name == tableName }
        if(table != null){
            val colNames = table.colNames
            val colTypes = table.colTypes
            var contentValues = ContentValues()
            for(i in 0 until values.size){
                val type = colTypes[i]
                val name = colNames[i]
                when(type){
                    Contract.TYPE_NUMBER-> contentValues.put(name,values[i].toDouble())
                    Contract.TYPE_STRING-> contentValues.put(name,values[i])
                }
            }
            val id = db.insert(tableName,"",contentValues)
            db.close()
            return "insert into $tableName successful and the last id is $id"
        }
        return "insert nothing"
    }
}

class LesDBOpenHelper(context: Context?, name: String?, factory: SQLiteDatabase.CursorFactory?, version: Int,val dbInfo: DBInfo)
                                                                      : SQLiteOpenHelper(context, name, factory, version) {

    override fun onCreate(db: SQLiteDatabase?) {
        dbInfo.getCreateTableSQL().forEach {
            db!!.execSQL(it)
        }
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
    }

}