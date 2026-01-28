import 'package:canti_hub/common/strings.dart';
import 'package:canti_hub/database/custom_types.dart';
import 'package:canti_hub/providers/bluetooth_helpers/byte_manipulation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Communication {
  static const int recurrenceConfigCmd = 0xF1;
  static const int recurrenceResetCmd = 0xF2;
  static const int alarmCmd = 0xA0;
  static const int disableAlarmCmd = 0xB0;
  static const int deleteAlarmCmd = 0xD0;
  static const int enableAlarmCmd = 0xE0;
  static const int unixtimeCmd = 0xA0;
  static const int resetComCmd = 0xFF;

  late BluetoothCharacteristic indexCharacteristic;
  late BluetoothCharacteristic valueCharacteristic;
  late BluetoothCharacteristic configCharacteristic;

  Communication(List<BluetoothService> services) {
    String characteristicUuid;
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristicUuid = characteristic.uuid.toString();
        if (characteristicUuid == Strings.INDEX_CHARACTERISTIC_UUID) {
          indexCharacteristic = characteristic;
        } else if (characteristicUuid == Strings.CONFIG_CHARACTERISTIC_UUID) {
          configCharacteristic = characteristic;
        } else if (characteristicUuid == Strings.VALUE_CHARACTERISTIC_UUID) {
          valueCharacteristic = characteristic;
        }
      }
    }
  }

  Future<void> sendRecurrenceCommand(
      int parameterIndex, int newRecurrenceValue) async {
    var cmd = await ByteManipulation.int8Bytes(recurrenceConfigCmd);
    var index = await ByteManipulation.int32Bytes(parameterIndex);
    var recurrence = await ByteManipulation.int32Bytes(newRecurrenceValue);
    try {
      await sendConfigData([cmd, index, recurrence]);
    } catch (e) {
      // Handle write data error
    }
  }

  Future<void> sendWriteDefaultRecurrenceCommand(int parameterIndex) async {
    var cmd = await ByteManipulation.int8Bytes(recurrenceResetCmd);
    var index = await ByteManipulation.int32Bytes(parameterIndex);
    try {
      await sendConfigData([cmd, index]);
    } catch (e) {
      // Handle write data error
    }
  }

  Future<void> sendAlarmSettingCommand(int alarmSlot, int parameterIndex,
      TriggerType intervalType, double lowerLimit, double upperLimit) async {
    var cmd = await ByteManipulation.int8Bytes(alarmCmd | alarmSlot);
    var index = await ByteManipulation.int32Bytes(parameterIndex);
    var type = await ByteManipulation.int32Bytes(intervalType.index);
    var lower = await ByteManipulation.float32Bytes(lowerLimit);
    var upper = await ByteManipulation.float32Bytes(upperLimit);
    try {
      await sendConfigData([cmd, index, type, lower, upper]);
    } catch (e) {
      // Handle write data error
    }
  }

  Future<void> sendDisableAlarmCommand(int alarmSlot) async {
    var cmd = await ByteManipulation.int8Bytes(disableAlarmCmd | alarmSlot);
    try {
      await sendConfigData([cmd]);
    } catch (e) {
      // Handle write data error
    }
  }

  Future<void> sendDeleteAlarmCommand(int alarmIndex) async {
    var cmd = await ByteManipulation.int8Bytes(deleteAlarmCmd | alarmIndex);
    try {
      await sendConfigData([cmd]);
    } catch (e) {
      // Handle write data error
    }
  }

  Future<void> sendEnableAlarmCommand(int alarmIndex) async {
    var cmd = await ByteManipulation.int8Bytes(enableAlarmCmd | alarmIndex);
    try {
      await sendConfigData([cmd]);
    } catch (e) {
      // Handle write data error
    }
  }

  Future<void> sendUnixtimeCommand(int unixtime) async {
    var cmd = await ByteManipulation.int8Bytes(unixtimeCmd);
    var epoch = await ByteManipulation.int64Bytes(unixtime);
    try {
      await sendConfigData([cmd, epoch]);
    } catch (e) {
      // Handle write data error
    }
  }

  Future<int?> readUnixtimeCommand() async {
    var cmd = await ByteManipulation.int8Bytes(unixtimeCmd);
    try {
      await valueCharacteristic.write(cmd);
      List<int> data = await valueCharacteristic.read();
      return await ByteManipulation.bytes2Int64(data);
    } catch (e) {
      // Handle write data error
    }
  }

  Future<void> sendResetCommand() async {
    var cmd = await ByteManipulation.int8Bytes(resetComCmd);
    try {
      await sendConfigData([cmd]);
    } catch (e) {
      // Handle write data error
    }
  }

  Future<void> sendConfigData(List<List<int>> dataToBeSent) async {
    for (var data in dataToBeSent) {
      await configCharacteristic.write(data);
    }
  }

  Future<List<int>?> readIndexCharacteristic() async {
    var cmd = await ByteManipulation.int8Bytes(0x00); // Reset command value
    try {
      await indexCharacteristic.write(cmd);
    } catch (e) {}
    List<int> indexes = [];
    try {
      List<int> data = await indexCharacteristic.read();
      int newIndex = await ByteManipulation.bytes2Int32(data) ?? 0;
      while (!indexes.contains(newIndex)) {
        if (newIndex != 0) {
          indexes.add(newIndex);
        }
        data = await indexCharacteristic.read();
        newIndex = await ByteManipulation.bytes2Int32(data) ?? 0;
      }
    } catch (e) {
      // Handle read data error
      return null;
    }
    return indexes;
  }

  Future<double?> readParameterValue(int parameterIndex) async {
    var index = await ByteManipulation.int8Bytes(parameterIndex);
    try {
      await valueCharacteristic.write(index);
      List<int> data = await valueCharacteristic.read();
      return await ByteManipulation.bytes2Float32(data);
    } catch (e) {
      // Handle read data error
      return null;
    }
  }
}
