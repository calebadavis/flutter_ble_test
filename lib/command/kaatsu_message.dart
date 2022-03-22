import 'dart:typed_data';
import 'package:crclib/catalog.dart';
import 'package:crclib/crclib.dart';
import 'package:flutter/foundation.dart';

import 'battery_cmd.dart';
import 'pressure_status_cmd.dart';
import 'state_request_cmd.dart';
import 'error_cmd.dart';
import 'start_cmd.dart';
import 'stop_cmd.dart';

import '../enums/kaatsu_exception_type.dart';
import '../enums/command_enum.dart';

import '../exception/kaatsu_exception.dart';

class KaatsuMessage {

  static const int CMD_ID_CODE = 0x55AA;

  static KaatsuMessage generateSubCommand(Uint8List bytes) {

    KaatsuMessage ret;

    if (bytes.length < 5) throw KaatsuException(
        type: KaatsuExceptionType.CMD_BAD_BLE_DATA,
        cause: 'Received update on Kaatsu BLE characterstic with only ${bytes.length} bytes, when no valid update should be shorter than 5'
    );
    CommandEnum cmd = CommandId.fromInt(bytes[3] & 0xFF);

    switch (cmd) {

      case CommandEnum.DEVICE_BATTERY:
        ret = BatteryCmd(bytes);
        break;

      case CommandEnum.QUERY_PRESSURE:
        ret = PressureStatusCmd(bytes);
        break;

      case CommandEnum.DEVICE_ERROR:
        ret = ErrorCmd(bytes);
        break;

      case CommandEnum.START:
        ret = StartCmd(bytes);
        break;

      case CommandEnum.STOP:
        ret = StopCmd(bytes);
        break;

      case CommandEnum.DEVICE_STATE:
        ret = StateRequestCmd(bytes);
        break;

      default:
        ret = KaatsuMessage(bytes: bytes);
    }

    return ret;

  }

  /*
   * Constructor for commands going out to BLE
   */
  KaatsuMessage.constructCommand({required this.cmdType, this.cmdData}) {
    this.cmdType = cmdType;
    inbound = false;
    if (cmdData == null) cmdData = Uint8List(0);
  }

  /*
   * Constructor for raw inbound data from BLE
   * Checks crc code, extracts type, and stashes the command-specific bytes
   */
  KaatsuMessage({required Uint8List bytes}) : cmdData = Uint8List(0) {

    int receivedChecksum = bytes[bytes.length - 1] & 0xFF;
    CrcValue checkSum = Crc8Dow().convert(bytes.sublist(0, bytes.length - 1));
    if (checkSum != receivedChecksum)
      throw KaatsuException(
          type: KaatsuExceptionType.CMD_INVALID_CRC,
          cause: 'Incorrect CRC value computed($checkSum) on data received from BLE: $bytes'
      );

    inbound = true;

    int idCode = ((bytes[0] & 0xFF) << 8) + (bytes[1] & 0xFF);
    if (idCode != CMD_ID_CODE)
      throw KaatsuException(
        type: KaatsuExceptionType.CMD_INVALID_ID_CODE,
        cause: 'Incorrect ID code in lead bytes from BLE ($idCode)... should always begin with: $CMD_ID_CODE'
      );

    int dataLength = (bytes[2] & 0xFF) - 1;

    cmdType = CommandId.fromInt(bytes[3] & 0xFF);

    if (dataLength > 0) {
      cmdData = Uint8List(dataLength);
      for (int idx = 0; idx < dataLength; ++idx) {
        cmdData![idx] = bytes[4+idx];
      }
    }
  }

  Uint8List toDevice()  {
    if (inbound)
      throw KaatsuException(
        type: KaatsuExceptionType.CMD_WRONG_DIRECTION,
        cause: "Attempt to send a command which was previously received"
      );

    int dataLen = cmdData!.length;
    Uint8List ret = Uint8List(5 + dataLen);
    ret[0] = 0x55;
    ret[1] = 0xAA;
    ret[2] = (1 + dataLen);
    ret[3] = cmdType.id;
    for (int idx = 0; idx < dataLen; ++idx) {
      ret[4 + idx] = cmdData![idx];
    }

    CrcValue checkSum = Crc8Dow().convert(ret.sublist(0, dataLen+4));
    ret[4 + dataLen] = checkSum.toBigInt().toInt(); // TODO: can this cause signed problems?
    // if (kDebugMode) {
    //   print(ret);
    // }
    return ret;
}
  
  bool inbound = true;
  CommandEnum cmdType = CommandEnum.UNKNOWN;
  Uint8List? cmdData; // 'encapsulated' data (no crc, no type, no command id)
}