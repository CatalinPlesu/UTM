import 'package:canti_hub/database/custom_types.dart';
import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/pages/settings_page/pages/alarms_page/alarm_config_page/parameter_widget.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AlarmConfigPage extends StatefulWidget {
  final AlarmsTableData alarm;
  const AlarmConfigPage({Key? key, required this.alarm}) : super(key: key);

  @override
  _AlarmConfigPageState createState() => _AlarmConfigPageState();
}

class _AlarmConfigPageState extends State<AlarmConfigPage> {
  late TextEditingController _alarmNameController;

  @override
  void initState() {
    super.initState();
    _alarmNameController = TextEditingController(text: widget.alarm.name);
  }

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    var alarmParameters = context.watch<DatabaseProvider>().alarmParameters;
    var parameters = context.watch<DatabaseProvider>().parameters;

    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title: localisation!.alarms_config,
        onLeftIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0,
            80.0), // Added bottom padding for floating buttons
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
            child: TextField(
              decoration: InputDecoration(
                labelText: localisation.alarm_name,
              ),
              controller: _alarmNameController,
              onChanged: (value) {
                context
                    .read<DatabaseProvider>()
                    .updateAlarm(widget.alarm.copyWith(name: value));
              },
            ),
          ),

          // Parameter Configuration Widgets
          Column(
            children: context
                .watch<DatabaseProvider>()
                .alarmParameters
                .map((alarmParameter) =>
                    ParameterWidget(parameterData: alarmParameter))
                .toList(),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton.extended(
              heroTag: "delete",
              onPressed: () {
                context
                    .read<DatabaseProvider>()
                    .alarmParameters
                    .map((alarmParameter) => context
                        .read<DatabaseProvider>()
                        .deleteAlarmParameter(alarmParameter))
                    .toList();

                context.read<DatabaseProvider>().deleteAlarm(widget.alarm);

                Navigator.of(context).pop();
              },
              icon: Icon(Icons.delete),
              label: Text(
                localisation.delete,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          FloatingActionButton.extended(
            heroTag: "add parameter",
            onPressed: () {
              // Handle the button press, e.g., open a dialog or navigate to another screen
              _showParameterPopup(
                context,
                alarmParameters,
                parameters,
              );
            },
            icon: Icon(Icons.add),
            label: Text(
              localisation.add_parameter,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showParameterPopup(
      BuildContext context,
      List<AlarmsParameterTableData> existingParameters,
      List<ParametersTableData> parameters) async {
    var localisation = AppLocalizations.of(context);

    String? selectedItem; // Variable to hold the selected item, now nullable

    // List of items containing only those from parameters not present in existingParameters
    List<String> items = parameters
        .where((param) => !existingParameters
            .any((existingParam) => existingParam.parameterId == param.index))
        .map((param) => param.name)
        .toList();

    // Show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localisation!.select_item),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: selectedItem,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(localisation.parameter(item)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Set the selected item when an item is changed
                  selectedItem = newValue;
                },
                decoration: InputDecoration(
                  hintText: localisation.select_item, // Placeholder text
                ),
              ),
              SizedBox(height: 16), // Spacer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // Close the dialog without selecting
                    },
                    child: Text(localisation.cancel),
                  ),
                  SizedBox(width: 8), // Spacer
                  TextButton(
                    onPressed: () {
                      // Find the parameterId corresponding to the selected item
                      ParametersTableData selectedParameter = parameters
                          .firstWhere((param) => param.name == selectedItem);
                      int parameterId = selectedParameter.index;

                      // Perform your database insertion
                      context.read<DatabaseProvider>().insertAlarmParameter(
                          AlarmsParameterTableCompanion.insert(
                              alarmId: widget.alarm.id,
                              parameterId: parameterId,
                              triggerType: TriggerType.disabled));

                      Navigator.of(context).pop();
                    },
                    child: Text(localisation.ok),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
