
import 'package:quickclient/data/packet.dart';
import 'package:quickclient/services/eventDetails.dart';
//Interface
class MDHandler {

  // raise this in the event of successful connection with Quick Server
  void onConnect( ){}
  // raise this in the event on forceful disconnection
  void onDisconnect(EventDetails details){}
  // raise this in the event of any error, implied disconnection also
   void onError(EventDetails details){}
  // raise this when single packet arrives
  void onPacketArrived(Packet packet){}

}