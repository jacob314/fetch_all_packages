
import 'package:quickclient/data/packet.dart';

class QuotePacket extends Packet {
  int lastTradedPrice ;
  int closePrice ;
  int bestBuyPrice ;
  int bestBuyQty ;
  int bestSellPrice ;
  int bestSellQty ;
  int highPrice ;
  int lowPrice ;
  int openPrice ;
  int lastTradedQty ;
  int totalTradedQty ;
  int weightedAveragePrice ;
  int totalBuy ;
  int totalSell ;
  int totalTradedValue ;
  int lowerCircuit ;
  int upperCircuit ;
  double totalBuyD;
  double totalSellD ;
  int currentClosePrice ;
  int weekHigh52;
  int weekLow52;

  String getScripCode() {return this.scripCode;}
  int getLastTradedPrice() { return lastTradedPrice; }
  void setLastTradedPrice(int lastTradedPrice) { this.lastTradedPrice = lastTradedPrice; }
  int getClosePrice() { return closePrice; }
  void setClosePrice(int closePrice) { this.closePrice = closePrice; }
  int getBestBuyPrice() { return bestBuyPrice; }
  void setBestBuyPrice(int bestBuyPrice) { this.bestBuyPrice = bestBuyPrice; }
  int getBestBuyQty() { return bestBuyQty; }
  void setBestBuyQty(int bestBuyQty) { this.bestBuyQty = bestBuyQty; }
  int getBestSellPrice() { return bestSellPrice; }
  void setBestSellPrice(int bestSellPrice) { this.bestSellPrice = bestSellPrice; }
  int getBestSellQty() { return bestSellQty; }
  void setBestSellQty(int bestSellQty) { this.bestSellQty = bestSellQty; }
  int getHighPrice() { return highPrice; }
  void setHighPrice(int highPrice) { this.highPrice = highPrice; }
  int getLowPrice() { return lowPrice;}
  void setLowPrice(int lowPrice) { this.lowPrice = lowPrice; }
  int getOpenPrice() { return openPrice; }
  void setOpenPrice(int openPrice) { this.openPrice = openPrice; }
  int getLastTradedQty() { return lastTradedQty; }
  void setLastTradedQty(int lastTradedQty) { this.lastTradedQty = lastTradedQty;}
  int getTotalTradedQty() {return totalTradedQty; }
  void setTotalTradedQty(int totalTradedQty) { this.totalTradedQty = totalTradedQty;}
  int getWeightedAveragePrice() { return weightedAveragePrice; }
  void setWeightedAveragePrice(int weightedAveragePrice) { this.weightedAveragePrice = weightedAveragePrice; }
  int getTotalBuy() { return totalBuy; }
  void setTotalBuy(int totalBuy) { this.totalBuy = totalBuy; }
  int getTotalSell() { return totalSell; }
  void setTotalSell(int totalSell) { this.totalSell = totalSell; }
  int getTotalTradedValue() { return totalTradedValue; }
  void setTotalTradedValue(int totalTradedValue) { this.totalTradedValue = totalTradedValue; }
  int getLowerCircuit() { return lowerCircuit; }
  void setLowerCircuit(int lowerCircuit) { this.lowerCircuit = lowerCircuit; }
  int getUpperCircuit() { return upperCircuit; }
  void setUpperCircuit(int upperCircuit) { this.upperCircuit = upperCircuit; }

  String toString() {
    return
         "ScripCode: "+ getScripCode() + "\n" +
         "LastTrade Price: "+ getLastTradedPrice().toString() + "\n" +
        "Close Price: "+ getClosePrice().toString() + "\n" +
        "BestBuyPrice: "+ getBestBuyPrice().toString() + "\n" +
        "BestBuyQty: "+ getBestBuyQty().toString() + "\n" +
        "BestSellPrice: "+ getBestSellPrice().toString() + "\n" +
        "BestSellQty: "+ getBestSellQty().toString() + "\n" +
        "TotalTradedQty: "+ getTotalTradedQty().toString() + "\n" +
        "HighPrice: "+ getHighPrice().toString() + "\n" +
        "LowPrice: "+ getLowPrice().toString() + "\n" +
        "OpenPrice: "+ getOpenPrice().toString() + "\n" +
        "LastTradedQty: " + getLastTradedQty().toString() + "\n" +
        "WeightedAveragePrice: "+ getWeightedAveragePrice().toString() + "\n" +
        "TotalBuy: "+ getTotalBuy().toString() + "\n" +
        "TotalSell: "+ getTotalSell().toString() + "\n" +
        "LowerCircuit: " + getLowerCircuit().toString() + "\n" +
        "UpperCircuit: " + getUpperCircuit().toString() + "\n" +
        "Timestamp: " + getTimestamp().toString() + "\n" +
        "Exchange: " + getExchange().toString();
  }
}