import 'package:quickclient/common/common.dart';
import 'package:quickclient/data/drpPacket.dart';
import 'package:quickclient/data/packet.dart';
import 'package:quickclient/data/spotPacket.dart';
import 'package:quickclient/services/configuration.dart';
import 'package:quickclient/services/eventDetails.dart';
import 'package:quickclient/services/handler.dart';
import 'package:quickclient/services/keyManager.dart';
import 'package:quickclient/services/marketData.dart';
import 'package:quickclient/services/quickEvent.dart';
import 'package:quickclient/data/broadcastPacket.dart';
import 'package:quickclient/data/commodityPacket.dart';
import 'package:quickclient/data/derivativePacket.dart';
import 'package:quickclient/data/indexPacket.dart';
import 'package:quickclient/data/marketDepthPacket.dart';
import 'package:quickclient/data/openInterestPacket.dart';
import 'package:quickclient/data/quotePacket.dart';
import 'package:quickclient/data/quotePacket22.dart';
import 'package:quickclient/data/quotePacket23.dart';
import 'package:quickclient/data/quotePacket27.dart';
import 'package:quickclient/data/quotePacket32.dart';
import 'package:quickclient/data/quotePacket33.dart';
import 'package:quickclient/data/quotePacket34.dart';
import 'package:quickclient/data/quotePacket35.dart';
import 'package:quickclient/data/quotePacket37.dart';
import 'package:quickclient/data/quotePacket38.dart';
import 'package:quickclient/data/quotePacket39.dart';
import 'package:quickclient/data/quotePacket41.dart';
import 'package:quickclient/data/quotePacket42.dart';
import 'package:quickclient/data/reportsPacket.dart';
import 'package:quickclient/data/spreadPacket.dart';
import 'package:quickclient/data/unsolicitedPacket.dart';
class StartQuickClient implements QuickEvent {
  Handler handler;
  StartQuickClient()
  {
    try
    {
      handler = MarketData.getInstance();
      handler.setEventHandler(this);
      handler.setAddress(Common.serverAddress);
      handler.setPort(Common.port);
      handler.setUserCredentials(Common.userName, Common.password);
      if (handler.connect())
      {
        print('Connect initiated');
        onConnect();
      }
      else
      {
        print("Connect failed ");
      }
    }
    catch (e)
    {
      print("Error in StartQuickClient: $e" );
    }
  }

  @override
  void onError(EventDetails details) {
    print("StartQuickClient.OnError(:::OnError:::)");
    print("StartQuickClient.onError(:::code:::)"+ details.getCode().toString());
  }

  @override
  void onDisconnect(EventDetails details) {
    print("StartQuickClient.OnDisconnect(:::Disconnect succeeded:::)");
    print("StartQuickClient.onDisconnect(:::code:::)"+ details.getCode().toString());
  }


  @override
  void onConnect() {
    print("StartQuickClient.OnConnect(:::Connect succeeded:::)");
    handler.addScrip(Common.exchange, Common.scriptCode);
    // handler.addMarketDepth(Common.exchange, Common.scriptCode);
    //handler.addOptionChain(Common.exchange, Common.scriptCode);
    //handler.addFutureChain(Common.exchange, Common.scriptCode);
    // handler.addDerivativeChain(Common.exchange, Common.scriptCode);
    //handler.addSpotScrip(Common.exchange, Common.scriptCode);
  }

  static void onPacketArrived(Packet packet){
    if (packet.exchange == Configuration.MCX || packet.exchange == Configuration.NSECUR)
    {
      if (packet is MarketDepthPacket || packet is IndexPacket || packet is BroadcastPacket || packet is DPRPacket || packet is SpreadPacket || packet is DerivativePacket || packet is OpenInterestPacket || packet is QuotePacket42)
      {
        onPacketArrivedDisplay(packet);
      }
      else
      {
        bool isSpotAvailable = Configuration.spotChain;//checkForSpot(packet.exchange, packet.getScripCode());
        if (isSpotAvailable)
        {
          SpotPacket spotPacket = new SpotPacket();
          spotPacket.exchange = packet.exchange;
          spotPacket.scripCode = packet.getScripCode();
          if(packet is CommodityPacket)
          {
            CommodityPacket p = (packet);
            spotPacket.lastTradedPrice = p.getLastTradedPrice();
            spotPacket.closePrice = p.getClosePrice();
          }
          else if(packet is CommodityPacket28)
          {
            CommodityPacket28 p = (packet);
            spotPacket.lastTradedPrice = p.getLastTradedPrice();
            spotPacket.closePrice = p.getClosePrice();
          }
          else if (packet is QuotePacket37)
          {
            QuotePacket37 p = (packet);
            spotPacket.lastTradedPrice = p.getLastTradedPrice();
            spotPacket.closePrice = p.getClosePrice();
          }
          else if (packet is QuotePacket38)
          {
            QuotePacket38 p = (packet);
            spotPacket.lastTradedPrice = p.getLastTradedPrice();
            spotPacket.closePrice = p.getClosePrice();
          }
          else if (packet is QuotePacket39)
          {
            QuotePacket39 p = (packet);
            spotPacket.lastTradedPrice = p.getLastTradedPrice();
            spotPacket.closePrice = p.getClosePrice();
          }
          else if (packet is QuotePacket27)
          {
            QuotePacket27 p = (packet);
            spotPacket.lastTradedPrice = p.getLastTradedPrice();
            spotPacket.closePrice = p.getClosePrice();
          }
          onPacketArrivedDisplay(spotPacket);
        }
        else
        {
          onPacketArrivedDisplay(packet);
        }
      }
    }
    else{
      onPacketArrivedDisplay(packet);
    }


  }

  static void onPacketArrivedDisplay(Packet packet){
    if (packet is IndexPacket) {
      IndexPacket p = (packet);
      print("StartQuickClient.onPacketArrived(:::IndexPacket Arrived:::)");
      print(p.toString());
    } else if (packet is DerivativePacket) {
      DerivativePacket p=(packet);
      print("StartQuickClient.onPacketArrived(:::DerivativePacket Arrived:::)");
      print(p.toString());

    } else if (packet is QuotePacket) {
      QuotePacket p=(packet);
      print("StartQuickClient.onPacketArrived(:::QuotePacket Arrived:::)");
      print(p.toString());
    } else if(packet is MarketDepthPacket){
      MarketDepthPacket p = (packet) ;//var p = packet as MarketDepthPacket;
      print("StartQuickClient.onPacketArrived(:::MarketDepthPacket Arrived:::)");
      print("Scripcode: " + packet.getScripCode());
      print("BuyOrders: " + p.getBuyOrders()[0].toString() + " SellOrders: " + p.getSellOrders()[0].toString());
      print("BuyOrders: " + p.getBuyOrders()[1].toString() + " SellOrders: " + p.getSellOrders()[1].toString());
      print("BuyOrders: " + p.getBuyOrders()[2].toString() + " SellOrders: " + p.getSellOrders()[2].toString());
      print("BuyOrders: " + p.getBuyOrders()[3].toString() + " SellOrders: " + p.getSellOrders()[3].toString());
      print("BuyOrders: " + p.getBuyOrders()[4].toString() + " SellOrders: " + p.getSellOrders()[4].toString());

      print("BuyPrice: " + p.getBuyPrice()[0].toString() + " SellPrice: " + p.getSellPrice()[0].toString());
      print("BuyPrice: " + p.getBuyPrice()[1].toString() + " SellPrice: " + p.getSellPrice()[1].toString());
      print("BuyPrice: " + p.getBuyPrice()[2].toString() + " SellPrice: " + p.getSellPrice()[2].toString());
      print("BuyPrice: " + p.getBuyPrice()[3].toString() + " SellPrice: " + p.getSellPrice()[3].toString());
      print("BuyPrice: " + p.getBuyPrice()[4].toString() + " SellPrice: " + p.getSellPrice()[4].toString());

      print("BuyQty: " + p.getBuyQty()[0].toString() + " SellQty: " + p.getSellQty()[0].toString());
      print("BuyQty: " + p.getBuyQty()[1].toString() + " SellQty: " + p.getSellQty()[1].toString());
      print("BuyQty: " + p.getBuyQty()[2].toString() + " SellQty: " + p.getSellQty()[2].toString());
      print("BuyQty: " + p.getBuyQty()[3].toString() + " SellQty: " + p.getSellQty()[3].toString());
      print("BuyQty: " + p.getBuyQty()[4].toString() + " SellQty: " + p.getSellQty()[4].toString());
      print("Timestamp: " + p.getTimestamp().toString());

    } else if (packet is UnsolicitedPacket) {
      UnsolicitedPacket p= (packet);
      print("StartQuickClient.onPacketArrived(:::UnsolicitedPacket Arrived:::)");
      print(p.toString());
    }else if (packet is QuotePacket41){
      QuotePacket41 p = (packet) ;
      print("StartQuickClient.onPacketArrived(:::QuotePacket41 Arrived:::)");
      print(p.toString());
    }
    else if (packet is QuotePacket22) {
      QuotePacket22 p=(packet);
      print("StartQuickClient.onPacketArrived(:::QuotePacket22 Arrived:::)");
      print(p.toString());
    }
    else if (packet is QuotePacket23) {
      QuotePacket23 p=(packet);
      print("StartQuickClient.onPacketArrived(:::QuotePacket23 Arrived:::)");
      print(p.toString());
    }
    else if (packet is QuotePacket27) {
      QuotePacket27 p=(packet);
      print("StartQuickClient.onPacketArrived(:::QuotePacket27 Arrived:::)");
      print(p.toString());
    }
    else if (packet is QuotePacket35) {
      QuotePacket35 p=(packet);
      print("StartQuickClient.onPacketArrived(:::QuotePacket35 Arrived:::)");
      print(p.toString());
    }
    else if (packet is QuotePacket39) {
      QuotePacket39 p=(packet);
      print("StartQuickClient.onPacketArrived(:::QuotePacket39 Arrived:::)");
      print(p.toString());
    }
    else if (packet is QuotePacket34) {
      QuotePacket34 p=(packet);
      print("StartQuickClient.onPacketArrived(:::QuotePacket34 Arrived:::)");
      print(p.toString());
    }
    else if (packet is QuotePacket38) {
      QuotePacket38 p = (packet);
      print("StartQuickClient.onPacketArrived(:::QuotePacket38 Arrived:::)");
      print(p.toString());
    }
    else if (packet is QuotePacket33) {
      QuotePacket33 p=(packet);
      print("StartQuickClient.onPacketArrived(:::QuotePacket33 Arrived:::)");
      print(p.toString());
    }
    else if (packet is QuotePacket37) {
      QuotePacket37 p=(packet);
      print("StartQuickClient.onPacketArrived(:::QuotePacket37 Arrived:::)");
      print(p.toString());
    }
    else if (packet is CommodityPacket28) {
      CommodityPacket28 p=(packet);
      print("StartQuickClient.onPacketArrived(:::CommodityPacket28 Arrived:::)");
      print(p.toString());
    }
    else if (packet is QuotePacket32) {
      QuotePacket32 p=(packet);
      print("StartQuickClient.onPacketArrived(:::QuotePacket32 Arrived:::)");
      print(p.toString());
    }
    else if (packet is QuotePacket42) {
      QuotePacket42 p=(packet);
      print("StartQuickClient.onPacketArrived(:::QuotePacket42 Arrived:::)");
      print(p.toString());
    }
    else if (packet is CommodityPacket29) {
      CommodityPacket29 p=(packet);
      print("StartQuickClient.onPacketArrived(:::CommodityPacket29 Arrived:::)");
      print(p.toString());
    }
    else if (packet is SpreadPacket) {
      SpreadPacket p=(packet);
      print("StartQuickClient.onPacketArrived(:::SpreadPacket Arrived:::)");
      print(p.toString());
    }
    else if (packet is ReportsPacket) {
      ReportsPacket p=(packet);
      print("StartQuickClient.onPacketArrived(:::ReportsPacket Arrived:::)");
      print(p.toString());
    }

    else if (packet is OpenInterestPacket) {
      OpenInterestPacket p=(packet);
      print("StartQuickClient.onPacketArrived(:::Open Interest Packet Arrived:::)");
      print(p.toString());
    }
    else if(packet is BroadcastPacket){
      BroadcastPacket p=(packet);
      print("StartQuickClient.onPacketArrived(:::Open Broadcast Packet Arrived:::)");
      print(p.toString());
    }else if (packet is DPRPacket) {
      DPRPacket p=(packet);
      print("StartQuickClient.onPacketArrived(:::DPRPacket Arrived:::)");
      print(p.toString());
    }
    else if (packet is SpotPacket) {
      SpotPacket p=(packet);
      print("StartQuickClient.onPacketArrived(:::SpotPacket Arrived:::)");
      print(p.toString());
    }
  }

  static bool checkForSpot(int exchange, String scripCode) {
    return KeyManager.isSpotAvailable(exchange, scripCode);
  }

  void main() {
    StartQuickClient startQuickClient = new StartQuickClient();
  }
}