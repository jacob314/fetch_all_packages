
import 'package:quickclient/data/quotePacket.dart';
import 'package:quickclient/data/packet.dart';
class QuotePacket34 extends Packet {//QuotePacket38
  QuotePacket _quotePacket;
  QuotePacket34(QuotePacket quotePacket) //: base(quotePacket)
  {_quotePacket = quotePacket;}

  String getScripCode() {return _quotePacket.scripCode;}
  int getWeightedAveragePrice() {return _quotePacket.weightedAveragePrice;}
  int getBestBuyPrice() {return _quotePacket.bestBuyPrice;}
  int getBestBuyQty() {return _quotePacket.bestBuyQty;}
  int getBestSellPrice() {return _quotePacket.bestSellPrice;}
  int getBestSellQty() {return _quotePacket.bestSellQty;}
  int getTimestamp() {return _quotePacket.timestamp;}
  int getLastTradedQty()  { return _quotePacket.lastTradedQty; }
  int getCurrentClosePrice() {return _quotePacket.currentClosePrice == null ? 0 : _quotePacket.currentClosePrice;}
  int getLowerCircuit() {return _quotePacket.lowerCircuit;}
  int getUpperCircuit() {return _quotePacket.upperCircuit;}

  String toString() {
    return
        "ScriptCode: "+ getScripCode() + "\n" +
        "LastTrade Price: "+ _quotePacket.getLastTradedPrice().toString() + "\n" +
        "Close Price: "+ _quotePacket.getClosePrice().toString() + "\n" +
        "TotalTradedQty: "+ _quotePacket.getTotalTradedQty().toString() + "\n" +
        "HighPrice: "+ _quotePacket.getHighPrice().toString() + "\n" +
        "LowPrice: "+ _quotePacket.getLowPrice().toString() + "\n" +
        "OpenPrice: "+ _quotePacket.getOpenPrice().toString() + "\n" +
        "WeightedAveragePrice: "+ getWeightedAveragePrice().toString() + "\n" +
        "BestBuyPrice: "+ getBestBuyPrice().toString() + "\n" +
        "BestBuyQty: "+ getBestBuyQty().toString() + "\n" +
        "BestSellPrice: "+ getBestSellPrice().toString() + "\n" +
        "BestSellQty: " + getBestSellQty().toString() + "\n" +
        "LowerCircuit: "+ getLowerCircuit().toString() + "\n" +
        "UpperCircuit: "+ getUpperCircuit().toString() + "\n" +
        "Timestamp: " + getTimestamp().toString() + "\n" +
        "LastTradedQty: "+ getLastTradedQty().toString() + "\n" +
        "CurrentClosePrice: "+ getCurrentClosePrice().toString()+ "\n" +
        "Exchange: " + getExchange().toString();
  }
}