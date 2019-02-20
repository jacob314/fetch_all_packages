
import 'package:quickclient/data/packet.dart';
import 'package:quickclient/data/quotePacket.dart';
class QuotePacket42 extends Packet {
  QuotePacket _quotePacket;
  QuotePacket42(QuotePacket quotePacket) {
    _quotePacket = quotePacket;
  }

  String getScripCode() {return _quotePacket.scripCode;}
  int getLowerCircuit() {return _quotePacket.lowerCircuit;}
  int getUpperCircuit() {return _quotePacket.upperCircuit;}
  int getWeekHigh52() {return _quotePacket.weekHigh52;}
  int getWeekLow52() {return _quotePacket.weekLow52;}

  String toString() {
    return
          "ScripCode: " + getScripCode() + "\n" +
          "LowerCircuit: "+ getLowerCircuit().toString() + "\n" +
          "UpperCircuit: "+ getUpperCircuit().toString() + "\n" +
          "WeekHigh52: "+ getWeekHigh52().toString() + "\n" +
          "WeekLow52: " + getWeekLow52().toString() + "\n" +
          "Exchange: " + getExchange().toString() + "\n" +
          "Timestamp: " + getTimestamp().toString();
  }

}