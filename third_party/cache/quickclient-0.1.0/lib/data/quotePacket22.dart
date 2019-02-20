
import 'package:quickclient/data/quotePacket.dart';
import 'package:quickclient/data/packet.dart';
class QuotePacket22 extends Packet {
  QuotePacket _quotePacket;
  QuotePacket22(QuotePacket quotePacket)
  {
    _quotePacket = quotePacket;
  }
  String getScripCode(){return _quotePacket.scripCode;}
  int getBestBuyPrice() {return _quotePacket.bestBuyPrice;}
  int getBestBuyQty() {return _quotePacket.bestBuyQty;}
  int getBestSellPrice(){return _quotePacket.bestSellPrice;}
  int getBestSellQty() {return _quotePacket.bestSellQty;}
  int getTotalBuy() {return _quotePacket.totalBuy == null ? 0 : _quotePacket.totalBuy;}
  int getTotalSell() {return _quotePacket.totalSell == null ? 0 : _quotePacket.totalSell;}
  double getTotalBuyD() {return _quotePacket.totalBuyD == null ? 0.0 : _quotePacket.totalBuyD;}
  double getTotalSellD() {return _quotePacket.totalSellD == null ? 0.0 : _quotePacket.totalSellD;}

  String toString() {
    return "ScripCode: " + getScripCode() + "\n" +
        "BestBuyPrice: "+ getBestBuyPrice().toString() + "\n" +
        "BestBuyQty: "+ getBestBuyQty().toString() + "\n" +
        "BestSellPrice: "+ getBestSellPrice().toString() + "\n" +
        "BestSellQty: "+ getBestSellQty().toString() + "\n" +
        "TotalBuy: "+ getTotalBuy().toString() + "\n" +
        "TotalSell: "+ getTotalSell().toString() + "\n" +
        "totalBuyD: "+ getTotalBuyD().toString() + "\n" +
        "totalSellD: " + getTotalSellD().toString() + "\n" +
        "Exchange: " + getExchange().toString() + "\n" +
        "Timestamp: " + getTimestamp().toString();
  }
}