import 'package:canti_hub/pages/main_page/widgets/device_icon.dart';
import 'package:canti_hub/pages/main_page/widgets/plus_icon.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DevicesList extends StatelessWidget {
  const DevicesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var devices = context.watch<DatabaseProvider>().devices;
    return Container(
      height: 68,
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: devices.length + 1, // Adjust the number of avatars as needed
        itemBuilder: (context, index) {
          // Example CircleAvatar with a dot for online/offline indicator
          if (index < devices.length) {
            return DeviceIcon(index: index);
          } else {
            return PlusIcon();
          }
        },
      ),
    );
  }
}
