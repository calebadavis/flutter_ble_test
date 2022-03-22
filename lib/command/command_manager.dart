import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../exception/kaatsu_exception.dart';
import 'kaatsu_message.dart';

class CommandManager {

  CommandManager({required this.kaatsuCharacteristic, required this.responseHandler}) {

    kaatsuCharacteristic!.setNotifyValue(true);

    kaatsuCharacteristic!.value.listen((event) {
      try {
        responseHandler(
            KaatsuMessage.generateSubCommand(Uint8List.fromList(event)));
      } on KaatsuException catch(e) {
        print('Problem when parsing data from pump device: ${e.cause}');
      }
    });

  }

  Future<void> sendCmd(KaatsuMessage cmd) async {

    await kaatsuCharacteristic!.write(cmd.toDevice());

  }

  BluetoothCharacteristic? kaatsuCharacteristic;
  Function(KaatsuMessage) responseHandler;
}