import 'dart:typed_data';
import '../enums/command_enum.dart';
import 'kaatsu_message.dart';

class PressureStatusCmd extends KaatsuMessage {
  
  PressureStatusCmd(Uint8List data) : super(bytes: data)  {
    int dataSize = cmdData!.length;
    pressure = (
        (cmdData!.length > 1) ?
        cmdData![0] & 0xFF + cmdData![1] & 0xFF
        : 0
    );
  }
  
  PressureStatusCmd.outbound() : super.constructCommand(cmdType: CommandEnum.QUERY_PRESSURE);

  int pressure = 0;

}