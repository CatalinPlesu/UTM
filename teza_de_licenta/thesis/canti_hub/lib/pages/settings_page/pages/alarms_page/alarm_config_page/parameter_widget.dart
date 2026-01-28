import 'package:canti_hub/database/custom_types.dart';
import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParameterWidget extends StatefulWidget {
  final AlarmsParameterTableData parameterData;

  const ParameterWidget({super.key, required this.parameterData});

  @override
  _ParameterWidgetState createState() => _ParameterWidgetState();
}

class _ParameterWidgetState extends State<ParameterWidget> {
  int _configurationValue = 0;
  SfRangeValues _sliderValues = const SfRangeValues(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    // Initialize configuration value and slider values based on your data
    _configurationValue = widget.parameterData.triggerType.index;
    _sliderValues = SfRangeValues(
        (widget.parameterData.lowerValue ?? 0).toDouble(),
        (widget.parameterData.upperValue ?? 0).toDouble());
  }

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);
    Color activeTrackColor;
    Color inactiveTrackColor;
    var parameterData = widget.parameterData;
    var databaseR = context.read<DatabaseProvider>();
    var databaseW = context.watch<DatabaseProvider>();
    var parameter = databaseW.parameters.firstWhere(
        (param) => param.index == parameterData.parameterId,
        orElse: () => const ParametersTableData(
            index: -1,
            name: 'error',
            recurrence: 0,
            normal: 0,
            max: 0,
            min: 0,
            units: ' '));

    switch (parameterData.triggerType) {
      case TriggerType.disabled: // Disable
        activeTrackColor = Theme.of(context).colorScheme.inversePrimary;
        inactiveTrackColor = Theme.of(context).colorScheme.inversePrimary;
        break;
      case TriggerType.inner: // Inside
        activeTrackColor = Theme.of(context).colorScheme.primary;
        inactiveTrackColor = Theme.of(context).colorScheme.inversePrimary;
        break;
      case TriggerType.outer: // Outside
        activeTrackColor = Theme.of(context).colorScheme.inversePrimary;
        inactiveTrackColor = Theme.of(context).colorScheme.primary;
        break;
      default:
        activeTrackColor = Theme.of(context).colorScheme.inversePrimary;
        inactiveTrackColor = Theme.of(context).colorScheme.primary;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localisation!
                .parameter(parameter.name), // Replace with your parameter name
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Text(
            "${localisation.interval_type}:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Radio(
                value: 0,
                groupValue: _configurationValue,
                onChanged: (value) {
                  setState(() {
                    _configurationValue = value as int;
                    databaseR.updateAlarmParameter(parameterData.copyWith(
                        triggerType: TriggerType.disabled));
                  });
                },
              ),
              Text(localisation.disable),
              Radio(
                value: 1,
                groupValue: _configurationValue,
                onChanged: (value) {
                  setState(() {
                    _configurationValue = value as int;
                    databaseR.updateAlarmParameter(
                        parameterData.copyWith(triggerType: TriggerType.inner));
                  });
                },
              ),
              Text(localisation.inside),
              Radio(
                value: 2,
                groupValue: _configurationValue,
                onChanged: (value) {
                  setState(() {
                    _configurationValue = value as int;
                    databaseR.updateAlarmParameter(
                        parameterData.copyWith(triggerType: TriggerType.outer));
                  });
                },
              ),
              Text(localisation.outside),
            ],
          ),
          const SizedBox(height: 16.0),
          Text(
            "${localisation.interval}:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SfRangeSliderTheme(
                data: SfRangeSliderThemeData(
                  activeTrackHeight: 8,
                  inactiveTrackHeight: 8,
                  activeTrackColor: activeTrackColor,
                  inactiveTrackColor: inactiveTrackColor,
                  tooltipBackgroundColor: Theme.of(context).colorScheme.primary,
                  thumbColor: Theme.of(context).colorScheme.background,
                  thumbRadius: 15,
                  thumbStrokeWidth: 2,
                  thumbStrokeColor: Theme.of(context).colorScheme.primary,
                ),
                child: Expanded(
                  child: SfRangeSlider(
                    min: [
                      parameter.min - 20,
                      (parameterData.lowerValue ?? 0) - 20
                    ].reduce(min),
                    max: [
                      parameter.max + 20,
                      (parameterData.upperValue ?? 0) + 20
                    ].reduce(max),
                    dragMode: SliderDragMode.both,
                    showLabels: true,
                    enableTooltip: true,
                    tooltipShape: const SfPaddleTooltipShape(),
                    values: _sliderValues,
                    startThumbIcon: _configurationValue != 0
                        ? Icon(
                            _configurationValue == 1
                                ? Icons.arrow_forward_ios
                                : Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20.0,
                          )
                        : null,
                    endThumbIcon: _configurationValue != 0
                        ? Icon(
                            _configurationValue == 1
                                ? Icons.arrow_back_ios
                                : Icons.arrow_forward_ios,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20.0,
                          )
                        : null,
                    onChanged: (SfRangeValues values) {
                      setState(() {
                        _sliderValues = values;
                      });
                    },
                    onChangeEnd: (SfRangeValues values) {
                      setState(() {
                        _sliderValues = values;
                      });
                      databaseR.updateAlarmParameter(parameterData.copyWith(
                          lowerValue: Value(values.start),
                          upperValue: Value(values.end)));
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showSliderValuesPopup(context,
                      startValue: _sliderValues.start,
                      endValue: _sliderValues.end);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  databaseR.deleteAlarmParameter(parameterData);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showSliderValuesPopup(BuildContext context,
      {double startValue = 0.0, double endValue = 0.0}) async {
    var localisation = AppLocalizations.of(context);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localisation!.slider_values),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                initialValue: startValue.toStringAsFixed(2),
                onChanged: (value) {
                  // Update startValue when input changes
                  startValue = double.tryParse(value) ?? 0.0;
                },
                decoration:
                    InputDecoration(labelText: localisation.start_value),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                initialValue: endValue.toStringAsFixed(2),
                onChanged: (value) {
                  // Update endValue when input changes
                  endValue = double.tryParse(value) ?? 0.0;
                },
                decoration: InputDecoration(labelText: localisation.end_value),
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
                context.read<DatabaseProvider>().updateAlarmParameter(
                    widget.parameterData.copyWith(
                        lowerValue: Value(startValue),
                        upperValue: Value(endValue)));

                setState(() {
                  _sliderValues = SfRangeValues(startValue, endValue);
                });

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
