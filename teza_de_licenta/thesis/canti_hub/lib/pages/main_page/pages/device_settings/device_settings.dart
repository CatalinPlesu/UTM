import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/providers/bluetooth_provider.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DeviceSettings extends StatelessWidget {
  const DeviceSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);
    var index = context.watch<DatabaseProvider>().selectedDeviceIndex;
    var device;
    if (index != null) {
      device = context.watch<DatabaseProvider>().devices[index];
    }
    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title:
            device != null ? '${device.displayNmae}' : localisation!.no_device,
        onLeftIconPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
      body: device != null
          ? ListView(
              children: [
                ExpansionTile(
                  initiallyExpanded: false,
                  title: Text(localisation!.device_information,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${localisation.device_name}: ${device.name}'),
                          Text(
                              '${localisation.device_type}: ${device.type.toString().split('.').last}'),
                          Text(
                              '${localisation.device_id}: ${device.remoteId}'),
                          Text(
                              '${localisation.software_version}: ${device.softwareVersion}'),
                          Text(
                              '${localisation.hardware_version}: ${device.hardwareVersion}'),
                          Text(
                              '${localisation.first_connection}: ${DateFormat('HH:mm:ss dd/MM/yyyy').format(device.firstConnection)}'),
                          Text(
                              '${localisation.last_online}: ${DateFormat('HH:mm:ss dd/MM/yyyy').format(device.lastOnline)}'),
                        ],
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  initiallyExpanded: false,
                  title: Text(localisation.device_alarms,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  children: List<Widget>.generate(3, (i) {
                    var deviceAlarms =
                        context.watch<DatabaseProvider>().deviceAlarms;
                    DeviceAlarmsTableData? alarm;
                    try {
                      alarm = deviceAlarms.firstWhere((a) => a.slot == i + 1);
                    } catch (e) {}
                    var alarmName = alarm != null
                        ? context
                            .watch<DatabaseProvider>()
                            .alarms
                            .firstWhere((a) => a.id == alarm!.alarmId)
                            .name
                        : null;

                    return ListTile(
                      leading: Icon(alarm != null ? Icons.delete : Icons.add),
                      title: Text(alarm != null
                          ? '${localisation.alarm_slot} ${i + 1}: ${alarmName}'
                          : '${localisation.alarm_slot} ${i + 1}'),
                      onTap: () {
                        if (alarm != null) {
                          context
                              .read<DatabaseProvider>()
                              .deleteDeviceAlarm(alarm);
                        } else {
                          _showAddAlarmDialog(context, i + 1, device.id);
                        }
                      },
                    );
                  }),
                ),
                ExpansionTile(
                  initiallyExpanded: false,
                  title: Text(localisation.apply_parameter_configuration,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  children: context
                      .watch<DatabaseProvider>()
                      .deviceParameters
                      .map<Widget>((deviceParam) {
                    var parameter = context
                        .watch<DatabaseProvider>()
                        .getParameterByIndex(deviceParam.parameterId);
                    return CheckboxListTile(
                      value: deviceParam.useUserConfig,
                      onChanged: (bool? value) {
                        // Update the useUserConfig in the database
                        context.read<DatabaseProvider>().updateDeviceParameter(
                              deviceParam.copyWith(useUserConfig: value),
                            );
                      },
                      title: Text(parameter != null
                          ? localisation.parameter(parameter.name)
                          : localisation.unknown_parameter),
                    );
                  }).toList(),
                ),
              ],
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (device != null) {
            context.read<BluetoothProvider>().stopListeningToAdapterState();
            await context.read<DatabaseProvider>().deleteDevice(device);
            Navigator.of(context).pop();
          }
        },
        icon: Icon(Icons.delete),
        label: Text(localisation!.delete_device),
      ),
    );
  }

  void _showAddAlarmDialog(BuildContext context, int slot, int deviceId) {
    var localisation = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var alarms =
            Provider.of<DatabaseProvider>(context, listen: false).alarms;
        return AlertDialog(
          title: Text(localisation!.select_an_alarm),
          content: SingleChildScrollView(
            child: ListBody(
              children: alarms
                  .map((alarm) => ListTile(
                        title: Text(alarm.name),
                        onTap: () {
                          context.read<DatabaseProvider>().insertDeviceAlarm(
                              DeviceAlarmsTableCompanion.insert(
                                  deviceId: deviceId,
                                  alarmId: alarm.id,
                                  slot: slot));
                          // Implement adding alarm functionality
                          print(localisation.selected_alarm);
                          print(alarm.toString());
                          Navigator.of(context).pop();
                        },
                      ))
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(localisation.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
