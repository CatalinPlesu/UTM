import 'package:canti_hub/database/custom_types.dart';
import 'package:canti_hub/pages/main_page/pages/add_device_page/widgets/mqtt_service_widget.dart';
import 'package:canti_hub/providers/device_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMqttDeviceWidgets extends StatelessWidget {
  const AddMqttDeviceWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (context.watch<DeviceProvider>().deviceType == DeviceType.mqtt)
        MqttServiceWidget(),
         // if (context.watch<DeviceProvider>().deviceType == DeviceType.mqtt)
          //   MqttServiceWidget(),
          // // if (context.watch<DeviceProvider>().deviceType == DeviceType.virtual)
          // ...context
          //     .watch<DeviceProvider>()
          //     .parameters
          //     .where((parameter) =>
          //         context.watch<DeviceProvider>().deviceType ==
          //         DeviceType.mqtt)
          //     .map((parameter) => MqttParameterWidget(
          //           parameter: parameter,
          //           onCheckboxChanged: (value) {
          //             // Update checkbox value in your provider or wherever you store state
          //             context
          //                 .read<DeviceProvider>()
          //                 .parameters[parameter.index]
          //                 .checkbox = value;
          //           },
          //           onTopicChanged: (value) {
          //             // Update topic value in your provider or wherever you store state
          //             context
          //                 .read<DeviceProvider>()
          //                 .parameters[parameter.index]
          //                 .topic = value;
          //           },
          //         ))
          //     .toList(),
        // Add other MQTT device widgets here
        // You can also conditionally include widgets based on the device type
        // For example, only include MqttParameterWidget for virtual devices
      ],
    );
  }
}
