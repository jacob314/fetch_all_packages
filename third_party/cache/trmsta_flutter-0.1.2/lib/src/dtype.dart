library trmsta.dtype;

import "pars.dart";
import "datapars.dart";

class AllSta {
  final LocRowSta locrow;
  final StaData data;
  AllSta(this.locrow, this.data);
  String toString() {
    return locrow.toString()+"&"+data.toString();
  }
}

List<AllSta> Zip(List<LocRowSta> lr, List<StaData> sd) {
  assert(lr.length==sd.length);
  List<AllSta> lista = new List(lr.length);
  lr.sort((LocRowSta a, LocRowSta b) => a.stanum - b.stanum);
  sd.sort((StaData a, StaData b) => a.stanum - b.stanum);
  for(int i =0 ; i<lr.length ; i++) {
    assert(lr[i].stanum==i);
    assert(sd[i].stanum==i);
    lista[i]=new AllSta(lr[i], sd[i]);
  }
  return lista;
}

class Downloaded {
  final String content;
  final DateTime time;
  Downloaded(this.content, this.time);
  List<LocRowSta> ParseSta() {
    return pars(this.content);
  }

  List<StaData> ParseData() {
    return parseData(this.content);
  }

  List<AllSta> ParseAll() {
    return Zip(this.ParseSta(), this.ParseData());
  }
}
