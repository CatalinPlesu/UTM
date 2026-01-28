import 'package:canti_hub/database/custom_types.dart';
import 'package:canti_hub/providers/device_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeviceTypeWidget extends StatefulWidget {
  @override
  _DeviceTypeWidgetState createState() => _DeviceTypeWidgetState();
}

class _DeviceTypeWidgetState extends State<DeviceTypeWidget> {
  DeviceType _selectedDeviceType = DeviceType.mqtt;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);
    _selectedDeviceType = context.watch<DeviceProvider>().deviceType;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 8.0), // Added margin to the bottom
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
                  '${localisation!.device_type}:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<DeviceType>(
                  value: _selectedDeviceType,
                  onChanged: (DeviceType? newValue) {
                    setState(() {
                      _selectedDeviceType = newValue!;
                    });
                    context.read<DeviceProvider>().deviceType = newValue!;
                  },
                  items: DeviceType.values
                      .map<DropdownMenuItem<DeviceType>>((DeviceType value) {
                    return DropdownMenuItem<DeviceType>(
                      value: value,
                      child: Text(
                        value == DeviceType.bluetooth ? localisation.bluetooth : localisation.mqtt,
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
