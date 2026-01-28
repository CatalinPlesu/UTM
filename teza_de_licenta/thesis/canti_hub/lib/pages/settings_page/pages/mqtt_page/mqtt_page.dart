import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/pages/settings_page/pages/wifi_page/detail_widget.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:provider/provider.dart';

class MqttSettingsPage extends StatelessWidget {
  const MqttSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title: localisation!
            .settings_mqtt, // Use the provided pageTitle for the app bar title
        onLeftIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: ListView.builder(
        itemCount: context.watch<DatabaseProvider>().mqtt.length,
        itemBuilder: (context, index) {
          final mqttItem = context.watch<DatabaseProvider>().mqtt[index];

          return DetailWidget(
            title: '${mqttItem.serverUrl} - ${mqttItem.username}',
            onEditPressed: () {
              _showMqttPopup(context, mqtt: mqttItem);
            },
            onRemovePressed: () {
              context.read<DatabaseProvider>().deleteMqtt(mqttItem);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMqttPopup(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showMqttPopup(BuildContext context,
      {MqttTableData? mqtt}) async {
            var localisation = AppLocalizations.of(context);
    String serverUrl = "";
    String port = "";
    String apiKey = "";
    String username = "";
    String password = "";
    if (mqtt != null) {
      serverUrl = mqtt.serverUrl;
      port = mqtt.port.toString();
      apiKey = mqtt.apiKey ?? "";
      username = mqtt.username;
      password = mqtt.password ?? "";
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localisation!.mqtt_connection),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: serverUrl,
                  onChanged: (value) {
                    // Update serverUrl when input changes
                    serverUrl = value;
                  },
                  decoration: InputDecoration(labelText: localisation.server_url),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: port,
                  onChanged: (value) {
                    // Update port when input changes
                    port = value;
                  },
                  decoration: InputDecoration(labelText: localisation.port),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: apiKey,
                  onChanged: (value) {
                    // Update key when input changes
                    apiKey = value;
                  },
                  decoration: InputDecoration(labelText: localisation.api_key),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: username,
                  onChanged: (value) {
                    // Update username when input changes
                    username = value;
                  },
                  decoration: InputDecoration(labelText: localisation.username),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: password,
                  onChanged: (value) {
                    // Update password when input changes
                    password = value;
                  },
                  decoration: InputDecoration(labelText: localisation.password),
                ),
              ],
            ),
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
                // Perform actions with the MQTT connection settings here
                // For example: connect to MQTT broker
                // to validate the connection
                if (mqtt != null) {
                  context.read<DatabaseProvider>().updateMqtt(mqtt.copyWith(
                      serverUrl: serverUrl,
                      port: Value(int.parse(port)),
                      username: username,
                      apiKey: Value(apiKey),
                      password: Value(password)));
                } else {
                  context.read<DatabaseProvider>().insertMqtt(
                      MqttTableCompanion.insert(
                          serverUrl: serverUrl,
                          port:
                              port != "" ? Value(int.parse(port)) : Value(1883),
                          username: username,
                          apiKey: Value(apiKey),
                          password: Value(password)));
                }

                // Close the dialog
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
