
import 'package:quickclient/data/packet.dart';

class BroadcastPacket extends Packet{
  String message ;
  String getMessage(){return message;}
  void setMessage(String message) { this.message = message; }

  String toString() {
    return "Message: "+ getMessage();
  }
}