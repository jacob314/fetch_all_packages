
import 'package:quickclient/data/quotePacket.dart';
import 'package:quickclient/data/packet.dart';
class QuotePacket23 extends Packet {
  QuotePacket _quotePacket;
  QuotePacket23(QuotePacket quotePacket)
  {
    _quotePacket = quotePacket;
  }
  String getScripCode() {return _quotePacket.scripCode;}
  int getLastTradedPrice()  { return _quotePacket.lastTradedPrice; }
  int getClosePrice() {  return _quotePacket.closePrice; }
  int getTotalTradedQty()  { return _quotePacket.totalTradedQty; }
  int getHighPrice()  { return _quotePacket.highPrice; }
  int getLowPrice()  { return _quotePacket.lowPrice; }
  int getOpenPrice() { return _quotePacket.openPrice; }
  int getWeightedAveragePrice()  { return _quotePacket.weightedAveragePrice; }
  int getLowerCircuit()  { return _quotePacket.lowerCircuit; }
  int getUpperCircuit()  { return _quotePacket.upperCircuit; }
  int getTimestamp() {return _quotePacket.timestamp;}
  int getLastTradedQty()  { return _quotePacket.lastTradedQty; }
  int getCurrentClosePrice()  { return _quotePacket.currentClosePrice ==null ? 0 : _quotePacket.currentClosePrice; }

  String toString() {
    return "ScripCode: " + getScripCode() + "\n" +
        "LastTrade Price: "+ getLastTradedPrice().toString() + "\n" +
        "Close Price: "+ getClosePrice().toString() + "\n" +
        "TotalTradedQty: "+ getTotalTradedQty().toString() + "\n" +
        "HighPrice: "+ getHighPrice().toString() + "\n" +
        "LowPrice: "+ getLowPrice().toString() + "\n" +
        "OpenPrice: "+ getOpenPrice().toString() + "\n" +
        "WeightedAveragePrice: "+ getWeightedAveragePrice().toString() + "\n" +
        "LowerCircuit: " + getLowerCircuit().toString() + "\n" +
        "UpperCircuit: " + getUpperCircuit().toString() + "\n" +
        "Timestamp: " + getTimestamp().toString() + "\n" +
        "LastTradedQty: " + getLastTradedQty().toString() + "\n" +
        "CurrentClosePrice: " + getCurrentClosePrice().toString() + "\n" +
        "Exchange: " + getExchange().toString();
  }
}