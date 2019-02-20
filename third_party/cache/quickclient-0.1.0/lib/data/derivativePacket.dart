import 'package:quickclient/data/quotePacket.dart';

class DerivativePacket extends QuotePacket {
  String underlyingScripCode ;
  bool isIndex ;
  String indexName ;
  int isFuture ;
  String getScripCode() {return this.scripCode;}
  void setUnderlyingScripCode(String underlyingScripCode) { this.underlyingScripCode = underlyingScripCode; }
  String getUnderlyingScripCode(){return underlyingScripCode;}
  void setIndex(bool isIndex) { this.isIndex = isIndex; }
  bool getIndex() { return isIndex; }
  void setIsFuture(int isFuture) { this.isFuture = isFuture; }
  int getTimestamp() { return timestamp; }
  String toString() {
    return
      "ScripCode: "+ getScripCode() + "\n" +
      "UnderlyingScripCode: " + getUnderlyingScripCode() + "\n" +
      "Last Trade Price: "+ getLastTradedPrice().toString() + "\n" +
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
      "LowerCircuit: " + getLowerCircuit().toString() + "\n" +
      "UpperCircuit: " + getUpperCircuit().toString() + "\n" +
      "WeightedAveragePrice: "+ getWeightedAveragePrice().toString() + "\n" +
      "TotalBuy: "+ getTotalBuy().toString() + "\n" +
      "TotalSell: "+ getTotalSell().toString() + "\n" +
      "Timestamp: " + getTimestamp().toString() + "\n" +
      "Exchange: " + getExchange().toString() + "\n" +
      "IsIndex: " + getIndex().toString();
  }
}