import 'package:canti_hub/common/files.dart';
import 'package:canti_hub/pages/main_page/pages/device_settings/device_settings.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeviceIcon extends StatelessWidget {
  final int index;

  const DeviceIcon({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.background;
    int? selectedDeviceIndex =
        context.watch<DatabaseProvider>().selectedDeviceIndex;
    var lastOnline = null;
    if(selectedDeviceIndex != null)
    {
    lastOnline = context
        .watch<DatabaseProvider>()
        .devices[selectedDeviceIndex]
        .lastOnline;
    }

    bool online = DateTime.now().difference(lastOnline ?? DateTime.fromMillisecondsSinceEpoch(0)) < Duration(seconds: 120);

    return GestureDetector(
      onTap: () {
        context.read<DatabaseProvider>().selectedDeviceIndex = index;
        if (index == selectedDeviceIndex) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeviceSettings()),
          );
        }
      },
      child: Container(
        width: 76,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Center(
                  child: Icon(
                    Icons.settings,
                    color: backgroundColor,
                    size: 36.0,
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    if (index != selectedDeviceIndex)
                      Image.asset(
                        Files.bme680,
                        fit: BoxFit.cover,
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 12,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: online ? Colors.green : Colors.red,
                  border: Border.all(color: backgroundColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
