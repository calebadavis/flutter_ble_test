import 'package:flutter_ble_test/enums/command_enum.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'command/command_manager.dart';
import 'command/kaatsu_message.dart';
import 'command/start_cmd.dart';
import 'command/stop_cmd.dart';

class BLEManager {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  Map<String, BluetoothDevice> deviceMap = {};
  List<BluetoothCharacteristic> kaatsuCharacteristics = [];
  List<CommandManager> managers = [];
  Function(int)? updateDeviceCount;
  Function(KaatsuMessage) cmdReceiver;

  BLEManager({required this.cmdReceiver}) {
    flutterBlue.setLogLevel(LogLevel.error);
  }

  Future<void> scanForDevices() async {
    //flutterBlue.startScan(scanMode: ScanMode.balanced, withServices: [Guid('0000fff0-0000-1000-8000-00805f9b34fb')], timeout: Duration(seconds: 30)).catchError((error) { print("error starting scan $error"); });
    List<ScanResult> results = await flutterBlue.startScan(timeout: Duration(seconds: 5));
    for (ScanResult r in results.where((ScanResult s) => s.advertisementData.serviceUuids.contains('00001812-0000-1000-8000-00805f9b34fb'))) {

      BluetoothDevice d = r.device;
      if (deviceMap.containsValue(d)) continue;

      deviceMap[d.id.toString()] = d;

    }
    flutterBlue.stopScan();

    //print(deviceMap);
    updateDeviceCount!(deviceMap.length);

    for (BluetoothDevice d in deviceMap.values) {
      await d.connect();
      print('Connecting to Kaatsu Device: ${d.id}');
      List<BluetoothService> services = await d.discoverServices();
      services.forEach((service) async {
        for(BluetoothCharacteristic c in service.characteristics) {
          if (c.uuid.toString() == '0000fff6-0000-1000-8000-00805f9b34fb') {
            kaatsuCharacteristics.add(c);
            CommandManager cm = CommandManager(
                kaatsuCharacteristic: c,
                responseHandler: gotKaatsuMessage
            );
            managers.add(cm);
          }
        }
      });
    }
  }


  // Future<void> connectDevices() async {
  //   for (BluetoothDevice d in deviceMap.values) {
  //     await d.connect();
  //     print('Connecting to Kaatsu Device: ${d.id}');
  //     List<BluetoothService> services = await d.discoverServices();
  //     services.forEach((service) async {
  //       for(BluetoothCharacteristic c in service.characteristics) {
  //         if (c.uuid.toString() == '0000fff6-0000-1000-8000-00805f9b34fb') {
  //           kaatsuCharacteristics.add(c);
  //           CommandManager cm = CommandManager(
  //             kaatsuCharacteristic: c,
  //             responseHandler: gotKaatsuMessage
  //           );
  //           managers.add(cm);
  //
  //         }
  //       }
  //     });
  //   }
  // }

  void send(KaatsuMessage msg) {
    for (CommandManager cm in managers) {
      cm.sendCmd(msg);
    }
  }

  sendStartCommand() {
    managers.forEach((element) async {
      element.sendCmd(
        StartCmd.outbound(pressure: 100, duration: 10)
      );
    });
  }

  sendStopCommand() {
    managers.forEach((element) async {
      element.sendCmd(
        StopCmd.outbound()
      );
    });
  }

  void gotKaatsuMessage(KaatsuMessage msg) {
    if (msg.cmdType != CommandEnum.DEVICE_BATTERY)
      print('Received KaatsuMessage of type: ${msg.cmdType.name}');
  }

}