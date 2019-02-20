
import 'package:quickclient/data/packet.dart';

class CommodityPacket extends Packet{
   int lastTradedPrice;
   int openInterest;
   int closePrice;
   int totalTradedQty;
   int highPrice;
   int lowPrice;
   int openPrice;
   int lastTradedQty;
   int weightedAveragePrice;
   int bestBuyPrice;
   int bestBuyQty;
   int bestSellPrice;
   int bestSellQty;
    int lifeHigh;
    int lifeLow ;
   double totalTradedValueD;
   double totalBuy;
   double totalSell;
   double totalBuyD;
   double totalSellD;

   int getOpenInterest() { return openInterest; }
   void setOpenInterest(int openInterest) { this.openInterest = openInterest; }
   double getTotalTradedValue() {return totalTradedValueD;}
   double getTotalBuy() {return totalBuyD;}
   double getTotalSell() {return totalSellD;}
   int getLastTradedPrice() {return this.lastTradedPrice;}
   int getClosePrice() {return this.closePrice;}

}

class CommodityPacket28 extends Packet {
 CommodityPacket _quotePacket;
 CommodityPacket28(CommodityPacket quotePacket)
{
_quotePacket = quotePacket;
}
 String getScripCode() {return _quotePacket.scripCode;}
 int getLastTradedPrice() {return _quotePacket.lastTradedPrice;}
 int getClosePrice() {return _quotePacket.closePrice;}
 int getTotalTradedQty() {return _quotePacket.totalTradedQty;}
 int getHighPrice() {return _quotePacket.highPrice;}
 int getLowPrice() {return _quotePacket.lowPrice;}
 int getOpenPrice(){return _quotePacket.openPrice;}
 int getWeightedAveragePrice() {return _quotePacket.weightedAveragePrice;}
 int getOpenInterest() {return _quotePacket.openInterest;}
 int getTimestamp() {return _quotePacket.timestamp;}

 String toString() {
   return
         "ScripCode: "+ getScripCode() + "\n" +
         "Last Trade Price: " +getLastTradedPrice().toString() +
         "\n" +
         "Close Price: " + getClosePrice().toString() + "\n" +
         "TotalTradedQty: " + getTotalTradedQty().toString() +
         "\n" +
         "HighPrice: " + getHighPrice().toString() + "\n" +
         "LowPrice: " + getLowPrice().toString() + "\n" +
         "OpenPrice: " + getOpenPrice().toString() + "\n" +
         "WeightedAveragePrice: " + getWeightedAveragePrice().toString() + "\n" +
         "OpenInterest: " + getOpenInterest().toString() + "\n" +
             "Exchange: " + getExchange().toString() + "\n" +
             "Timestamp: " +  getTimestamp().toString();
 }
}

class CommodityPacket29 extends Packet {
 CommodityPacket _quotePacket;
 CommodityPacket29(CommodityPacket quotePacket)
{
_quotePacket = quotePacket;
}
 String getScripCode() {return _quotePacket.scripCode;}
 int getBestBuyPrice() {return _quotePacket.bestBuyPrice;}
 int getBestBuyQty() {return _quotePacket.bestBuyQty;}
 int getBestSellPrice() {return _quotePacket.bestSellPrice;}
 int getBestSellQty() {return _quotePacket.bestSellQty;}
 double getTotalBuy(){return _quotePacket.totalBuy == null ? 0.0 : _quotePacket.totalBuy;}
 double getTotalSell() {return _quotePacket.totalSell == null ? 0.0 : _quotePacket.totalSell;}

 String toString() {
   return
         "ScripCode: "+ getScripCode() + "\n" +
         "BestBuyPrice: " + getBestBuyPrice().toString() + "\n" +
         "BestBuyQty: " + getBestBuyQty().toString() + "\n" +
         "BestSellPrice: " + getBestSellPrice().toString() + "\n" +
         "BestSellQty: " + getBestSellQty().toString() + "\n" +
         "TotalBuy: " + getTotalBuy().toString() + "\n" +
         "TotalSell: " + getTotalSell().toString() + "\n" +
         "Exchange: " + getExchange().toString() + "\n" +
         "Timestamp: " +  getTimestamp().toString();
 }
}