
import 'package:quickclient/data/quotePacket.dart';
import 'package:quickclient/data/packet.dart';
class QuotePacket13 extends Packet {
  QuotePacket _quotePacket;
  QuotePacket13(QuotePacket quotePacket)
  {
    _quotePacket = quotePacket;
  }
  String getScripCode() {return _quotePacket.scripCode;}
  int getLastTradedPrice() { return _quotePacket.lastTradedPrice; }
  int getTotalTradedQty() { return _quotePacket.totalTradedQty; }
  int getHighPrice()  { return _quotePacket.highPrice; }
  int getLowPrice()  { return _quotePacket.lowPrice; }
  int getOpenPrice() { return _quotePacket.openPrice; }
  int getClosePrice()  { return _quotePacket.closePrice; }
  int getLastTradedQty()  { return _quotePacket.lastTradedQty; }
  int getWeightedAveragePrice()  { return _quotePacket.weightedAveragePrice; }
  int getTotalBuy() {  return _quotePacket.totalBuy; }
  int getTotalSell() {  return _quotePacket.totalSell; }
  int getLowerCircuit() {  return _quotePacket.lowerCircuit; }
  int getUpperCircuit() {  return _quotePacket.upperCircuit; }


  String toString() {
    return "ScripCode: " + getScripCode() + "\n" +
        "LastTrade Price: "+ getLastTradedPrice().toString() + "\n" +
        "Close Price: "+ getClosePrice().toString() + "\n" +
        "TotalTradedQty: "+ getTotalTradedQty().toString() + "\n" +
        "HighPrice: "+ getHighPrice().toString() + "\n" +
        "LowPrice: "+ getLowPrice().toString() + "\n" +
        "OpenPrice: "+ getOpenPrice().toString() + "\n" +
        "WeightedAveragePrice: "+ getWeightedAveragePrice().toString() + "\n" +
        "TotalBuy: " + getTotalBuy().toString() + "\n" +
        "TotalSell: " + getTotalSell().toString() + "\n" +
        "LowerCircuit: " + getLowerCircuit().toString() + "\n" +
        "UpperCircuit: " + getUpperCircuit().toString() + "\n" +
        "Timestamp: " + getTimestamp().toString() + "\n" +
        "Exchange: " + getExchange().toString();
  }
}