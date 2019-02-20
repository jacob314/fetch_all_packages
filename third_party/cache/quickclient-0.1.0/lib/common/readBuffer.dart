
import 'dart:typed_data';

/// Read-only buffer for reading sequentially from a [ByteData] instance.
///
/// The byte order used is [Endian.host] throughout.
class ReadBuffer {
  /// Creates a [ReadBuffer] for reading from the specified [data].
  ReadBuffer(this.data)
      : assert(data != null);

  /// The underlying data being read.
  final ByteData data;

  /// The position to read next.
  int _position = 0;

  /// Whether the buffer has data remaining to read.
  bool get hasRemaining => _position < data.lengthInBytes;

  /// Reads a Uint8 from the buffer.
  int getUint8() {
    return data.getUint8(_position++);
  }

  int getBytes(int size){
    final int value = data.getUint8(_position++);
    _position += size;
    return value;
  }

  /// Reads a Uint16 from the buffer.
  int getUint16() {
    final int value = data.getUint16(_position, Endian.host);
    _position += 2;
    return value;
  }

  /// Reads a Uint32 from the buffer.
  int getUint32() {
    final int value = data.getUint32(_position, Endian.host);
    _position += 4;
    return value;
  }
  /// Reads an Int32 from the buffer.
  int getInt8() {
    return data.getInt8(_position++);
  }

  /// Reads an Int32 from the buffer.
  int getInt16() {
    final int value = data.getInt16(_position, Endian.host);
    _position += 2;
    return value;
  }

  /// Reads an Int32 from the buffer.
  int getInt32() {
    final int value = data.getInt32(_position, Endian.host);
    _position += 4;
    return value;
  }

  /// Reads an Int64 from the buffer.
  int getInt64() {
    final int value = data.getInt64(_position, Endian.host);
    _position += 8;
    return value;
  }

  /// Reads a Float64 from the buffer.
  double getFloat64() {
   // _alignTo(8);
    final double value = data.getFloat64(_position, Endian.host);
    _position += 8;
    return value;
  }

  /// Reads the given number of Uint8s from the buffer.
  Uint8List getUint8List(int length) {
    final Uint8List list = data.buffer.asUint8List(
        data.offsetInBytes + _position, length);
    _position += length;
    return list;
  }

  /// Reads the given number of Int32s from the buffer.
  Int32List getInt32List(int length) {
    _alignTo(4);
    final Int32List list = data.buffer.asInt32List(
        data.offsetInBytes + _position, length);
    _position += 4 * length;
    return list;
  }

  /// Reads the given number of Int64s from the buffer.
  Int64List getInt64List(int length) {
    _alignTo(8);
    final Int64List list = data.buffer.asInt64List(
        data.offsetInBytes + _position, length);
    _position += 8 * length;
    return list;
  }

  /// Reads the given number of Float64s from the buffer.
  Float64List getFloat64List(int length) {
    _alignTo(8);
    final Float64List list = data.buffer.asFloat64List(
        data.offsetInBytes + _position, length);
    _position += 8 * length;
    return list;
  }

  void _alignTo(int alignment) {
    final int mod = _position % alignment;
    if (mod != 0)
      _position += alignment - mod;
  }
}