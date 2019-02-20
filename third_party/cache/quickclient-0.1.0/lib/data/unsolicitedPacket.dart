import 'package:quickclient/data/packet.dart';

class UnsolicitedPacket extends Packet{
  String clientCode ;
  String message ;
  String getClientCode() { return this.clientCode; }
  void setClientCode(String clientCode) { this.clientCode = clientCode; }
  String getMessage() { return this.message;}
  void setMessage(String message) {this.message = message;}

  String toString() {
    return "ClientCode: "+ getClientCode().toString() + "\n" +
           "Message: "+ getMessage();
  }
}