import 'dart:typed_data';

import 'kaatsu_message.dart';
import '../enums/command_enum.dart';

class StartCmd extends KaatsuMessage {

  StartCmd(Uint8List bytes) : super(bytes: bytes) {
    Uint8List params = cmdData!;
    int dataLen = params.length;
    if (dataLen > 0) success = (params[0] & 0xFF == 0);
  }

  StartCmd.outbound({required this.pressure, required this.duration}) :
        super.constructCommand(cmdType: CommandEnum.START, cmdData: Uint8List(9)) {

    Uint8List bytes = cmdData!;
    bytes[0] = pressure & 0xFF;
    bytes[1] = (pressure & 0xFF00) >> 8;
    bytes[2] = duration & 0xFF;
    bytes[3] = (duration & 0xFF00) >> 8;
    bytes[4] = 5; // ? release time relevant for training mode???
    bytes[5] = 0; // ?
    bytes[6] = 1; // Training mode=1, cycle mode=0
    bytes[7] = 1; // Cycle level ignored in training mode
    bytes[8] = 2; // Cycle step also ignored in training mode

  }

  int pressure = 0;
  int duration = 0;

  bool success = false;

}