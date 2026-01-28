import 'package:canti_hub/providers/bluetooth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BluetoothAdapterStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     var localisation = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () {
        context.read<BluetoothProvider>().turnOn();
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          children: [
            Icon(Icons.bluetooth),
            Text(
                '${localisation!.adapter_state}: ${context.watch<BluetoothProvider>().adapterState}'),
            Text(localisation.turon_bluetooth_on),
          ],
        ),
      ),
    );
  }
}