import 'package:quickclient/data/quotePacket.dart';
import 'package:quickclient/data/packet.dart';

class QuotePacket27 extends Packet {
  QuotePacket _quotePacket;

  QuotePacket27(QuotePacket quotePacket) {
    _quotePacket = quotePacket;
  }

  String getScripCode() {return _quotePacket.scripCode;}
  int getLastTradedPrice() {return _quotePacket.lastTradedPrice;}
  int getClosePrice() {return _quotePacket.closePrice;}
  int getTotalTradedQty() {return _quotePacket.totalTradedQty;}
  int getHighPrice() {return _quotePacket.highPrice;}
  int getLowPrice() {return _quotePacket.lowPrice;}
  int getOpenPrice() {return _quotePacket.openPrice;}
  int weightedAveragePrice() {return _quotePacket.weightedAveragePrice;}
  int getTimestamp() {return _quotePacket.timestamp;}
  int getLastTradedQty() {return _quotePacket.lastTradedQty;}
  int getCurrentClosePrice() {return _quotePacket.currentClosePrice == null ? 0: _quotePacket.currentClosePrice;}

  String toString() {
    return "ScripCode: " + getScripCode() + "\n" +
        "LastTrade Price: "+ getLastTradedPrice().toString() + "\n" +
        "Close Price: "+ getClosePrice().toString() + "\n" +
        "TotalTradedQty: "+ getTotalTradedQty().toString() + "\n" +
        "HighPrice: "+ getHighPrice().toString() + "\n" +
        "LowPrice: "+ getLowPrice().toString() + "\n" +
        "OpenPrice: "+ getOpenPrice().toString() + "\n" +
        "WeightedAveragePrice: "+ weightedAveragePrice().toString() + "\n" +
        "Timestamp: " + getTimestamp().toString() + "\n" +
        "LastTradedQty: " + getLastTradedQty().toString() + "\n" +
        "CurrentClosePrice: " + getCurrentClosePrice().toString() + "\n" +
        "Exchange: " + getExchange().toString();
  }
}