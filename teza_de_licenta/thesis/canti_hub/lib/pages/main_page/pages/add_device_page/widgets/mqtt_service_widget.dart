import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canti_hub/providers/device_provider.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:canti_hub/database/database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MqttServiceWidget extends StatefulWidget {
  @override
  _MqttServiceWidgetState createState() => _MqttServiceWidgetState();
}

class _MqttServiceWidgetState extends State<MqttServiceWidget> {
  MqttTableData? _selectedMqttService;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
      var localisation = AppLocalizations.of(context);
    if (context.watch<DeviceProvider>().mqtt.id != -1) {
      _selectedMqttService = context.watch<DeviceProvider>().mqtt;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: _isHovered ? Colors.blue : Colors.grey,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  '${localisation!.mqtt_service}:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<MqttTableData>(
                  value: _selectedMqttService,
                  onChanged: (MqttTableData? newValue) {
                    setState(() {
                      _selectedMqttService = newValue;
                    });
                    // Assign the MqttTableData object to the device provider
                    if (newValue != null) {
                      context.read<DeviceProvider>().mqtt = newValue;
                    }
                  },
                  items: context
                      .watch<DatabaseProvider>()
                      .mqtt
                      .map<DropdownMenuItem<MqttTableData>>(
                          (MqttTableData service) {
                    return DropdownMenuItem<MqttTableData>(
                      value: service,
                      child: Text(
                        '${service.serverUrl} - ${service.username}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
