import 'package:canti_hub/providers/device_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DeviceNameWidget extends StatefulWidget {
  @override
  _DeviceNameWidgetState createState() => _DeviceNameWidgetState();
}

class _DeviceNameWidgetState extends State<DeviceNameWidget> {
  late TextEditingController _deviceNameController;

  @override
  void initState() {
    super.initState();
    _deviceNameController = TextEditingController();
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                '${localisation!.device_name}:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _deviceNameController,
                  decoration: InputDecoration(
                    hintText: localisation.enter_device_name,
                  ),
                  onChanged: (value) {
                    context.read<DeviceProvider>().name = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
