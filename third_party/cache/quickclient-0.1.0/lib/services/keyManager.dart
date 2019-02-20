
import 'package:quickclient/data/indexPacket.dart';
import 'package:quickclient/data/marketDepthPacket.dart';
import 'package:quickclient/data/packet.dart';
import 'package:quickclient/data/quotePacket.dart';

class KeyManager {
  static Map <String, Packet> scripMap = new Map<String, Packet>();
  static Map<String, Packet> mDepthMap = new Map<String, Packet>();
  static Map<String, bool> derivativeChain = new Map<String, bool>();
  static Map<String, bool> futureChain = new Map<String, bool>();
  static Map<String, bool> optionChain = new Map<String, bool>();
  static Map<String, bool> spotChain = new Map<String, bool>();

  static void addScrip(int exchange, String scripCode) {
    var exchangee="$exchange";
    String key = exchangee + "." + scripCode;

    if (!scripMap.containsKey(key)) {
      scripMap={key: new IndexPacket()};
    }
  }

  static void deleteScrip(int exchange, String scripCode) {
    var exchangee="$exchange";
    String key = exchangee + "." + scripCode;
    if (scripMap.containsKey(key)) {
      scripMap.remove(key);
    }
  }

  static void setData(Packet packet) {
    if (packet is QuotePacket){
       setScripData(packet);
     }
     else if (packet is MarketDepthPacket){
       setMarketDepthData(packet);
     }
  }

  static void setScripData(Packet packet) {
    var getExchange = packet.getExchange();
    var getScripCode = packet.getScripCode();
    String key = getExchange.toString() + "." + getScripCode.toString();
    if (scripMap.containsKey(key)) {
      scripMap[key]==(packet);
    }
  }

  static void setMarketDepthData(Packet packet) {
    var getExchange = packet.getExchange();
    var getScripCode = packet.getScripCode();
    String getExchangee=getExchange.toString();
    String getScripCodee=getScripCode;
    String key = getExchangee + "." + getScripCodee;
    if (mDepthMap.containsKey(key)) {
      mDepthMap[key]==(packet);
    }
  }

  static void deleteMarketDepth(int exchange, String scripCode) {
    var exchangee="$exchange";
    String key = exchangee + "." + scripCode;
    if (mDepthMap.containsKey(key)) {
      mDepthMap.remove(key);
    }
  }
   static void addSpotScrip(int exchange, String scripCode)
  {
    var exchangee="$exchange";
    String key = exchangee + "." + scripCode;
    if (!scripMap.containsKey(key)){
     // spotChain.map(true, key);
    }
  }

   static bool isSpotAvailable(int exchange, String scripCode)
  {
    var exchangee="$exchange";
    String key = exchangee + "." + scripCode;
    return spotChain.containsKey(key);
  }

}
