
import 'package:quickclient/data/quotePacket.dart';
import 'package:quickclient/data/packet.dart';

class QuotePacket39 extends Packet {
  QuotePacket _quotePacket;
  QuotePacket39(QuotePacket quotePacket)
  {
    _quotePacket = quotePacket;
  }
  String getScripCode() {return _quotePacket.scripCode;}
  int getLastTradedPrice() {return _quotePacket.lastTradedPrice;}
  int getClosePrice() {return _quotePacket.closePrice;}
  int getTotalTradedQty() {return _quotePacket.totalTradedQty;}
  int getHighPrice() {return _quotePacket.highPrice;}
  int getLowPrice() {return _quotePacket.lowPrice;}
  int getOpenPrice() {return _quotePacket.openPrice;}
  int getWeightedAveragePrice() {return _quotePacket.getWeightedAveragePrice();}
  int getBestBuyPrice()  {return _quotePacket.bestBuyPrice;}
  int getBestBuyQty()  {return _quotePacket.bestBuyQty;}
  int getBestSellPrice()  {return _quotePacket.bestSellPrice;}
  int getBestSellQty()  {return _quotePacket.bestSellQty;}
  int getTotalBuy()  {return _quotePacket.totalBuy == null ? 0 : _quotePacket.totalBuy;}
  int getTotalSell() {return _quotePacket.totalSell == null ? 0 : _quotePacket.totalSell;}
  double getTotalBuyD() {return _quotePacket.totalBuyD == null ? 0.0 : _quotePacket.totalBuyD;}
  double getTotalSellD() {return _quotePacket.totalSellD == null ? 0.0 : _quotePacket.totalSellD;}
  int getTimestamp()  {return _quotePacket.timestamp;}
  int getLastTradedQty()  { return _quotePacket.lastTradedQty; }
  int getCurrentClosePrice() {return _quotePacket.currentClosePrice == null ? 0 : _quotePacket.currentClosePrice;}

  String toString() {
    return
        "ScripCode: " + getScripCode() + "\n" +
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
        "TotalBuy: "+ getTotalBuy().toString() + "\n" +
        "TotalSell: "+ getTotalSell().toString() + "\n" +
        "TotalBuyD: "+ getTotalBuyD().toString() + "\n" +
        "TotalSellD: "+ getTotalSellD().toString() + "\n" +
        "Timestamp: " + getTimestamp().toString() + "\n" +
        "LastTradedQty: " + getLastTradedQty().toString() + "\n" +
        "CurrentClosePrice: " + getCurrentClosePrice().toString() + "\n" +
        "Exchange: " + getExchange().toString();
  }
}