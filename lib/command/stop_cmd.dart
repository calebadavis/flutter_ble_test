import 'dart:typed_data';

import 'kaatsu_message.dart';
import '../enums/command_enum.dart';


class StopCmd extends KaatsuMessage {
  StopCmd(Uint8List bytes) : super(bytes: bytes) {
    Uint8List params = cmdData!;
    int dataLen = params.length;
    if (dataLen > 0) success = ((params[0] & 0xFF) == 0);
  }

  StopCmd.outbound() : super.constructCommand(cmdType: CommandEnum.STOP);

  bool success = false;
}