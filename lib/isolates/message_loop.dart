import 'dart:io';
import 'dart:isolate';

import 'package:flutter_ble_test/ble_manager.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../command/kaatsu_message.dart';
import '../command/command_manager.dart';

class MessageLoop {


  late Isolate isolate;
  void Function(KaatsuMessage) kaatsuMessageReceiver;
  late SendPort sp;

  MessageLoop({required this.kaatsuMessageReceiver});

  Future<void> start() async {
    ReceivePort rp = ReceivePort();
    isolate = await Isolate.spawn<SendPort>(startMsgLoop, rp.sendPort);
    sp = await rp.first;
    rp.listen ((data) {
      if (data is KaatsuMessage) kaatsuMessageReceiver(data);
    });
  }

  void sendCmd(KaatsuMessage msg) {
    sp.send(msg);
  }

}

void startMsgLoop(SendPort sp) async {
  ReceivePort rp = ReceivePort();
  sp.send(rp.sendPort);
  List<KaatsuMessage> pendingRequests = [];
  BLEManager bleManager = BLEManager(
    cmdReceiver: (KaatsuMessage msg) {
    sp.send(msg);
  });
  rp.listen ((data) async {

    if (data is KaatsuMessage) {

      pendingRequests.add(data);

    } else if (data is String) {

      switch (data) {

        case 'SCAN':
          await bleManager.scanForDevices();
          sp.send(bleManager.deviceMap.keys.toList());
          break;

        case 'AVAILABLE_DEVICES':
          sp.send(bleManager.deviceMap.keys.toList());
          break;
      }
    }
  });


  while (true) {
    if (pendingRequests.length > 0) {
      KaatsuMessage msg = pendingRequests.removeAt(0);
      for (CommandManager cm in bleManager.managers) await cm.sendCmd(msg);
    } else sleep(Duration(milliseconds: 10));
  }
}