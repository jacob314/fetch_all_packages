
import 'package:quickclient/data/quotePacket.dart';
import 'package:quickclient/data/packet.dart';

class QuotePacket38 extends Packet {
  QuotePacket _quotePacket;

  QuotePacket38(QuotePacket quotePacket)
  {
    _quotePacket = quotePacket;
  }

  int lastTradedPrice;
  int closePrice;
  int totalTradedQty;
  int highPrice;
  int lowPrice;
  int openPrice;

  String getScripCode() {return _quotePacket.scripCode;}
  int getWeightedAveragePrice() {return _quotePacket.weightedAveragePrice;}
  int getBestBuyPrice() {return _quotePacket.bestBuyPrice;}
  int getBestBuyQty() {return _quotePacket.bestBuyQty;}
  int getBestSellPrice() {return _quotePacket.bestSellPrice;}
  int getBestSellQty() {return _quotePacket.bestSellQty;}
  int getTimestamp() {return _quotePacket.timestamp;}
  int getLastTradedQty()  { return _quotePacket.lastTradedQty; }
  int getCurrentClosePrice() {return _quotePacket.currentClosePrice == null ? 0: _quotePacket.currentClosePrice;}
  int getLastTradedPrice() { return _quotePacket.lastTradedPrice; }
  void setLastTradedPrice(int lastTradedPrice) { _quotePacket.lastTradedPrice = lastTradedPrice; }
  int getClosePrice() { return _quotePacket.closePrice; }
  void setClosePrice(int closePrice) { this.closePrice = closePrice; }
  int getTotalTradedQty(){return _quotePacket.totalTradedQty;}
  void setTotalTradedQty(int totalTradedQty){this.totalTradedQty =totalTradedQty;}
  int getHighPrice() { return _quotePacket.highPrice; }
  void setHighPrice(int highPrice) { this.highPrice = highPrice; }
  int getLowPrice() { return _quotePacket.lowPrice; }
  void setLowPrice(int lowPrice) { this.lowPrice = lowPrice; }
  int getOpenPrice() { return _quotePacket.openPrice; }
  void setOpenPrice(int openPrice) { this.openPrice = openPrice; }
 // int getExchange() { return _quotePacket_exchange; }
  String toString() {
        return
          "ScriptCode: "+ getScripCode() + "\n" +
          "LastTrade Price: "+ getLastTradedPrice().toString() + "\n" +
           "Close Price: "+ getClosePrice().toString() + "\n" +
           "TotalTradedQty: "+ getTotalTradedQty().toString() + "\n" +
           "HighPrice: "+ getHighPrice().toString() + "\n" +
           "LowPrice: "+ getLowPrice().toString() + "\n" +
           "OpenPrice: "+ getOpenPrice().toString() + "\n" +
           "WeightedAveragePrice: "+ getWeightedAveragePrice().toString() + "\n" +
           "BestBuyPrice: "+ getBestBuyPrice().toString() + "\n" +
           "BestBuyQty: "+ getBestBuyQty().toString() + "\n" +
           "BestSellPrice: "+ getBestSellPrice().toString() + "\n" +
           "BestSellQty: " + getBestSellQty().toString() + "\n" +
           "Timestamp: " + getTimestamp().toString() + "\n" +
           "LastTradedQty: "+ getLastTradedQty().toString() + "\n" +
           "CurrentClosePrice: "+ getCurrentClosePrice().toString() + "\n" +
           "Exchange: " + getExchange().toString();
  }
}