import 'package:canti_hub/providers/device_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

class DeviceWidget extends StatelessWidget {
  final BluetoothDevice device;

  const DeviceWidget({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Implement logic here when the widget is tapped
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                  children: [
                    Text(
                      device.platformName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      device.remoteId.str,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Radio(
                  value:
                      context.watch<DeviceProvider>().device.remoteId.str ==
                          device.remoteId.str,
                  groupValue: true,
                  onChanged: (value) {
                    // Implement logic here when radio button is selected
                    context.read<DeviceProvider>().device = device;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}