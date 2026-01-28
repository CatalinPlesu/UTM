import 'dart:typed_data';

class ByteManipulation {
  static Endian endian = Endian.little;

  static Future<List<int>> int2Bytes(int data, int size) async {
    ByteData bytes = ByteData(size);
    switch (size) {
      case 1:
        bytes.setInt8(0, data);
        break;
      case 2:
        bytes.setInt16(0, data, endian);
        break;
      case 4:
        bytes.setInt32(0, data, endian);
        break;
      case 8:
        bytes.setInt64(0, data, endian);
        break;
      default:
        throw ArgumentError('Unsupported integer size: $size');
    }
    List<int> dataList = bytes.buffer.asUint8List();
    return dataList;
  }

  static Future<List<int>> int8Bytes(int data) async {
    return await int2Bytes(data, 1);
  }

  static Future<List<int>> int32Bytes(int data) async {
    return await int2Bytes(data, 4);
  }

  static Future<List<int>> int64Bytes(int data) async {
    return await int2Bytes(data, 8);
  }

  static Future<List<int>> float32Bytes(double data) async {
    ByteData bytes = ByteData(4);
    bytes.setFloat32(0, data, endian);
    List<int> dataList = bytes.buffer.asUint8List();
    return dataList;
  }

  static Future<int?> bytes2Int(List<int> data, int size) async {
    try {
      if (data.length < size) {
        throw FormatException('Insufficient data length');
      }
      ByteData bytes = ByteData.sublistView(Uint8List.fromList(data));
      switch (size) {
        case 1:
          return bytes.getInt8(0);
        case 2:
          return bytes.getInt16(0, endian);
        case 4:
          return bytes.getInt32(0, endian);
        case 8:
          return bytes.getInt64(0, endian);
        default:
          throw ArgumentError('Unsupported integer size: $size');
      }
    } catch (e) {
      // Handle read data error
      return null;
    }
  }

  static Future<int?> bytes2Int8(List<int> data) async {
    return await bytes2Int(data, 1);
  }

  static Future<int?> bytes2Int32(List<int> data) async {
    return await bytes2Int(data, 4);
  }

  static Future<int?> bytes2Int64(List<int> data) async {
    return await bytes2Int(data, 8);
  }

  static Future<double?> bytes2Float32(List<int> data) async {
    try {
      if (data.length < 4) {
        throw FormatException('Insufficient data length');
      }
      ByteData bytes = ByteData.sublistView(Uint8List.fromList(data));
      return bytes.getFloat32(0, endian);
    } catch (e) {
      // Handle read data error
      return null;
    }
  }
}
