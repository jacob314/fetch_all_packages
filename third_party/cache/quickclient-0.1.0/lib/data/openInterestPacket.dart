import 'package:quickclient/data/packet.dart';

class OpenInterestPacket extends Packet {
  int openInterest ;
  int lastTradedPrice ;
  int totalTradedQty ;
  String getScripCode() {return this.scripCode;}
  int getOpenInterest() { return openInterest; }
  void setOpenInterest(int openInterest) { this.openInterest = openInterest; }
  int getLastTradedPrice() { return lastTradedPrice; }
  void setLastTradedPrice(int lastTradedPrice) { this.lastTradedPrice = lastTradedPrice; }
  int getTotalTradedQty() { return totalTradedQty; }
  void setTotalTradedQty(int totalTradedQty) { this.totalTradedQty = totalTradedQty; }

  String toString() {
    return  "ScripCode: "+ getScripCode() + "\n" +
            "OpenInterest: "+ getOpenInterest().toString() + "\n" +
            "Last Trade Price: "+ getLastTradedPrice().toString() + "\n" +
            "TotalTradedQty: "+ getTotalTradedQty().toString() + "\n" +
            "Exchange: " + getExchange().toString();
  }
}