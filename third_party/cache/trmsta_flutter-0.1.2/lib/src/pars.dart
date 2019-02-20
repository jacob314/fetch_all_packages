library trmsta.pars;

import "regexes.dart";

class RowCount {
  final int dostrow;
  final int wolrow;
  RowCount(this.dostrow, this.wolrow);
  String toString() {
    return this.dostrow.toString()+"|"+this.wolrow.toString();
  }
}

class Location {
  final num lat;
  final num lon;
  Location(this.lat, this.lon);
  Location.fromTuple(List<num> tuple)
      : lat = tuple[0],
        lon = tuple[1];
  String toString() {
    return this.lat.toString()+","+this.lon.toString();
  }
}

final List<num> CONSTRFROMREGEX = [NRSTA, DOSTROW, WOLROW, LATIND, LONIND];

class LocRowSta {
  final int stanum;
  final RowCount row;
  final Location location;
  LocRowSta(this.stanum, this.row, this.location);
  LocRowSta.fromNums(this.stanum, int dostrow, int wolrow, num lat, num lon)
      : row = new RowCount(dostrow, wolrow),
        location = new Location(lat, lon);
  static LocRowSta fromStrList(List<String> strlist) {
    return new LocRowSta.fromNums(int.parse(strlist[0])-1, int.parse(strlist[1]),
        int.parse(strlist[2]), num.parse(strlist[3]), num.parse(strlist[4]));
  }
  String toString() {
    return "N"+this.stanum.toString()+" R"+this.row.toString()+" L"+this.location.toString();
  }
}

List<LocRowSta> pars(String skad) {
  Iterable<Match> matches = rall.allMatches(skad);
  Iterable<LocRowSta> listaiter = matches.map(
      (Match match) => LocRowSta.fromStrList(match.groups(CONSTRFROMREGEX)));
  List<LocRowSta> lista = new List<LocRowSta>.from(listaiter);
  return lista;
}
