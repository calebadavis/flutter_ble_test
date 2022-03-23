import 'dart:io';
import 'dart:isolate';

import 'package:flutter_ble_test/ble_manager.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../command/kaatsu_message.dart';
import '../command/command_manager.dart';

class MessageLoop {


  late Isolate isolate;


  Future<void> start() async {
    ReceivePort rp = ReceivePort();
    isolate = await Isolate.spawn<SendPort>(startMsgLoop, rp.sendPort);
    SendPort sp = await rp.first;
  }

}

void startMsgLoop(SendPort sp) async {
  List<KaatsuMessage> pendingRequests = [];
  BLEManager bleManager = BLEManager();
  ReceivePort rp = ReceivePort();

  sp.send(rp.sendPort);



  await bleManager.scanForDevices();


  while (true) {
    if (pendingRequests.length > 0) {
      KaatsuMessage msg = pendingRequests.removeAt(0);
      for (CommandManager cm in bleManager.managers) await cm.sendCmd(msg);
    } else sleep(Duration(milliseconds: 10));
  }
}