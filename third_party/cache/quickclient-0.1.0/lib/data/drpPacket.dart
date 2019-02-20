import 'package:quickclient/data/packet.dart';

class DPRPacket extends Packet {
  int lowerCircuit ;
  int upperCircuit ;
  String getScripCode() {return this.scripCode;}
  int getLowerCircuit(){ return lowerCircuit;}
  int getUpperCircuit(){ return upperCircuit;}
  void setLowerCircuit(int lowerCircuit) { this.lowerCircuit = lowerCircuit; }
  void setUpperCircuit(int upperCircuit) { this.upperCircuit = upperCircuit; }

  String toString() {
    return
          "ScripCode: "+ getScripCode() +"\n" +
          "LowerCircuit: "+ getLowerCircuit().toString() + "\n" +
          "UpperCircuit: "+ getUpperCircuit().toString() + "\n" +
          "Exchange: " + getExchange().toString() + "\n" +
          "Timestamp: " +  getTimestamp().toString();
  }
}