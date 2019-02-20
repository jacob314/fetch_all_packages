

 import 'package:quickclient/data/packet.dart';

class SpotPacket extends Packet
{
 int lastTradedPrice;
 int closePrice;
 int getLastTradedPrice() { return this.lastTradedPrice; }
 int getClosePrice() { return this.closePrice; }

 String toString() {
   return     "ScripCode: "+ getScripCode() + "\n" +
       "LastTradedPrice: "+ getLastTradedPrice().toString() + "\n" +
       "ClosePrice: "+ getClosePrice().toString() + "\n" +
       "Timestamp: "+ getTimestamp().toString() + "\n" +
       "Exchange: " + getExchange().toString();
 }
}