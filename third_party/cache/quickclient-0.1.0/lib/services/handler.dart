import 'package:quickclient/services/quickEvent.dart';

// Interface
class Handler {
  void setEventHandler(QuickEvent qEvent){}
  void setAddress(String address){}
  void setPort(int port){}
  void setUserCredentials(String username, String password){}
  bool connect() {return false;}
  bool disconnect(){return true;}
  bool addScrip(int exchange, String scripCode){return true;}
  bool addMarketDepth(int exchange, String scripCode){return true;}
  bool addDerivativeChain(int exchange, String scripCode){return true;}
  bool addOptionChain(int exchange, String scripCode){return true;}
  bool addFutureChain(int exchange, String scripCode){return true;}
  bool addSpotScrip(int exchange, String scripCode){return true;}

  bool deleteScrip(int exchange, String scripCode){return true;}
  bool deleteDerivativeChain(int exchange, String scripCode){return true;}
  bool deleteFutureChain(int exchange, String scripCode){return true;}
  bool deleteOptionChain(int exchange, String scripCode){return true;}
  bool deleteMarketDepth(int exchange, String scripCode){return true;}
  bool deleteSpotScrip(int exchange, String scripCode){return true;}
}