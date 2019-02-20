

import 'package:quickclient/data/quotePacket.dart';
import 'package:quickclient/data/packet.dart';

class QuotePacket35 extends Packet  {
  QuotePacket _quotePacket;

  QuotePacket35(QuotePacket quotePacket)
  {
    _quotePacket = quotePacket;
  }

  String getScripCode() {return _quotePacket.scripCode;}
  int getWeightedAveragePrice() {return _quotePacket.getWeightedAveragePrice();}
  int getBestBuyPrice()  {return _quotePacket.bestBuyPrice;}
  int getBestBuyQty()  {return _quotePacket.bestBuyQty;}
  int getBestSellPrice()  {return _quotePacket.bestSellPrice;}
  int getBestSellQty()  {return _quotePacket.bestSellQty;}
  int getTotalBuy()  {return _quotePacket.totalBuy == null ? 0 : _quotePacket.totalBuy;}
  int getTotalSell() {return _quotePacket.totalSell ==null ? 0 : _quotePacket.totalSell;}
  double getTotalBuyD() {return _quotePacket.totalBuyD == null ? 0.0 : _quotePacket.totalBuyD;}
  double getTotalSellD() {return _quotePacket.totalSellD == null ? 0.0 : _quotePacket.totalSellD;}
  int getTimestamp()  {return _quotePacket.timestamp;}
  int getLastTradedQty()  { return _quotePacket.lastTradedQty; }
  int getCurrentClosePrice() {return _quotePacket.currentClosePrice ==null ? 0 :_quotePacket.currentClosePrice;}
  int getLowerCircuit() {return _quotePacket.lowerCircuit;}
  int getUpperCircuit() {return _quotePacket.upperCircuit;}

  String toString() {
    return
        "ScripCode: " + getScripCode() + "\n" +
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
        "TotalBuy: "+ getTotalBuy().toString() + "\n" +
        "TotalSell: "+ getTotalSell().toString() + "\n" +
        "TotalBuyD: "+ getTotalBuyD().toString() + "\n" +
        "TotalSellD: "+ getTotalSellD().toString() + "\n" +
        "LowerCircuit: " + getLowerCircuit().toString() + "\n" +
        "UpperCircuit: " + getUpperCircuit().toString() + "\n" +
        "Timestamp: " + getTimestamp().toString() + "\n" +
        "LastTradedQty: " + getLastTradedQty().toString() + "\n" +
        "CurrentClosePrice: " + getCurrentClosePrice().toString() + "\n" +
        "Exchange: " + getExchange().toString();
  }
}