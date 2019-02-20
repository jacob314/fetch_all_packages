import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:quickclient/common/readBuffer.dart';
import 'package:quickclient/data/broadcastPacket.dart';
import 'package:quickclient/data/commodityPacket.dart';
import 'package:quickclient/data/derivativePacket.dart';
import 'package:quickclient/data/drpPacket.dart';
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
import 'package:quickclient/data/records.dart';
import 'package:quickclient/data/reportsPacket.dart';
import 'package:quickclient/data/spreadPacket.dart';
import 'package:quickclient/data/unsolicitedPacket.dart';
import 'package:quickclient/services/configuration.dart';

class PacketBuilder {
  // int8 - conversion to one byte integer representation
  // int32 - conversion to 4 bytes integer representation
  // Uint8List - Creates a Uint8List with the same length as the elements
  // list and copies over the elements. A fixed-length list of 8-bit
  // unsigned integers.

   static Packet buildForTCP(ReadBuffer br) {
    Packet packet;
    try
    {
      int service=br.getUint8();
      int exchange=  br.getUint8();
      int pType = br.getUint8();
    switch (pType) {
      case 3:
        packet = buildIndex(br);
        break;
      case 1:
        packet = buildQuote(br, exchange);
        break;
      case 4:
        packet = buildMarketDepth(br, exchange);
        break;
      case 5:
        packet = buildDerivativeQuote(br);
        break;
      case 6:
        packet = buildCommodityQuote(br);
        break;
      case 2:
        packet = buildQuote2(br);
        break;
      case 12:
        packet = buildOpenInterest(br);
        break;
      case 13:
        packet = buildQuote13(br);
        break;
      case 21:
        packet = buildDPR(br);
        break;
      case 105:
        packet = BuildExchangeMessage(br);
        break;
      case 22:
        packet = BuildQuote22(br, exchange);
        break;
      case 23:
        packet = BuildQuote23(br);
        break;
      case 27:
        packet = BuildQuote27(br);
        break;
      case 29:
        packet = BuildQuote29(br);
        break;
      case 28:
        packet = BuildQuote28(br);
        break;
      case 35:
        packet = BuildQuote35(br, true, exchange);
        break;
      case 39:
        packet = BuildQuote35(br, false, exchange);
        break;
      case 34:
        packet = BuildQuote34(br, true);
        break;
      case 38:
        packet = BuildQuote34(br, false);
        break;
      case 33:
        packet = BuildQuote33(br, true);
        break;
      case 37:
        packet = BuildQuote33(br, false);
        break;
      case 32:
        packet = BuildQuote32(br);
        break;
      case 41:
        packet = BuildQuote41(br, exchange);
        break;
      case 42:
        packet = BuildQuote42(br);
        break;
      case 55:
        packet = BuildSpread(br);
        break;
      case 71:
        packet = BuildReports(br, pType);
        break;
      case 72:
        packet = BuildReports(br, pType);
        break;
      case 73:
        packet = BuildReports(br, pType);
        break;
      default:
        packet = null;
        break;
    }
    packet.setExchange(exchange);
    return packet;
    }
    catch (e) {
      print("Exception occured while buildForTCP :" + e.getMessage());
  return packet;
    }
  }

   static Packet buildIndex(ReadBuffer br) {
    IndexPacket packet = new IndexPacket();
    // int8 - conversion to one byte integer representation
    // int32 - conversion to 4 bytes integer representation
    // Uint8List - Creates a Uint8List with the same length as the elements
    // list and copies over the elements. A fixed-length list of 8-bit
    // unsigned integers.
    try {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      packet.lastTradedPrice = br.getInt32();
      packet.closePrice=br.getInt32();
      packet.highPrice=br.getInt32();
      packet.lowPrice=br.getInt32();
      packet.openPrice=br.getInt32();
      packet.timestamp=br.getInt64();
      int closePriceIndicator = br.getUint8();
      if (closePriceIndicator == 1)
      {
        packet.currentClosePrice = br.getInt32();
      }


    return packet;
    }
    catch (e) {
     print("Exception occured while buildIndex :" + e.getMessage());
     return packet;
    }
  }

   static Packet buildQuote(ReadBuffer br, int exchange) {
    QuotePacket packet = new QuotePacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      packet.lastTradedPrice = br.getInt32();
      packet.closePrice=br.getInt32();
      packet.bestBuyPrice=br.getInt32();
      packet.bestBuyQty=br.getInt32();
      packet.bestSellPrice=br.getInt32();
      packet.bestSellQty=br.getInt32();
      packet.totalTradedQty=br.getInt32();
      packet.highPrice=br.getInt32();
      packet.lowPrice=br.getInt32();
      packet.openPrice=br.getInt32();
      packet.lastTradedQty=br.getInt32();
      packet.weightedAveragePrice=br.getInt32();
      packet.totalBuy=br.getInt32();
      packet.totalSell=br.getInt32();
      packet.lowerCircuit=br.getInt32();
      packet.upperCircuit=br.getInt32();
      packet.timestamp=br.getInt64();

    return packet;
    }
    catch (e) {
      print("Exception occured while buildQuote :" + e.getMessage());
      return packet;
    }
  }

   static Packet buildMarketDepth(ReadBuffer br, int exchange) {
    MarketDepthPacket mDepthPacket = new MarketDepthPacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      mDepthPacket.scripCode= utf8.decode(scriptCodeArray);
      mDepthPacket.noOfRecords = br.getUint8();
      var bPrice = new List(mDepthPacket.noOfRecords);
      var bQty = new List(mDepthPacket.noOfRecords);
      var sPrice = new List(mDepthPacket.noOfRecords);
      var sQty = new List(mDepthPacket.noOfRecords);
      var sOrders = new List(mDepthPacket.noOfRecords);
      var bOrders = new List(mDepthPacket.noOfRecords);
      for(int i= 0; i < mDepthPacket.noOfRecords; i++)
      {
        bPrice[i] = br.getInt32();
        bQty[i] = br.getInt32();
        sPrice[i] = br.getInt32();
        sQty[i] = br.getInt32();
        if (exchange == Configuration.BSE || exchange == Configuration.BSEFO)
        {
          bOrders[i] = br.getInt32();
          sOrders[i] = br.getInt32();
        }
        else
        {
          bOrders[i] = br.getUint16();
          sOrders[i] = br.getUint16();
        }
      }
      mDepthPacket.buyOrders = bOrders;
      mDepthPacket.buyPrice = bPrice;
      mDepthPacket.buyQty = bQty;
      mDepthPacket.sellOrders = sOrders;
      mDepthPacket.sellPrice = sPrice;
      mDepthPacket.sellQty = sQty;
      mDepthPacket.timestamp = br.getInt64();
      return mDepthPacket;
    }
    catch (e) {
      print("Exception occured while buildQuote :" + e.getMessage());
      return mDepthPacket;
    }
  }

    static Packet buildCommodityQuote(ReadBuffer br) {
     CommodityPacket packet = new CommodityPacket();

     br.getUint8();
     int sLength = br.getUint8();
     Uint8List scriptCodeArray=br.getUint8List(sLength);
     packet.scripCode= utf8.decode(scriptCodeArray);
     packet.lastTradedPrice=br.getInt32();
     packet.closePrice=br.getInt32();
     packet.bestBuyPrice=br.getInt32();
     packet.bestBuyQty=br.getInt32();
     packet.bestSellPrice=br.getInt32();
     packet.bestSellQty=br.getInt32();
     packet.totalTradedQty=br.getInt32();
     packet.highPrice=br.getInt32();
     packet.lowPrice=br.getInt32();
     packet.openPrice=br.getInt32();
     packet.lastTradedQty=br.getInt32();
     packet.weightedAveragePrice=br.getInt32();
     packet.totalBuy=br.getFloat64();
     packet.totalSell=br.getFloat64();
     packet.lifeLow = br.getInt32();
     packet.lifeHigh =br.getInt32();
     packet.openInterest = br.getInt32();
     packet.totalTradedValueD = br.getFloat64();
     packet.timestamp=br.getInt64();
     return packet;
   }

   static Packet buildDerivativeQuote(ReadBuffer br) {
    DerivativePacket packet = new DerivativePacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      sLength = br.getUint8(); // read the underlying scrip code length
      Uint8List underlyingScriptCodeArray=br.getUint8List(sLength);
      packet.underlyingScripCode = utf8.decode(underlyingScriptCodeArray);
      packet.isFuture = br.getUint8(); // 1 if Future 0 means it is Option
      packet.lastTradedPrice = br.getInt32();
      packet.closePrice = br.getInt32();
      packet.bestBuyPrice = br.getInt32();
      packet.bestBuyQty = br.getInt32();
      packet.bestSellPrice = br.getInt32();
      packet.bestSellQty = br.getInt32();
      packet.totalTradedQty = br.getInt32();
      packet.highPrice = br.getInt32();
      packet.lowPrice = br.getInt32();
      packet.openPrice = br.getInt32();
      packet.lastTradedQty = br.getInt32();
      packet.lowerCircuit = br.getInt32();
      packet.upperCircuit = br.getInt32();
      packet.weightedAveragePrice = br.getInt32();
      packet.totalBuy = br.getInt32();
      packet.totalSell = br.getInt32();
      packet.timestamp = br.getInt64();
      int isIndex = br.getUint8(); // Added new to find out whether this derivative contract's underlying is Index or not
      packet.isIndex = isIndex == 1 ? true : false;

    return packet;
    }
    catch (e) {
      print("Exception occured while buildDerivativeQuote :" + e.getMessage());
      return packet;
    }
  }

   static Packet buildQuote2(ReadBuffer br) {
    QuotePacket packet = new QuotePacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      packet.lastTradedPrice = br.getInt32();
      packet.highPrice = br.getInt32();
      packet.totalBuy = br.getInt32();
      packet.lowPrice = br.getInt32();
      packet.totalSell = br.getInt32();
      packet.totalTradedQty = br.getInt32();
      packet.timestamp = br.getInt64(); //Add newly to manage the time on BSE packets

    return packet;
    }
    catch (e) {
      print("Exception occured while buildQuote2 :" + e.getMessage());
      return packet;
    }
  }

   static Packet buildOpenInterest(ReadBuffer br) {
    OpenInterestPacket packet = new OpenInterestPacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      packet.openInterest = br.getInt32();
      packet.lastTradedPrice = br.getInt32();
      packet.totalTradedQty = br.getInt32();

    return packet;
    }
    catch (e) {
      print("Exception occured while buildOpenInterest :" + e.getMessage());
      return packet;
    }
  }

   static Packet buildQuote13(ReadBuffer br) {
    QuotePacket packet = new QuotePacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      packet.lastTradedPrice = br.getInt32();
      packet.totalTradedQty = br.getInt32();
      packet.highPrice = br.getInt32();
      packet.lowPrice = br.getInt32();
      packet.openPrice = br.getInt32();
      packet.closePrice = br.getInt32();
      packet.lastTradedQty = br.getInt32();
      packet.weightedAveragePrice = br.getInt32();
      packet.totalBuy = br.getInt32();
      packet.totalSell = br.getInt32();
      packet.lowerCircuit = br.getInt32();
      packet.upperCircuit = br.getInt32();
      packet.timestamp = br.getInt64();

    return packet;
    }
    catch (e) {
      print("Exception occured while buildQuote13 :" + e.getMessage());
      return packet;
    }
  }

   static Packet buildDPR(ReadBuffer br) {
    DPRPacket packet = new DPRPacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      packet.lowerCircuit = br.getInt32();
      packet.upperCircuit = br.getInt32();

    return packet;
    }
    catch (e) {
      print("Exception occured while buildDPR :" + e.getMessage());
      return packet;
    }
  }

   static Packet buildForUnsolicited(ReadBuffer br) {
    UnsolicitedPacket packet = new UnsolicitedPacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      int pLength = br.getUint16();
      Uint8List messageCodeArray=br.getUint8List(pLength);
      packet.message= utf8.decode(messageCodeArray);

    return packet;
    }
    catch (e) {
      print("Exception occured while buildForUnsolicited :" + e.getMessage());
      return packet;
    }
  }

   static Packet BuildExchangeMessage(ReadBuffer br) {
    BroadcastPacket packet = new BroadcastPacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.message= utf8.decode(scriptCodeArray);
    return packet;
    }
    catch (e) {
      print("Exception occured while BuildExchangeMessage :" + e.getMessage());
      return packet;
    }
  }

   static Packet BuildQuote22(ReadBuffer br,int exchange) {
    QuotePacket packet = new QuotePacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      packet.bestBuyPrice = br.getInt32();
      packet.bestBuyQty = br.getInt32();
      packet.bestSellPrice = br.getInt32();
      packet.bestSellQty = br.getInt32();
      if (exchange == Configuration.MCX)
      {
        packet.totalBuyD = br.getFloat64();
        packet.totalSellD = br.getFloat64();
      }
      else
      {
        packet.totalBuy = br.getInt32();
        packet.totalSell = br.getInt32();
      }

    QuotePacket22 packet22 = new QuotePacket22(packet);
    return packet22;
    }
    catch (e) {
      print("Exception occured while BuildQuote22 :" + e.getMessage());
      return packet;
    }
  }

   static Packet BuildQuote23(ReadBuffer br) {
    QuotePacket packet = new QuotePacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      packet.lastTradedPrice = br.getInt32();
      packet.closePrice = br.getInt32();
      packet.totalTradedQty = br.getInt32();
      packet.highPrice = br.getInt32();
      packet.lowPrice = br.getInt32();
      packet.openPrice = br.getInt32();
      packet.weightedAveragePrice = br.getInt32();
      packet.lowerCircuit = br.getInt32();
      packet.upperCircuit = br.getInt32();
      packet.timestamp = br.getInt64();
      packet.lastTradedQty = br.getInt32();
      int closePriceIndicator = br.getUint8();
      if (closePriceIndicator == 1)
      {
        packet.currentClosePrice = br.getInt32();
      }

    QuotePacket23 packet23 = new QuotePacket23(packet);
    return packet23;
    }
    catch (e) {
      print("Exception occured while BuildQuote23 :" + e.getMessage());
      return packet;
    }
  }

   static Packet BuildQuote27(ReadBuffer br) {
    QuotePacket packet = new QuotePacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      packet.lastTradedPrice = br.getInt32();
      packet.closePrice = br.getInt32();
      packet.totalTradedQty = br.getInt32();
      packet.highPrice = br.getInt32();
      packet.lowPrice = br.getInt32();
      packet.openPrice = br.getInt32();
      packet.weightedAveragePrice = br.getInt32();
      packet.timestamp = br.getInt64();
      packet.lastTradedQty = br.getInt32();
      int closePriceIndicator = br.getUint8();
      if (closePriceIndicator == 1)
      {
        packet.currentClosePrice = br.getInt32();
      }

    QuotePacket27 packet27 = new QuotePacket27(packet);
    return packet27;
    }
    catch (e) {
      print("Exception occured while BuildQuote27 :" + e.getMessage());
      return packet;
    }
  }

   static Packet BuildQuote35(ReadBuffer br, bool dprAvailable, int exchange) {
    Packet packet35;
    QuotePacket packet = new QuotePacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      packet.lastTradedPrice = br.getInt32();
      packet.closePrice = br.getInt32();
      packet.totalTradedQty = br.getInt32();
      packet.highPrice = br.getInt32();
      packet.lowPrice = br.getInt32();
      packet.openPrice = br.getInt32();
      packet.weightedAveragePrice = br.getInt32();
      packet.bestBuyPrice = br.getInt32();
      packet.bestBuyQty = br.getInt32();
      packet.bestSellPrice = br.getInt32();
      packet.bestSellQty = br.getInt32();

      if (exchange == Configuration.MCX )
      {
        packet.totalBuyD = br.getFloat64();
        packet.totalSellD = br.getFloat64();
      }
      else
      {
        packet.totalBuy = br.getInt32();
        packet.totalSell = br.getInt32();
      }

      if (dprAvailable) // if false , don;t read dpr
          {
        packet.lowerCircuit = br.getInt32();
        packet.upperCircuit = br.getInt32();
      }
      packet.timestamp = br.getInt64();
      packet.lastTradedQty = br.getInt32();
      int closePriceIndicator = br.getUint8();
      if (closePriceIndicator == 1) // if 1 then read current close
          {
        packet.currentClosePrice = br.getInt32();
      }

  if (dprAvailable)
  {
    packet35 = new QuotePacket35(packet);
  }
  else
  {
    packet35 = new QuotePacket39(packet);
  }
  return packet35;
}

    catch (e) {
      print("Exception occured while BuildQuote35 :" + e.getMessage());
      return packet;
    }
  }

   static Packet BuildQuote34(ReadBuffer br, bool dprAvailable) {
    Packet packet34;
    QuotePacket packet = new QuotePacket();
try
{
  br.getUint8();
  int sLength = br.getUint8();
  Uint8List scriptCodeArray=br.getUint8List(sLength);
  packet.scripCode= utf8.decode(scriptCodeArray);
  packet.lastTradedPrice = br.getInt32();
  packet.closePrice = br.getInt32();
  packet.totalTradedQty = br.getInt32();
  packet.highPrice = br.getInt32();
  packet.lowPrice = br.getInt32();
  packet.openPrice = br.getInt32();
  packet.weightedAveragePrice = br.getInt32();
  packet.bestBuyPrice = br.getInt32();
  packet.bestBuyQty = br.getInt32();
  packet.bestSellPrice = br.getInt32();
  packet.bestSellQty = br.getInt32();
  if (dprAvailable) // if false , don;t read dpr
      {
    packet.lowerCircuit = br.getInt32();
    packet.upperCircuit = br.getInt32();
  }
  packet.timestamp = br.getInt64();
  packet.lastTradedQty = br.getInt32();
  int closePriceIndicator = br.getUint8();
  if (closePriceIndicator == 1)
  {
    packet.currentClosePrice = br.getInt32();
  }

    if(dprAvailable)
    {
      packet34 = new QuotePacket34(packet);
    }
    else
    {
      packet34 = new QuotePacket38(packet);
    }
    return packet34;
}
catch (e) {
  print("Exception occured while BuildQuote34 :" + e.getMessage());
  return packet;
}
  }

   static Packet BuildQuote33(ReadBuffer br, bool dprAvailable) {
    Packet packet33;
    QuotePacket packet = new QuotePacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      packet.lastTradedPrice = br.getInt32();
      packet.closePrice = br.getInt32();
      packet.totalTradedQty = br.getInt32();
      packet.highPrice = br.getInt32();
      packet.lowPrice = br.getInt32();
      packet.openPrice = br.getInt32();
      packet.weightedAveragePrice = br.getInt32();
      packet.totalBuy = br.getInt32();
      packet.totalSell = br.getInt32();
      if (dprAvailable) // if false , don;t read dpr
          {
        packet.lowerCircuit = br.getInt32();
        packet.upperCircuit = br.getInt32();
      }
      packet.timestamp = br.getInt64();
      packet.lastTradedQty = br.getInt32();
      int closePriceIndicator = br.getUint8();
      if (closePriceIndicator == 1)
      {
        packet.currentClosePrice = br.getInt32();
      }

    if(dprAvailable)
    {
      packet33 = new QuotePacket33(packet);
    }
    else
    {
      packet33 = new QuotePacket37(packet);
    }
    return packet33;
    }
    catch (e) {
      print("Exception occured while BuildQuote33 :" + e.getMessage());
      return packet;
    }
  }

   static Packet BuildQuote28(ReadBuffer br) {
    CommodityPacket packet = new CommodityPacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      packet.lastTradedPrice = br.getInt32();
      packet.closePrice = br.getInt32();
      packet.totalTradedQty = br.getInt32();
      packet.highPrice = br.getInt32();
      packet.lowPrice = br.getInt32();
      packet.openPrice = br.getInt32();
      packet.weightedAveragePrice = br.getInt32();
      packet.openInterest = br.getInt32();
      packet.timestamp = br.getInt64();
    CommodityPacket28 packet28 = new CommodityPacket28(packet);
    return packet28;
    }
    catch (e) {
      print("Exception occured while BuildQuote28 :" + e.getMessage());
      return packet;
    }
  }

   static Packet BuildQuote32(ReadBuffer br) {
    QuotePacket packet = new QuotePacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      packet.bestBuyPrice = br.getInt32();
      packet.bestBuyQty = br.getInt32();
      packet.bestSellPrice = br.getInt32();
      packet.bestSellQty = br.getInt32();
    QuotePacket32 packet32 = new QuotePacket32(packet);
    return packet32;
    }
    catch (e) {
      print("Exception occured while BuildQuote32 :" + e.getMessage());
      return packet;
    }
  }

   static Packet BuildQuote41(ReadBuffer br, int exchange) {
    QuotePacket packet = new QuotePacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      if (exchange == Configuration.MCX)
      {
        packet.totalBuyD = br.getFloat64();
        packet.totalSellD = br.getFloat64();
      }
      else
      {
        packet.totalBuy = br.getInt32();
        packet.totalSell = br.getInt32();
      }

    QuotePacket41 packet41 = new QuotePacket41(packet);
    return packet41;
    }
    catch (e) {
      print("Exception occured while BuildQuote41 :" + e.getMessage());
      return packet;
    }
  }

   static Packet BuildQuote42(ReadBuffer br) {
    QuotePacket packet = new QuotePacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCode=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCode);
      packet.lowerCircuit = br.getInt32();
      packet.upperCircuit = br.getInt32();
      packet.weekHigh52 = br.getInt32();
      packet.weekLow52 = br.getInt32();

    QuotePacket42 packet42 = new QuotePacket42(packet);
    return packet42;
    }
    catch (e) {
      print("Exception occured while BuildQuote42 :" + e.getMessage());
      return packet;
    }
  }

   static Packet BuildQuote29(ReadBuffer br) {
    CommodityPacket packet = new CommodityPacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      packet.bestBuyPrice = br.getInt32();
      packet.bestBuyQty = br.getInt32();
      packet.bestSellPrice = br.getInt32();
      packet.bestSellQty = br.getInt32();
      packet.totalBuy = br.getFloat64();
      packet.totalSell = br.getFloat64();

    CommodityPacket29 packet29 = new CommodityPacket29(packet);
    return packet29;
    }
    catch (e) {
      print("Exception occured while BuildQuote29 :" + e.getMessage());
      return packet;
    }
  }

   static Packet BuildSpread(ReadBuffer br) {
    String scripCode = "";
    SpreadPacket packet = new SpreadPacket();
    try
    {
      br.getUint8();
      int sLength = br.getUint8();
      Uint8List scriptCodeArray=br.getUint8List(sLength);
      packet.scripCode= utf8.decode(scriptCodeArray);
      int scripCodeLength= scripCode.length;
      int scripCodeLengthTot = (scripCodeLength / 2).round();
      packet.token1 = scripCode.substring(0, scripCodeLengthTot);
      packet.token2 = scripCode.substring(scripCodeLengthTot, scripCodeLengthTot);
      packet.totalBuy = br.getUint16();
      packet.totalSell = br.getUint16();
      packet.tradedVolume = br.getInt32();
      packet.totalTradedValue = br.getFloat64();//Math.Round(br.ReadDouble(),2);
      packet.totalBuyVolume = br.getFloat64();
      packet.totalSellVolume = br.getFloat64();
      packet.openPriceDifference = br.getInt32();
      packet.highPriceDifference = br.getInt32();
      packet.lowPriceDifference = br.getInt32();
      packet.lastTradedPriceDifference = br.getInt32();
      packet.bestBuyPrice = br.getInt32();
      packet.bestBuyQty = br.getInt32();
      packet.bestSellPrice = br.getInt32();
      packet.bestSellQty = br.getInt32();
      packet.timestamp = br.getInt64();

    return packet;
    }
    catch (e) {
      print("Exception occured while BuildSpread :" + e.getMessage());
      return packet;
    }
  }

   static Packet BuildReports(ReadBuffer br, int reportType) {
    ReportsPacket packet = new ReportsPacket();
    packet.ReportType = reportType;
    br.getUint16();
    int sLength = br.getUint8();
    Uint8List scriptCodeArray=br.getUint8List(sLength);
    packet.GroupCode= utf8.decode(scriptCodeArray);
    int noOfRecords = br.getUint8();
    List<Records> records = new List<Records>();
    for (int i = 0; i < noOfRecords; i++)
    {
      String scripCode = "";
      Records record = new Records();
      int sLength = br.getUint8(); // read the scrip code length
      Uint8List sBuffer = br.getUint8List(sLength);
      scripCode = utf8.decode(sBuffer);
      record.ScripCode = scripCode;
      record.LastTradedPrice = br.getInt32();
      record.ClosePrice = br.getInt32();
      record.WeightedAveragePrice = br.getInt32();
      record.TotalTradedQty = br.getInt32();
      records.add(record);
    }
    packet.Records = records;

    return packet;
  }

   static List  buildForAddScrip(int exchange, String scripCode) {
     int addScript = Configuration.ADDSCRIP;
     var scriptCode = Configuration.SCRIPT_CODE;
     var addScriptLength = scriptCode.length;
     int totalLength = 4 + 1 + addScriptLength;
     var exchangeCode = Configuration.EXCHANGE_CODE;
     List scriptCodeList = scriptCode.codeUnits;
     List addScriptList = new List();
     var addScriptMsg = '255, $totalLength, $addScript, 0, 1, $exchangeCode, $addScriptLength, $scriptCodeList';
     var removeOpenBraceAddScriptMsg = addScriptMsg.replaceAll((r'['), '');
     var removingClosedBraceAddScriptMsg = removeOpenBraceAddScriptMsg
         .replaceAll((r']'), '');
     var finalAddScriptData = [];
     var obj = removingClosedBraceAddScriptMsg.split(',').toList();
     var itt = obj.iterator;
     while (itt.moveNext()) {
       finalAddScriptData.add(int.parse(itt.current));
     }
     addScriptList.add(finalAddScriptData);
     return addScriptList[0];
   }

   static List  buildForAddDerivativeChain(int exchange, String scripCode) {
     int addMdScript=Configuration.ADDDERIVATIVECHAIN;
     var mdScriptCode=Configuration.DERIVATIVE_SCRIPT_CODE;
     var addMdScriptLength=mdScriptCode.length;
     int mdTotalLength = 4 + 1 + addMdScriptLength;
     var mdExchangeCode=Configuration.DERIVATIVE_EXCHANGE_CODE;
     List mdScriptCodeList=mdScriptCode.codeUnits;
     List addMsScriptList=new List();
     var addScriptMsg='255, $mdTotalLength, $addMdScript, 0, 1, $mdExchangeCode, $addMdScriptLength, $mdScriptCodeList';
     var removeOpenBraceAddScriptMsg=  addScriptMsg.replaceAll((r'['), '');
     var removeClosedBraceAddScriptMsg=removeOpenBraceAddScriptMsg.replaceAll((r']'), '');
     var finalAddMDScriptData =[];
     var sampleObj = removeClosedBraceAddScriptMsg.split(',').toList();
     var itt = sampleObj.iterator;
     while (itt.moveNext()) {
       finalAddMDScriptData.add(int.parse(itt.current));
     }
     addMsScriptList.add(finalAddMDScriptData);
     return addMsScriptList[0];
   }

   static List  buildForAddOptionChain(int exchange, String scripCode) {
     int addMdScript=Configuration.ADDOPTIONCHAIN;
     var mdScriptCode=Configuration.OPTIONCHAIN_SCRIPT_CODE;
     var addMdScriptLength=mdScriptCode.length;
     int mdTotalLength = 4 + 1 + addMdScriptLength;
     var mdExchangeCode=Configuration.OPTIONCHAIN_EXCHANGE_CODE;
     List mdScriptCodeList=mdScriptCode.codeUnits;
     List addMsScriptList=new List();
     var addScriptMsg='255, $mdTotalLength, $addMdScript, 0, 1, $mdExchangeCode, $addMdScriptLength, $mdScriptCodeList';
     var removeOpenBraceAddScriptMsg=  addScriptMsg.replaceAll((r'['), '');
     var removeClosedBraceAddScriptMsg=removeOpenBraceAddScriptMsg.replaceAll((r']'), '');
     var finalAddMDScriptData =[];
     var sampleObj = removeClosedBraceAddScriptMsg.split(',').toList();
     var itt = sampleObj.iterator;
     while (itt.moveNext()) {
       finalAddMDScriptData.add(int.parse(itt.current));
     }
     addMsScriptList.add(finalAddMDScriptData);
     return addMsScriptList[0];
   }

   static List  buildForAddSpotScript(int exchange, String scripCode) {
     int addMdScript=Configuration.ADDSCRIP;
     var mdScriptCode=Configuration.SPOT_SCRIPT_CODE;
     var addMdScriptLength=mdScriptCode.length;
     int mdTotalLength = 4 + 1 + addMdScriptLength;
     var mdExchangeCode=Configuration.SPOT_EXCHANGE_CODE;
     List mdScriptCodeList=mdScriptCode.codeUnits;
     List addMsScriptList=new List();
     var addScriptMsg='255, $mdTotalLength, $addMdScript, 0, 1, $mdExchangeCode, $addMdScriptLength, $mdScriptCodeList';
     var removeOpenBraceAddScriptMsg=  addScriptMsg.replaceAll((r'['), '');
     var removeClosedBraceAddScriptMsg=removeOpenBraceAddScriptMsg.replaceAll((r']'), '');
     var finalAddMDScriptData =[];
     var sampleObj = removeClosedBraceAddScriptMsg.split(',').toList();
     var itt = sampleObj.iterator;
     while (itt.moveNext()) {
       finalAddMDScriptData.add(int.parse(itt.current));
     }
     addMsScriptList.add(finalAddMDScriptData);
     return addMsScriptList[0];
   }

   static List  buildForAddFutureChain(int exchange, String scripCode) {
     int addMdScript=Configuration.ADDFUTURECHAIN;
     var mdScriptCode=Configuration.FUTURECHAIN_SCRIPT_CODE;
     var addMdScriptLength=mdScriptCode.length;
     int mdTotalLength = 4 + 1 + addMdScriptLength;
     var mdExchangeCode=Configuration.FUTURECHAIN_EXCHANGE_CODE;
     List mdScriptCodeList=mdScriptCode.codeUnits;
     List addMsScriptList=new List();
     var addScriptMsg='255, $mdTotalLength, $addMdScript, 0, 1, $mdExchangeCode, $addMdScriptLength, $mdScriptCodeList';
     var removeOpenBraceAddScriptMsg=  addScriptMsg.replaceAll((r'['), '');
     var removeClosedBraceAddScriptMsg=removeOpenBraceAddScriptMsg.replaceAll((r']'), '');
     var finalAddMDScriptData =[];
     var sampleObj = removeClosedBraceAddScriptMsg.split(',').toList();
     var itt = sampleObj.iterator;
     while (itt.moveNext()) {
       finalAddMDScriptData.add(int.parse(itt.current));
     }
     addMsScriptList.add(finalAddMDScriptData);
     return addMsScriptList[0];
   }

   static List  buildForAddMarketDepth(int exchange, String scripCode) {
     int addMdScript = Configuration.ADDMDPETH;
     var mdScriptCode = Configuration.MDSCRIPT_CODE;
     var addMdScriptLength = mdScriptCode.length;
     int mdTotalLength = 4 + 1 + addMdScriptLength;
     var mdExchangeCode = Configuration.MDEXCHANGE_CODE;
     List mdScriptCodeList = mdScriptCode.codeUnits;
     List addMsScriptList = new List();
     var addScriptMsg = '255, $mdTotalLength, $addMdScript, 0, 1, $mdExchangeCode, $addMdScriptLength, $mdScriptCodeList';
     var removeOpenBraceAddScriptMsg = addScriptMsg.replaceAll((r'['), '');
     var removeClosedBraceAddScriptMsg = removeOpenBraceAddScriptMsg
         .replaceAll((r']'), '');
     var finalAddMDScriptData = [];
     var sampleObj = removeClosedBraceAddScriptMsg.split(',').toList();
     var itt = sampleObj.iterator;
     while (itt.moveNext()) {
       finalAddMDScriptData.add(int.parse(itt.current));
     }
     addMsScriptList.add(finalAddMDScriptData);
     return addMsScriptList[0];
   }

   static List buildForDeleteScrip(int exchange, String scripCode) {
     int addMdScript=Configuration.DELETESCRIP;
     var mdScriptCode=Configuration.DELETE_SCRIPT_CODE;
     var addMdScriptLength=mdScriptCode.length;
     int mdTotalLength = 4 + 1 + addMdScriptLength;
     var mdExchangeCode=Configuration.DELETE_EXCHANGE_CODE;
     List mdScriptCodeList=mdScriptCode.codeUnits;
     List addMsScriptList=new List();
     var addScriptMsg='255, $mdTotalLength, $addMdScript, 0, 1, $mdExchangeCode, $addMdScriptLength, $mdScriptCodeList';
     var removeOpenBraceAddScriptMsg=  addScriptMsg.replaceAll((r'['), '');
     var removeClosedBraceAddScriptMsg=removeOpenBraceAddScriptMsg.replaceAll((r']'), '');
     var finalAddMDScriptData =[];
     var sampleObj = removeClosedBraceAddScriptMsg.split(',').toList();
     var itt = sampleObj.iterator;
     while (itt.moveNext()) {
       finalAddMDScriptData.add(int.parse(itt.current));
     }
     addMsScriptList.add(finalAddMDScriptData);
     return addMsScriptList[0];
   }

   static List buildForDeleteDerivativeChain(int exchange, String scripCode) {
     int addMdScript=Configuration.DELETEDERIVATIVECHAIN;
     var mdScriptCode=Configuration.DELETEDERIVATIVE_SCRIPT_CODE;
     var addMdScriptLength=mdScriptCode.length;
     int mdTotalLength = 4 + 1 + addMdScriptLength;
     var mdExchangeCode=Configuration.DELETEDERIVATIVE_EXCHANGE_CODE;
     List mdScriptCodeList=mdScriptCode.codeUnits;
     List addMsScriptList=new List();
     var addScriptMsg='255, $mdTotalLength, $addMdScript, 0, 1, $mdExchangeCode, $addMdScriptLength, $mdScriptCodeList';
     var removeOpenBraceAddScriptMsg=  addScriptMsg.replaceAll((r'['), '');
     var removeClosedBraceAddScriptMsg=removeOpenBraceAddScriptMsg.replaceAll((r']'), '');
     var finalAddMDScriptData =[];
     var sampleObj = removeClosedBraceAddScriptMsg.split(',').toList();
     var itt = sampleObj.iterator;
     while (itt.moveNext()) {
       finalAddMDScriptData.add(int.parse(itt.current));
     }
     addMsScriptList.add(finalAddMDScriptData);
     return addMsScriptList[0];
   }

   static List buildForDeleteFutureChain(int exchange, String scripCode) {
     int addMdScript=Configuration.DELETEFUTURECHAIN;
     var mdScriptCode=Configuration.DELETEFUTURE_SCRIPT_CODE;
     var addMdScriptLength=mdScriptCode.length;
     int mdTotalLength = 4 + 1 + addMdScriptLength;
     var mdExchangeCode=Configuration.DELETEFUTURE_EXCHANGE_CODE;
     List mdScriptCodeList=mdScriptCode.codeUnits;
     List addMsScriptList=new List();
     var addScriptMsg='255, $mdTotalLength, $addMdScript, 0, 1, $mdExchangeCode, $addMdScriptLength, $mdScriptCodeList';
     var removeOpenBraceAddScriptMsg=  addScriptMsg.replaceAll((r'['), '');
     var removeClosedBraceAddScriptMsg=removeOpenBraceAddScriptMsg.replaceAll((r']'), '');
     var finalAddMDScriptData =[];
     var sampleObj = removeClosedBraceAddScriptMsg.split(',').toList();
     var itt = sampleObj.iterator;
     while (itt.moveNext()) {
       finalAddMDScriptData.add(int.parse(itt.current));
     }
     addMsScriptList.add(finalAddMDScriptData);
     return addMsScriptList[0];
   }

   static List buildForDeleteOptionChain(int exchange, String scripCode) {
     int addMdScript=Configuration.DELETEOPTIONCHAIN;
     var mdScriptCode=Configuration.DELETEOPTION_SCRIPT_CODE;
     var addMdScriptLength=mdScriptCode.length;
     int mdTotalLength = 4 + 1 + addMdScriptLength;
     var mdExchangeCode=Configuration.DELETEOPTION_EXCHANGE_CODE;
     List mdScriptCodeList=mdScriptCode.codeUnits;
     List addMsScriptList=new List();
     var addScriptMsg='255, $mdTotalLength, $addMdScript, 0, 1, $mdExchangeCode, $addMdScriptLength, $mdScriptCodeList';
     var removeOpenBraceAddScriptMsg=  addScriptMsg.replaceAll((r'['), '');
     var removeClosedBraceAddScriptMsg=removeOpenBraceAddScriptMsg.replaceAll((r']'), '');
     var finalAddMDScriptData =[];
     var sampleObj = removeClosedBraceAddScriptMsg.split(',').toList();
     var itt = sampleObj.iterator;
     while (itt.moveNext()) {
       finalAddMDScriptData.add(int.parse(itt.current));
     }
     addMsScriptList.add(finalAddMDScriptData);
     return addMsScriptList[0];
   }

   static List buildForDeleteMarketDepth(int exchange, String scripCode) {
     int addMdScript=Configuration.DELETEMDEPTH;
     var mdScriptCode=Configuration.DELETEMD_SCRIPT_CODE;
     var addMdScriptLength=mdScriptCode.length;
     int mdTotalLength = 4 + 1 + addMdScriptLength;
     var mdExchangeCode=Configuration.DELETEMD_EXCHANGE_CODE;
     List mdScriptCodeList=mdScriptCode.codeUnits;
     List addMsScriptList=new List();
     var addScriptMsg='255, $mdTotalLength, $addMdScript, 0, 1, $mdExchangeCode, $addMdScriptLength, $mdScriptCodeList';
     var removeOpenBraceAddScriptMsg=  addScriptMsg.replaceAll((r'['), '');
     var removeClosedBraceAddScriptMsg=removeOpenBraceAddScriptMsg.replaceAll((r']'), '');
     var finalAddMDScriptData =[];
     var sampleObj = removeClosedBraceAddScriptMsg.split(',').toList();
     var itt = sampleObj.iterator;
     while (itt.moveNext()) {
       finalAddMDScriptData.add(int.parse(itt.current));
     }
     addMsScriptList.add(finalAddMDScriptData);
     return addMsScriptList[0];
   }

   static List buildForSpotScript(int exchange, String scripCode) {
     int addMdScript=Configuration.DELETESCRIP;
     var mdScriptCode=Configuration.DELETESPOT_SCRIPT_CODE;
     var addMdScriptLength=mdScriptCode.length;
     int mdTotalLength = 4 + 1 + addMdScriptLength;
     var mdExchangeCode=Configuration.DELETESPOT_EXCHANGE_CODE;
     List mdScriptCodeList=mdScriptCode.codeUnits;
     List addMsScriptList=new List();
     var addScriptMsg='255, $mdTotalLength, $addMdScript, 0, 1, $mdExchangeCode, $addMdScriptLength, $mdScriptCodeList';
     var removeOpenBraceAddScriptMsg=  addScriptMsg.replaceAll((r'['), '');
     var removeClosedBraceAddScriptMsg=removeOpenBraceAddScriptMsg.replaceAll((r']'), '');
     var finalAddMDScriptData =[];
     var sampleObj = removeClosedBraceAddScriptMsg.split(',').toList();
     var itt = sampleObj.iterator;
     while (itt.moveNext()) {
       finalAddMDScriptData.add(int.parse(itt.current));
     }
     addMsScriptList.add(finalAddMDScriptData);
     return addMsScriptList[0];
   }
}