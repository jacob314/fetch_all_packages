
import 'package:quickclient/data/packet.dart';
import 'package:quickclient/data/records.dart';

class ReportsPacket extends Packet{

   int ReportType;
   String GroupCode ;
   List Records;
   String getScripCode() {return scripCode;}
   String getGroupCode() {return GroupCode;}
   List getRecords(){return Records;}

   String toString() {
      return "ScripCode: " + getScripCode() + "\n" +
          "GroupCode: "+ getGroupCode().toString() + "\n" +
          "Records: "+ getRecords().toString() + "\n" +
          "Exchange: " + getExchange().toString();
   }

}