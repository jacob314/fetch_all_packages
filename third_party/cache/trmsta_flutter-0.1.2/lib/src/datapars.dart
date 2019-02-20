library trmsta.datapars;

import "regexes.dart";

final List<num> DCONSTRFROMREGEX = [GMARKERS, STACNUMBER, ADDRIND];

class StaData {
  final int stanum;
  final String addr;
  StaData(this.stanum, this.addr);
  static StaData fromTwoIntAndStr(int firstnum, int secondnum, String addr) {
    if (firstnum != secondnum) {
      throw new ArgumentError([firstnum, secondnum, addr]);
    }
    return new StaData(firstnum, addr);
  }

  static StaData fromThreeStrList(List<String> strlist) {
    return StaData.fromTwoIntAndStr(
        int.parse(strlist[0]), int.parse(strlist[1]) - 1, strlist[2]);
  }

  String toString() {
    return this.stanum.toString()+':"'+this.addr+'"';
  }
}

List<StaData> parseData(String skad) {
  Iterable<Match> matches = rdall.allMatches(skad);
  Iterable<StaData> listaiter = matches.map((Match match) =>
      StaData.fromThreeStrList(match.groups(DCONSTRFROMREGEX)));
  List<StaData> lista = new List<StaData>.from(listaiter);
  return lista;
}

List<String> addrListFromStaData(List<StaData> par) {
  List<String> lista;
  //List<bool> czy;
  par.forEach((StaData sd) {
    lista[sd.stanum] = sd.addr;
    //czy[sd.stanum] = true;
  });
  return lista;
}
