import 'dart:typed_data';

import 'kaatsu_message.dart';
import '../enums/command_enum.dart';
import '../enums/device_state.dart';


class StateRequestCmd extends KaatsuMessage {
  StateRequestCmd(Uint8List bytes) : super(bytes: bytes) {
    Uint8List params = cmdData!;
    int dataLen = params.length;
    if (dataLen > 0) state = DeviceStateId.fromInt(params[0] & 0xFF);
  }

  StateRequestCmd.outbound() : super.constructCommand(cmdType: CommandEnum.QUERY_STATE);

  DeviceState state = DeviceState.INVALID;
}