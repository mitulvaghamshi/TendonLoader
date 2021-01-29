import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final VoidCallback onRead;
  final VoidCallback onWrite;
  final VoidCallback onNotify;

  const CharacteristicTile({Key key, this.characteristic, this.onRead, this.onWrite, this.onNotify}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (c, snapshot) {
        return ListTile(
          title: Text(characteristic.uuid.toString(), style: TextStyle(fontSize: 10.0)),
          subtitle: Text(snapshot.data.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              characteristic.properties.read
                  ? IconButton(icon: Icon(Icons.arrow_downward), onPressed: onRead)
                  : SizedBox(),
              characteristic.properties.write
                  ? IconButton(icon: Icon(Icons.arrow_upward), onPressed: onWrite)
                  : SizedBox(),
              characteristic.properties.notify
                  ? StreamBuilder<bool>(
                      stream: Stream.value(characteristic.isNotifying),
                      initialData: false,
                      builder: (c, snapshot) {
                        if (snapshot.data) {
                          return IconButton(icon: Icon(Icons.sync_rounded), onPressed: onNotify);
                        } else {
                          return IconButton(icon: Icon(Icons.sync_disabled_rounded), onPressed: onNotify);
                        }
                      },
                    )
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
