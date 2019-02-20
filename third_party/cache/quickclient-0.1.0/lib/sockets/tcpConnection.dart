import 'dart:async';
import 'dart:io';
import 'dart:core';

import 'dart:typed_data';

import 'package:quickclient/common/buffer_reader.dart';
import 'package:quickclient/common/readBuffer.dart';
import 'package:quickclient/common/startQuickClient.dart';
import 'package:quickclient/data/broadcastPacket.dart';
import 'package:quickclient/data/commodityPacket.dart';
import 'package:quickclient/data/derivativePacket.dart';
import 'package:quickclient/data/indexPacket.dart';
import 'package:quickclient/data/marketDepthPacket.dart';
import 'package:quickclient/data/openInterestPacket.dart';
import 'package:quickclient/data/packet.dart';
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
import 'package:quickclient/services/configuration.dart';
import 'package:quickclient/services/eventDetails.dart';
import 'package:quickclient/services/mdHandler.dart';
import 'package:quickclient/services/packetBuilder.dart';
import 'package:quickclient/services/quickEvent.dart';

class TcpSocket {
  Socket tcpClient;
  MDHandler mDHandler;
  QuickEvent quickEvent;
  bool isRunning = false;
  int  startOfFrame = 255;
  bool isNewVersionAuthentication = false;
  Configuration configuration = null;


  TcpSocket(MDHandler mdHandler, Configuration config) {
    mDHandler = mdHandler;
    configuration = config;
  }

  void connect() {
    try
    {
     /*
For Authentication
 */
      List bufferAuthentication;
      if (Configuration.USER_NAME != null) {
        if(isNewVersionAuthentication){
            bufferAuthentication = authenticateNewVersion();
        }
      else{
            bufferAuthentication = authentication();
          }
      }

      Future<Socket> futureSocket = Socket.connect(Configuration.SERVER_ADDRESS,Configuration.SERVER_PORT).then((socket) {
         socket.listen((data) {
           BufferReader br = new BufferReader(new Uint8List.fromList(data).buffer.asByteData());
          int lIn = br.getUint8();
          if (lIn == startOfFrame) {
             int packetLength = br.getInt16(); // read the lengthOf the packet
             ReadBuffer br1 = new ReadBuffer(new Uint8List.fromList(data.sublist(3, packetLength+3)).buffer.asByteData());
             while (br1.data.lengthInBytes < packetLength ){
               br1 = new ReadBuffer(new Uint8List.fromList(data.sublist(3, packetLength+3)).buffer.asByteData());
             }
             processPackets(br1);
           }
        });

        if(bufferAuthentication !=null){
          socket.add(bufferAuthentication.cast<int>()); //sending Request for Authentication
        }

        /*
Prepare send Request ByteArray For Add Script...
 */
        if (Configuration.EXCHANGE_CODE != null && Configuration.SCRIPT_CODE != null) {
          List buffer = PacketBuilder.buildForAddScrip(Configuration.EXCHANGE_CODE, Configuration.SCRIPT_CODE);
          socket.add(buffer.cast<int>());
        }

        /*
Prepare send Request ByteArray For Add MarketDepth Script...
 */

        if (Configuration.MDEXCHANGE_CODE != null && Configuration.MDSCRIPT_CODE != null) {
          List buffer = PacketBuilder.buildForAddMarketDepth(Configuration.MDEXCHANGE_CODE, Configuration.MDSCRIPT_CODE);
          socket.add(buffer.cast<int>()); //sending Request MarketDepth AddScript
        }

        /*
Prepare send Request ByteArray For AddDerivativeChain Script...
 */

        if(Configuration.DERIVATIVE_EXCHANGE_CODE != null && Configuration.DERIVATIVE_SCRIPT_CODE != null){
          List buffer = PacketBuilder.buildForAddDerivativeChain(Configuration.DERIVATIVE_EXCHANGE_CODE, Configuration.DERIVATIVE_SCRIPT_CODE);
          socket.add(buffer.cast<int>());//sending Request DerivativeChain
        }

        /*
Prepare send Request ByteArray For addFutureChain Script...
 */

        if(Configuration.FUTURECHAIN_EXCHANGE_CODE != null && Configuration.FUTURECHAIN_SCRIPT_CODE != null){
          List buffer = PacketBuilder.buildForAddFutureChain(Configuration.FUTURECHAIN_EXCHANGE_CODE, Configuration.FUTURECHAIN_SCRIPT_CODE);
          socket.add(buffer.cast<int>());//sending Request FutureChain
        }

        /*
Prepare send Request ByteArray For addOptionChain Script...
 */

        if(Configuration.OPTIONCHAIN_EXCHANGE_CODE != null && Configuration.OPTIONCHAIN_SCRIPT_CODE != null){
          List buffer = PacketBuilder.buildForAddOptionChain(Configuration.OPTIONCHAIN_EXCHANGE_CODE, Configuration.OPTIONCHAIN_SCRIPT_CODE);
          socket.add(buffer.cast<int>());//sending Request OptionChain
        }

        /*
Prepare send Request ByteArray For addSpot Script...
 */

        if(Configuration.SPOT_EXCHANGE_CODE != null && Configuration.SPOT_SCRIPT_CODE != null){
          List buffer = PacketBuilder.buildForAddSpotScript(Configuration.SPOT_EXCHANGE_CODE, Configuration.SPOT_SCRIPT_CODE);
          socket.add(buffer.cast<int>());//sending Request SpotScrip
        }

        /*
Prepare send Request ByteArray For deleteScrip ...
 */

        if(Configuration.DELETE_EXCHANGE_CODE != null && Configuration.DELETE_SCRIPT_CODE != null){
          List buffer = PacketBuilder.buildForDeleteScrip(Configuration.DELETE_EXCHANGE_CODE, Configuration.DELETE_SCRIPT_CODE);
          socket.add(buffer.cast<int>());//sending Request deleteScrip
        }

        /*
Prepare send Request ByteArray For deleteDerivativeChain ...
 */

        if(Configuration.DELETEDERIVATIVE_EXCHANGE_CODE != null && Configuration.DELETEDERIVATIVE_SCRIPT_CODE != null){
          List buffer = PacketBuilder.buildForDeleteDerivativeChain(Configuration.DELETEDERIVATIVE_EXCHANGE_CODE, Configuration.DELETEDERIVATIVE_SCRIPT_CODE);
          socket.add(buffer.cast<int>());//sending Request deleteDerivativeChain
        }

        /*
Prepare send Request ByteArray For deleteFutureChain ...
 */

        if(Configuration.DELETEFUTURE_EXCHANGE_CODE != null && Configuration.DELETEFUTURE_SCRIPT_CODE != null){
          List buffer = PacketBuilder.buildForDeleteFutureChain(Configuration.DELETEFUTURE_EXCHANGE_CODE, Configuration.DELETEFUTURE_SCRIPT_CODE);
          socket.add(buffer.cast<int>());//sending Request deleteFutureChain
        }

        /*
Prepare send Request ByteArray For deleteOptionChain ...
 */

        if(Configuration.DELETEOPTION_EXCHANGE_CODE != null && Configuration.DELETEOPTION_SCRIPT_CODE != null){
          List buffer = PacketBuilder.buildForDeleteOptionChain(Configuration.DELETEOPTION_EXCHANGE_CODE, Configuration.DELETEOPTION_SCRIPT_CODE);
          socket.add(buffer.cast<int>());//sending Request deleteOptionChain
        }

        /*
Prepare send Request ByteArray For deleteMarketDepth ...
 */

        if(Configuration.DELETEMD_EXCHANGE_CODE != null && Configuration.DELETEMD_SCRIPT_CODE != null){
          List buffer = PacketBuilder.buildForDeleteMarketDepth(Configuration.DELETEMD_EXCHANGE_CODE, Configuration.DELETEMD_SCRIPT_CODE);
          socket.add(buffer.cast<int>());//sending Request deleteMarketDepth
        }


        /*
Prepare send Request ByteArray For deleteSpotScrip ...
 */

        if(Configuration.DELETESPOT_EXCHANGE_CODE != null && Configuration.DELETESPOT_SCRIPT_CODE != null){
          List buffer = PacketBuilder.buildForSpotScript(Configuration.DELETESPOT_EXCHANGE_CODE, Configuration.DELETESPOT_SCRIPT_CODE);
          socket.add(buffer.cast<int>());//sending Request deleteSpotScrip
        }


      }).catchError((e)
         {
           var se = e as SocketException;
           if (se == null)
           {
             se = e.InnerException as SocketException;
           }
           else
           {
             if (se.hashCode == 10061)
             {
               print("Connect: 10061 Connection refused.");
             }
             else
             {
               print("Connect: " + e.Message);
             }
           }
           EventDetails eD = new EventDetails();
           eD.code = EventDetails.UNABLE_TO_CONNECT;
           eD.description = "Connection refused";
           mDHandler.onError(eD);
         });
      isRunning = true;
      }
      catch (e)
    {

        IOException ioE = e as IOException;
        if (ioE != null)
        {
          SocketException iE = e.InnerException as SocketException;

          if (iE != null && iE.hashCode != 10060 && iE.hashCode != 10035 && iE.hashCode != 10004)
          {
            if (iE.hashCode == 10054)
            {
              dropAndClose(EventDetails.EXTERNAL_DISCONNECTION);
            }
            else
            {
              EventDetails eDetails = new EventDetails();
              eDetails.code = iE.hashCode;
              eDetails.description = iE.message;
              mDHandler.onError(eDetails);
            }

        }
      }
      print("Exception occured while connecting Quick Server :" + e.getMessage());
    }
  }

  void enableNewVersionAuthentication() {
    isNewVersionAuthentication = true;
  }

  void processQuoteAndDepth(ReadBuffer br) {
    Packet packet;
    try
    {
      packet = PacketBuilder.buildForTCP(br);
     StartQuickClient.onPacketArrived(packet);
    } catch ( e) {
      print("Exception occured in buildForTCP packet :" + e.getMessage());
    }
  }

  void processPackets(ReadBuffer br) {
    int packetType = br.getInt16();
    switch (packetType) {
      case Configuration.LOGIN:
        readLoginResponse(br);
        break;
      case Configuration.QUOTE:
      case Configuration.MDEPTH:
        processQuoteAndDepth(br);
        break;
      case Configuration.UNSOLICITED:
        processUnsolicited(br);
        break;
      case Configuration.GENERALBCAST:
        processGeneralBcast(br);
        break;
      default:
        break;
    }
  }

  void readLoginResponse(ReadBuffer br) {
    try {
      int filler = br.getInt16();
      int length = br.getUint8();
      Uint8List buf =br.getUint8List(length);
      print("Login Success");

    } catch ( e) {
      print("Not reading the login response :" + e.getMessage());
    }
  }

  void processUnsolicited(ReadBuffer br) {
    Packet packet;
    try {
      packet = PacketBuilder.buildForUnsolicited(br);
      StartQuickClient.onPacketArrived(packet);
    } catch ( e) {
      print("Exception occured in buildForUnsolicited packet :" + e.getMessage());
    }
  }

  void processGeneralBcast(ReadBuffer br){
    Packet packet;
    try {
      packet = PacketBuilder.buildForTCP(br);
      StartQuickClient.onPacketArrived(packet);
    } catch ( e) {
      print("Exception occured in buildForTCP packet :" + e.getMessage());
    }
  }

  void dropAndClose(int errorCode) {
    if (tcpClient != null) {
      isRunning = false;
      try {
        tcpClient.destroy();
        tcpClient.close();
      } catch ( e) {
        print("Connection not closed :" + e.getMessage());
      }
      tcpClient = null;
      EventDetails event = new EventDetails();
      event.setCode(errorCode);
      event.setDescription("Application closed and aborted session");
      mDHandler.onDisconnect(event);
    }
  }

  static List authentication() {
    var login=Configuration.LOGIN;
    var userName=Configuration.USER_NAME;
    var usernameLength=userName.length;
    int length = usernameLength + 3;
    var messageLength = length;
    List usernameList=userName.codeUnits;
    List finalList=new List();

    var totalMeg='255, $messageLength, 0, $login, 0, $usernameLength, $usernameList';
    var removeOpenBrace=  totalMeg.replaceAll((r'['), '');
    var removeClosedBrace=removeOpenBrace.replaceAll((r']'), '');
    var finalData =[];
    var obj = removeClosedBrace.split(',').toList();
    var it = obj.iterator;
    while (it.moveNext()) {
      finalData.add(int.parse(it.current));
    }
    finalList.add(finalData);
    return finalList[0];
  }

  static List authenticateNewVersion() {
  var login=Configuration.LOGIN;
  var userName=Configuration.USER_NAME;
  var usernameLength=userName.length;
  int length = usernameLength + 3;
  var messageLength = length;
  List usernameList=userName.codeUnits;
  List finalList=new List();

  var totalMeg='255, $messageLength, $login, 0, $usernameLength, $usernameList';
  var removeOpenBrace=  totalMeg.replaceAll((r'['), '');
  var removeClosedBrace=removeOpenBrace.replaceAll((r']'), '');
  var finalData =[];
  var obj = removeClosedBrace.split(',').toList();
  var it = obj.iterator;
  while (it.moveNext()) {
  finalData.add(int.parse(it.current));
  }
  finalList.add(finalData);
  return finalList[0];
}

  void onPacketArrived(Packet packet) {

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
    }
  }
}


