import 'package:quickclient/data/quotePacket.dart';
import 'package:quickclient/data/packet.dart';
class QuotePacket2 extends Packet {
  QuotePacket _quotePacket;
  QuotePacket2(QuotePacket quotePacket)
  {
    _quotePacket = quotePacket;
  }
  String getScripCode()  {return _quotePacket.scripCode;}
  int getLastTradedPrice() {return _quotePacket.lastTradedPrice;}
  int getHighPrice() {return _quotePacket.highPrice;}
  int getTotalBuy() {return _quotePacket.totalBuy;}
  int getLowPrice() {return _quotePacket.lowPrice;}
  int getTotalSell() {return _quotePacket.totalSell;}
  int getTotalTradedQty() {return _quotePacket.totalTradedQty;}

  String toString() {
    return "ScripCode: " + getScripCode() + "\n" +
        "LastTrade Price: "+ getLastTradedPrice().toString() + "\n" +
        "HighPrice: "+ getHighPrice().toString() + "\n" +
        "LowPrice: "+ getLowPrice().toString() + "\n" +
        "TotalSell: "+ getTotalSell().toString() + "\n" +
        "TotalBuy: +" + getTotalBuy().toString() + "\n" +
        "TotalTradedQty: " + getTotalTradedQty().toString() + "\n" +
        "Timestamp: " + getTimestamp().toString() + "\n" +
        "Exchange: " + getExchange().toString();
  }
}