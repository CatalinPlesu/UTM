import 'package:canti_hub/database/custom_types.dart';
import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/pages/main_page/pages/add_device_page/add_mqtt_device_widgets.dart';
import 'package:canti_hub/pages/main_page/pages/add_device_page/widgets/device_name_widget.dart';
import 'package:canti_hub/pages/main_page/pages/add_device_page/widgets/device_type_widget.dart';
import 'package:canti_hub/providers/bluetooth_provider.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:canti_hub/providers/device_provider.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'add_bluetooth_device_widgets.dart';

class AddDevicePage extends StatelessWidget {
  AddDevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title: localisation!.add_device,
        onLeftIconPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 80.0),
        children: [
          DeviceNameWidget(),
          DeviceTypeWidget(),
          // Use the Bluetooth widget group
          if (context.watch<DeviceProvider>().deviceType ==
              DeviceType.bluetooth)
            AddBluetoothDeviceWidgets(context: context),
          // Use the MQTT widget group
          AddMqttDeviceWidgets(),
          // Add other common widgets for both Bluetooth and MQTT devices here
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton.extended(
              heroTag: "cancel",
              onPressed: () {
                // Do nothing for delete button tap
              },
              icon: Icon(Icons.cancel),
              label: Text(
                localisation.cancel,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          if (context.watch<DeviceProvider>().deviceType ==
              DeviceType.bluetooth)
            Spacer(),
          if (context.watch<DeviceProvider>().deviceType ==
              DeviceType.bluetooth)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  context.read<BluetoothProvider>().refresh();
                },
                child: Icon(Icons.refresh),
              ),
            ),
          SizedBox(width: 16.0),
          FloatingActionButton.extended(
            heroTag: "add parameter",
            onPressed: () async {
              context.read<BluetoothProvider>().stopListeningToScanResults();
              context.read<BluetoothProvider>().stopScaning();
              var id = await context.read<DeviceProvider>().save();
              var device = context.read<DeviceProvider>().device;
              // var id = context.read<DeviceProvider>().getId();
              context.read<BluetoothProvider>().connect(device);
              context.read<BluetoothProvider>().initConnection();
              await Future.delayed(Duration(seconds: 1));
              context.read<BluetoothProvider>().discoverServices();
              await Future.delayed(Duration(seconds: 1));
              var indexes = await context
                  .read<BluetoothProvider>()
                  .com
                  ?.readIndexCharacteristic();
              if (indexes != null) {
                indexes.forEach((index) {
                  context.read<DatabaseProvider>().insertDeviceParameter(
                      DeviceParameterTableCompanion.insert(
                          parameterId: index,
                          deviceId: id,
                          useUserConfig: Value(false)));
                });
              }

              context.read<BluetoothProvider>().disposeDevice();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: Icon(Icons.add),
            label: Text(
              localisation.add,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
