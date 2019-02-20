import 'package:quickclient/data/packet.dart';

class MarketDepthPacket extends Packet {

  int noOfRecords ;
  List buyPrice ;
  List sellPrice ;
  List buyQty ;
  List sellQty ;
  List buyOrders ;
  List sellOrders ;

  int getNoOfRecords() { return noOfRecords; }
  void setNoOfRecords(int noOfRecords ) { this.noOfRecords = noOfRecords; }

  List getBuyPrice() { return buyPrice; }
  void setBuyPrice(List buyPrice) { this.buyPrice = buyPrice; }

  List getSellPrice() { return sellPrice; }
  void setSellPrice(List sellPrice) { this.sellPrice = sellPrice; }

  List getBuyQty() { return buyQty; }
  void setBuyQty(List buyQty) { this.buyQty = buyQty; }

  List getSellQty() { return sellQty; }
  void setSellQty(List sellQty) { this.sellQty = sellQty; }

  List getBuyOrders() { return buyOrders; }
  void setBuyOrders(List buyOrders) { this.buyOrders = buyOrders; }

  List getSellOrders() { return sellOrders; }
  void setSellOrders(List sellOrders) { this.sellOrders = sellOrders; }
}