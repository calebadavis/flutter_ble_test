import 'dart:typed_data';

import '../enums/device_error.dart';
import 'kaatsu_message.dart';

class ErrorCmd extends KaatsuMessage {

  ErrorCmd(Uint8List data): super(bytes: data) {
    int dataLen = cmdData!.length;
    if (dataLen > 0) error = DeviceErrorId.fromInt(cmdData![0] & 0xFF);
  }

  DeviceError error = DeviceError.INVALID;

}