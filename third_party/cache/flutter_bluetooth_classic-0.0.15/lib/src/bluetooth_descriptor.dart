part of flutter_bluetooth_classic;

class BluetoothDescriptor {
  static final Guid CCCD = new Guid("00002902-0000-1000-8000-00805f9b34fb");

  final Guid uuid;
  final Guid serviceUuid; // The service that this descriptor belongs to.
  final Guid characteristicUuid; // The characteristic that this descriptor belongs to.
  List<int> value;

  BluetoothDescriptor({@required this.uuid, @required this.serviceUuid, @required this.characteristicUuid});

  BluetoothDescriptor.fromProto(protos.BluetoothDescriptor p) :
        uuid = new Guid(p.uuid),
        serviceUuid = new Guid(p.serviceUuid),
        characteristicUuid = new Guid(p.characteristicUuid),
        value = p.value;
}