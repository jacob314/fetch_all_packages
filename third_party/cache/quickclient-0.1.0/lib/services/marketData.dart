
import 'package:quickclient/data/packet.dart';
import 'package:quickclient/services/configuration.dart';
import 'package:quickclient/services/eventDetails.dart';
import 'package:quickclient/services/handler.dart';
import 'package:quickclient/services/keyManager.dart';
import 'package:quickclient/services/mdHandler.dart';
import 'package:quickclient/services/packetBuilder.dart';
import 'package:quickclient/services/quickEvent.dart';
import 'package:quickclient/sockets/tcpConnection.dart';

class MarketData implements MDHandler,Handler{
  static MDHandler mdHandler;
  static Handler mData;
  bool isNewVersionAuthentication = false;
  QuickEvent quickEvent;
  Configuration configuration = null;
  TcpSocket tcpConnection = null;

  MarketData() {
    configuration = new Configuration();
  }

  static Handler getInstance() {
    if (mData == null) {
      mData = new MarketData();
    }
    return mData;
  }

  @override
  bool connect() {
    try {

      if (quickEvent == null) {
        throw new Exception("No event handler is set, will not initiate the connection");
      }

      if (Configuration.SERVER_ADDRESS == null) {
        throw new Exception("Blank Server Address");
      }

      if (Configuration.SERVER_PORT <= 0) {
        throw new Exception("Blank Server Port");
      }
      mdHandler = new MDHandler();
      tcpConnection = new TcpSocket(mdHandler, configuration);
      if (isNewVersionAuthentication) {
        tcpConnection.enableNewVersionAuthentication();
      }
      tcpConnection.connect();

    } catch (e)
    {
      print("No event handler is set and Blank Server Address,Port will not initiate the connection :" + e.getMessage());
      return false;
    }
    return true;
  }

  @override
  void onConnect() {
    quickEvent.onConnect();
  }

  @override
  void onDisconnect(EventDetails details) {
    disconnect();
    quickEvent.onDisconnect(details);
  }

  @override
  void onPacketArrived(Packet packet) {
    //quickEvent.onPacketArrived(packet);
    KeyManager.setData(packet);
  }

  @override
  void setEventHandler(QuickEvent qEvent) {
    this.quickEvent = qEvent;
  }

  @override
  void setAddress(String address) {
    Configuration.SERVER_ADDRESS = address;
  }

  @override
  void setPort(int port) {
    Configuration.SERVER_PORT = port;
  }

  @override
  void setUserCredentials(String username, String password) {
    Configuration.USER_NAME = username;
    Configuration.PASSWORD = password;
  }

  @override
  bool disconnect() {
    print("Calling the disconnect method :");
    if (tcpConnection != null) {
      tcpConnection.dropAndClose(EventDetails.getForcefulDisconnection());
      tcpConnection = null;
    }
    return true;
  }

  @override
  bool addScrip(int exchange, String scripCode) {
    try {
    Configuration.EXCHANGE_CODE = exchange;
    Configuration.SCRIPT_CODE = scripCode;
    //KeyManager.addScrip(exchange, scripCode);
   // List buffer;
   // buffer = PacketBuilder.buildForAddScrip(exchange, scripCode);
    } catch (e) {
      print("Exception occured while adding the scrip :" + e.getMessage());
    }
    return true;
  }
  @override
  bool addMarketDepth(int exchange, String scripCode) {
    try {
    Configuration.MDEXCHANGE_CODE = exchange;
    Configuration.MDSCRIPT_CODE = scripCode;
    } catch (e) {
      print("Exception occured while adding the scrip :" + e.getMessage());
    }
    return true;
  }

  @override
  bool addDerivativeChain(int exchange, String scripCode){
    try {
      Configuration.DERIVATIVE_EXCHANGE_CODE = exchange;
      Configuration.DERIVATIVE_SCRIPT_CODE = scripCode;
    } catch (e) {
      print("Exception occured while adding DerivativeChain scrip :" + e.getMessage());
    }
    return true;
  }

  @override
  bool addOptionChain(int exchange, String scripCode){
    try {
      Configuration.OPTIONCHAIN_EXCHANGE_CODE = exchange;
      Configuration.OPTIONCHAIN_SCRIPT_CODE = scripCode;
    } catch (e) {
      print("Exception occured while adding OptionChain scrip :" + e.getMessage());
    }
    return true;
  }

  @override
  bool addFutureChain(int exchange, String scripCode){
    try {
      Configuration.FUTURECHAIN_EXCHANGE_CODE = exchange;
      Configuration.FUTURECHAIN_SCRIPT_CODE = scripCode;
    } catch (e) {
      print("Exception occured while adding FutureChain scrip :" + e.getMessage());
    }
    return true;
  }

  @override
  bool addSpotScrip(int exchange, String scripCode){
    try {
      Configuration.SPOT_EXCHANGE_CODE = exchange;
      Configuration.SPOT_SCRIPT_CODE = scripCode;
      Configuration.spotChain=true;
    } catch (e) {
      print("Exception occured while adding Scop scrip :" + e.getMessage());
    }
    return true;
  }

  @override
  bool deleteScrip(int exchange, String scripCode) {
    try {
      Configuration.DELETE_EXCHANGE_CODE = exchange;
      Configuration.DELETE_SCRIPT_CODE = scripCode;
    } catch (e) {
      print("Exception occured while delete scrip :" + e.getMessage());
    }
    return true;
  }
  @override
  bool deleteDerivativeChain(int exchange, String scripCode) {
    try {
      Configuration.DELETEDERIVATIVE_EXCHANGE_CODE = exchange;
      Configuration.DELETEDERIVATIVE_SCRIPT_CODE = scripCode;
    } catch (e) {
      print("Exception occured while delete DerivativeChain scrip :" + e.getMessage());
    }
    return true;
  }

  @override
  bool deleteFutureChain(int exchange, String scripCode) {
    try {
      Configuration.DELETEFUTURE_EXCHANGE_CODE = exchange;
      Configuration.DELETEFUTURE_SCRIPT_CODE = scripCode;
    } catch (e) {
      print("Exception occured while delete FutureChain scrip :" + e.getMessage());
    }
    return true;
  }

  @override
  bool deleteOptionChain(int exchange, String scripCode) {
    try {
      Configuration.DELETEOPTION_EXCHANGE_CODE = exchange;
      Configuration.DELETEOPTION_SCRIPT_CODE = scripCode;
    } catch (e) {
      print("Exception occured while delete OptionChain scrip :" + e.getMessage());
    }
    return true;
  }

  @override
  bool deleteMarketDepth(int exchange, String scripCode) {
    try {
      Configuration.DELETEMD_EXCHANGE_CODE = exchange;
      Configuration.DELETEMD_SCRIPT_CODE = scripCode;
    } catch (e) {
      print("Exception occured while delete OptionChain scrip :" + e.getMessage());
    }
    return true;
  }

  @override
  bool deleteSpotScrip(int exchange, String scripCode) {
    try {
      Configuration.DELETESPOT_EXCHANGE_CODE = exchange;
      Configuration.DELETESPOT_SCRIPT_CODE = scripCode;
    } catch (e) {
      print("Exception occured while delete deleteScop scrip :" + e.getMessage());
    }
    return true;
  }

  @override
  void onError(EventDetails details) {
  //  super.onError(details);
    print("OnError");
    print(details.code);
  }
}