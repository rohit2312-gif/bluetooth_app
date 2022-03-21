import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:strike_app/Screens/Remote.dart';
import 'dart:async';
import 'PairedDevice.dart';
import 'Discovery.dart';
class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
BluetoothState bluetoothState= BluetoothState.UNKNOWN;


String ?_device;
String ?_seconds;


Timer? _discoverableTimeoutTimer;
int _discoverableTimeoutSecondsLeft = 0;


@override
  void initState() {
  FlutterBluetoothSerial.instance.state.then((state) =>{bluetoothState=state});
    // TODO: implement initState

  print(bluetoothState);


  FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState state) {

    bluetoothState=state;
    setState(() {

    });
  });

  FlutterBluetoothSerial.instance.name.then((value)
  {
    _device=value;

  setState(() {

  });
  }
  );

  super.initState();



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('DJ Strike Bluetooth App'),
    ),
    body: Container(
        child: ListView(
            children: <Widget>[
            Divider(),
      ListTile(title: const Text('General')),
      SwitchListTile(
        title: const Text('Enable Bluetooth'),
        value: bluetoothState.isEnabled,
        onChanged: (bool value) {

          // Do the request and update with the true value then
          future() async {
            // async lambda seems to not working
            if (value)

              await FlutterBluetoothSerial.instance.requestEnable();
            else
              await FlutterBluetoothSerial.instance.requestDisable();
          }

          future().then((_) {
            setState(() {});
          });
        },
      ),
            ListTile(


              title: const Text('Bluetooth status'),
              subtitle: Text(bluetoothState.toString()),
              trailing: ElevatedButton(
                child: const Text('Settings'),
                onPressed: () {

                  FlutterBluetoothSerial.instance.openSettings();
                  setState(() {

                  });
                },
              ),
            ),
                    ListTile(
                      title: const Text('Local adapter name'),
                      subtitle: Text(_device.toString()),
                    ),
              ListTile(
                title: _discoverableTimeoutSecondsLeft == 0
                    ? const Text("Discoverable")
                    : Text(
                    "Discoverable for ${_discoverableTimeoutSecondsLeft}s"),
              //  subtitle: const Text("PsychoX-Luna\"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: _discoverableTimeoutSecondsLeft != 0,
                      onChanged: null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () async {
                        print('Discoverable requested');
                        final int timeout = (await FlutterBluetoothSerial.instance
                            .requestDiscoverable(60))!;
                        if (timeout < 0) {
                          print('Discoverable mode denied');
                        } else {
                          print(
                              'Discoverable mode acquired for $timeout seconds');
                        }
                        setState(() {
                          _discoverableTimeoutTimer?.cancel();
                          _discoverableTimeoutSecondsLeft = timeout;
                          _discoverableTimeoutTimer =
                              Timer.periodic(Duration(seconds: 1), (Timer timer) {
                                setState(() {
                                  if (_discoverableTimeoutSecondsLeft < 0) {
                                    FlutterBluetoothSerial.instance.isDiscoverable
                                        .then((isDiscoverable) {
                                      if (isDiscoverable==false) {
                                        print(
                                            "Discoverable after timeout... might be infinity timeout :F");
                                        _discoverableTimeoutSecondsLeft += 1;
                                      }
                                    });
                                    timer.cancel();
                                    _discoverableTimeoutSecondsLeft = 0;
                                  } else {
                                    _discoverableTimeoutSecondsLeft -= 1;
                                  }
                                });
                              });
                        });
                      },
                    )
                  ],
                ),
              ),

              ListTile(
                title: ElevatedButton(
                    child: const Text('Explore discovered devices'),
                    onPressed: () async {
                      final BluetoothDevice? selectedDevice =
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return DiscoveryPage();
                          },
                        ),
                      );

                      if (selectedDevice != null) {
                        print('Discovery -> selected ' + selectedDevice.address);
                      } else {
                        print('Discovery -> no device selected');
                      }
                    }),
              ),
              ListTile(
                title: ElevatedButton(
                  child: const Text('Connect to paired device to chat'),
                  onPressed: () async {
                    final BluetoothDevice? selectedDevice =
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return SelectBondedDevicePage(checkAvailability: false);
                        },
                      ),
                    );

                    if (selectedDevice != null) {
                      print('Connect -> selected ' + selectedDevice.address);
                      //Navigator
                      Navigator.of(context).push(
                          MaterialPageRoute(
                          builder: (context) {
                        return Connected(server: selectedDevice,);
                    }));
                    } else {
                      print('Connect -> no device selected');
                    }
                  },
                ),
              ),



            ]),


    ),
    );

  }
}
