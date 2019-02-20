import 'package:quickclient/data/packet.dart';

class IndexPacket extends Packet {
  int lastTradedPrice ;
  int closePrice ;
  int highPrice ;
  int lowPrice ;
  int openPrice ;
  String formattedTime ;
  int currentClosePrice;
  String getScripCode() {return this.scripCode;}
  int getLastTradedPrice() { return lastTradedPrice; }
  void setLastTradedPrice(int lastTradedPrice) { this.lastTradedPrice = lastTradedPrice; }
  int getClosePrice() { return closePrice; }
  void setClosePrice(int closePrice) { this.closePrice = closePrice; }
  int getHighPrice() { return highPrice; }
  void setHighPrice(int highPrice) { this.highPrice = highPrice; }
  int getLowPrice() { return lowPrice; }
  void setLowPrice(int lowPrice) { this.lowPrice = lowPrice; }
  int getOpenPrice() { return openPrice; }
  void setOpenPrice(int openPrice) { this.openPrice = openPrice; }
  int getTimestamp() {return this.timestamp;}
  int getCurrentClosePrice() {return this.currentClosePrice == null ? 0: this.currentClosePrice;}
  void setCurrentClosePrice(int currentClosePrice){this.currentClosePrice = currentClosePrice;}
  String toString() {
    return
      "ScripCode: "+ getScripCode() + "\n" +
      "Last Trade Price: "+ getLastTradedPrice().toString() + "\n" +
      "Close Price: "+ getClosePrice().toString() + "\n" +
      "HighPrice: "+ getHighPrice().toString() + "\n" +
       "LowPrice: "+ getLowPrice().toString() + "\n" +
       "OpenPrice: "+ getOpenPrice().toString() + "\n" +
          "CurrentClosePrice: " + getCurrentClosePrice().toString() + "\n" +
      "Exchange: " + getExchange().toString() + "\n" +
          "Timestamp: " + getTimestamp().toString();
  }
}