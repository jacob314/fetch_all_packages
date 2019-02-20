import 'package:quickclient/data/quotePacket.dart';
import 'package:quickclient/data/packet.dart';

class QuotePacket41 extends Packet {
  QuotePacket _quotePacket;
  QuotePacket41(QuotePacket quotePacket)
  {
    _quotePacket = quotePacket;
  }
  String getScripCode() {return _quotePacket.scripCode;}
  int getTotalBuy() {return _quotePacket.totalBuy == null ? 0 : _quotePacket.totalBuy;}
  int getTotalSell() {return _quotePacket.totalSell == null ? 0 : _quotePacket.totalSell;}
  double getTotalBuyD() {return _quotePacket.totalBuyD == null ? 0.0 : _quotePacket.totalBuyD;}
  double getTotalSellD() {return _quotePacket.totalSellD == null ? 0.0 : _quotePacket.totalSellD;}

  String toString() {
    return
          "ScripCode: " + getScripCode() + "\n" +
          "TotalBuyD: "+ getTotalBuyD().toString() + "\n" +
          "TotalSellD: "+ getTotalSellD().toString() + "\n" +
          "TotalBuy: "+ getTotalBuy().toString() + "\n" +
          "TotalSell: " + getTotalSell().toString() + "\n" +
          "Exchange: " + getExchange().toString();
  }
}