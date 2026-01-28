import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/pages/settings_page/pages/wifi_page/detail_widget.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:provider/provider.dart';

class WifiSettingsPage extends StatelessWidget {
  const WifiSettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    context.read<DatabaseProvider>().getAllWifi();

    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title: localisation!
            .settings_wifi, // Use the provided pageTitle for the app bar title
        onLeftIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: ListView.builder(
        itemCount: context.watch<DatabaseProvider>().wifi.length,
        itemBuilder: (context, index) {
          final wifiItem = context
              .watch<DatabaseProvider>()
              .wifi[index]; // Assuming wifi is your list of objects

          return DetailWidget(
            title: wifiItem.ssid,
            onEditPressed: () {
              _showWifiPopup(context, wifi: wifiItem);
            },
            onRemovePressed: () {
              context.read<DatabaseProvider>().deleteWifi(wifiItem);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showWifiPopup(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showWifiPopup(BuildContext context,
      {WifiTableData? wifi}) async {
    var localisation = AppLocalizations.of(context);
    String ssid = "";
    String password = "";
    if (wifi != null) {
      ssid = wifi.ssid;
      password = wifi.password;
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localisation!.wifi_connection),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: ssid,
                onChanged: (value) {
                  // Update ssid when input changes
                  ssid = value;
                },
                decoration: InputDecoration(labelText: localisation.wifi_ssid),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: password,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(labelText: localisation.password),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localisation.cancel),
            ),
            TextButton(
              onPressed: () {
                if (wifi != null) {
                  context.read<DatabaseProvider>().updateWifi(
                      wifi.copyWith(ssid: ssid, password: password));
                } else {
                  context.read<DatabaseProvider>().insertWifi(
                      WifiTableCompanion.insert(
                          ssid: ssid, password: password));
                }

                Navigator.of(context).pop();
              },
              child: Text(localisation.ok),
            ),
          ],
        );
      },
    );
  }
}
