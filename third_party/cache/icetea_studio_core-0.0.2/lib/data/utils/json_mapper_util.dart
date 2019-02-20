//List listToJson (List list) => list.map((it) => (it as BaseMapper).toJson()).toList();
//
//dynamic entityToJson<T extends BaseMapper> (entity) => entity.toJson();
//
//dynamic entityToJsonId<T extends BaseMapper> (entity) => {"id": entity.id};
//

Map<String, dynamic> normalizeIdObject(Map<String, dynamic> map, String objField, String idField) {
  if (map[objField] != null && map[objField] is String) {
    map[objField] = { idField : map[objField] };
  }
  return map;
}

/// Converter to convert a DateTime to UTC string
String dateToUTCString(DateTime date) => date != null ? date.toUtc().toIso8601String() : '';

/// Converter to join the list values
String listToString(List<String> l) => l == null ? "" : l.join(",");

/// Converter to convert a number or String number to double
double numberStringToDbl(dynamic value) {
  if (value is String){
    return double.parse(value);
  }
  return value as double;
}

/// Converter to convert a number or String number to int
int numberStringToInt(dynamic value) {
  if (value is String){
    return int.parse(value);
  }
  return value as int;
}