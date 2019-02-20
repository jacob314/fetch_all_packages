
import 'package:quickclient/data/packet.dart';
class SpreadPacket extends Packet{

   String token1;
   String token2;
   int totalBuy;
   int totalSell;
   int tradedVolume;
   double totalTradedValue;
   double totalBuyVolume;
   double totalSellVolume;
   int openPriceDifference;
   int highPriceDifference;
   int lowPriceDifference;
   int lastTradedPriceDifference;
   int bestBuyPrice;
   int bestBuyQty;
   int bestSellPrice;
   int bestSellQty;
   int bestBuyOrders;
   int bestSellOrders;
   String getScripCode() {return this.scripCode;}
   String getToken1() { return this.token1; }
   String getToken2() { return this.token2; }
   int getTotalBuy() { return this.totalBuy; }
   int getTotalSell() { return this.totalSell; }
   int getTradedVolume() { return this.tradedVolume; }
   String getTotalTradedValue() { return this.totalTradedValue.toString(); }
   String getTotalBuyVolume() { return this.totalBuyVolume.toString(); }
   String getTotalSellVolume() { return this.totalSellVolume.toString(); }
   int getOpenPriceDifference() { return this.openPriceDifference; }
   int getHighPriceDifference() { return this.highPriceDifference; }
   int getLowPriceDifference() { return this.lowPriceDifference; }
   int getLastTradedPriceDifference() { return this.lastTradedPriceDifference; }
   int getBestBuyPrice() { return this.bestBuyPrice; }
   int getBestBuyQty() { return this.bestBuyQty; }
   int getBestSellPrice() { return this.bestSellPrice; }
   int getBestSellQty() { return this.bestSellQty; }
   int getBestBuyOrders() { return this.bestSellPrice; }
   int getBestSellOrders() { return this.bestSellOrders; }
  // int getTimestamp() {return timestamp;}

   String toString() {
      return     "ScripCode: "+ getScripCode() + "\n" +
                 "Token1: "+ getToken1() + "\n" +
                 "Token2: "+ getToken2() + "\n" +
                 "TotalBuy: "+ getTotalBuy().toString() + "\n" +
                 "TotalSell: " + getTotalSell().toString() + "\n" +
                 "TradedVolume: "+ getTradedVolume().toString() + "\n" +
                 "TradedValue: "+ getTotalTradedValue() + "\n" +
                 "TotalBuyVolume: "+ getTotalBuyVolume() + "\n" +
                 "TotalSellVolume: "+ getTotalSellVolume().toString() + "\n" +
                 "OpenPriceDifference: "+ getOpenPriceDifference().toString() + "\n" +
                 "HighPriceDifference: "+ getHighPriceDifference().toString() + "\n" +
                 "LowPriceDifference: "+ getLowPriceDifference().toString() + "\n" +
                 "LastTradedPriceDifference: "+ getLastTradedPriceDifference().toString() + "\n" +
                 "BestBuyPrice: "+ getBestBuyPrice().toString() + "\n" +
                 "BestBuyQty: "+ getBestBuyQty().toString() + "\n" +
                 "BestSellPrice: "+ getBestSellPrice().toString() + "\n" +
                 "BestSellQty: "+ getBestSellQty().toString() + "\n" +
                 "BestBuyOrders: "+ getBestBuyOrders().toString() + "\n" +
                 "BestSellOrders: "+ getBestSellOrders().toString() + "\n" +
                 "Timestamp: "+ getTimestamp().toString() + "\n" +
                 "Exchange: " + getExchange().toString();
   }
}
