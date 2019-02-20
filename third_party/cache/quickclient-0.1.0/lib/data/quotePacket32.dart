
import 'package:quickclient/data/quotePacket.dart';
import 'package:quickclient/data/packet.dart';
class QuotePacket32 extends Packet {
  QuotePacket _quotePacket;
  QuotePacket32(QuotePacket quotePacket)
  {
    _quotePacket = quotePacket;
  }
  String getScripCode() {return _quotePacket.scripCode;}
  int getBestBuyPrice() {return _quotePacket.bestBuyPrice;}
  int getBestBuyQty() {return _quotePacket.bestBuyQty;}

  int getBestSellPrice() {return _quotePacket.bestSellPrice;}
  int getBestSellQty() {return _quotePacket.bestSellQty;}

  String toString() {
    return
        "ScriptCode: "+ getScripCode() + "\n" +
        "BestBuyPrice: "+ getBestBuyPrice().toString() + "\n" +
        "BestBuyQty: "+ getBestBuyQty().toString() + "\n" +
        "BestSellPrice: "+ getBestSellPrice().toString() + "\n" +
        "BestSellQty: " + getBestSellQty().toString() + "\n" +
        "Exchange: " + getExchange().toString();
  }
}