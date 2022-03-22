import 'dart:typed_data';
import 'kaatsu_message.dart';

class BatteryCmd extends KaatsuMessage {

  BatteryCmd(Uint8List data) : super(bytes: data)  {
    int dataSize = cmdData!.length;
    batteryLevel = (dataSize > 0 ? cmdData![0] & 0xFF : 0);
  }

  int batteryLevel = 0;

}