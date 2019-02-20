class Packet {

  String scripCode;
  int exchange ;
  var timestamp ;
  int session ;
  String getScripCode() { return scripCode; }

  void setScripCode(String scripCode) { this.scripCode = scripCode; }
  int getExchange() { return exchange== null ? 0: exchange; }
  void setExchange(int exchange) { this.exchange = exchange; }
  int getTimestamp() { return timestamp == null ? 0: timestamp; }

  void setTimestamp(var timestamp) { this.timestamp = timestamp; }
}
