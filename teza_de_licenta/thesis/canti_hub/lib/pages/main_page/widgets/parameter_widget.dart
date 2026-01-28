import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParameterWidget extends StatelessWidget {
  final String parameterName;
  final ColectedDataTableData? data;
  final String unit;
  final double desiredValue;

  const ParameterWidget({
    Key? key,
    required this.parameterName,
    required this.data,
    required this.unit,
    required this.desiredValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayMode = context.watch<SettingsProvider>().displayMode;

    return displayMode == ParametersDisplayMode.list
        ? _buildListLayout(context)
        : _buildGridLayout(context);
  }

  Widget _buildListLayout(BuildContext context) {
    var localisation = AppLocalizations.of(context);
    String displayValue =
        data != null ? formatValue(data?.value ?? 0.0) : localisation!.no_data;

    return Container(
      margin: EdgeInsets.all(5.0),
      child: Container(
        padding: EdgeInsets.all(16.0), // Padding of 8
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                localisation!.parameter(parameterName),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8), // Adjust spacing as needed
            Text(
              '$displayValue $unit',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridLayout(BuildContext context) {
    var localisation = AppLocalizations.of(context);
    String displayValue =
        data != null ? formatValue(data?.value ?? 0.0) : localisation!.no_data;
    var time = data?.createdAt;
    String displayTime = time != null
        ? "${time.hour}:${time.minute < 10 ? '0' : ''}${time.minute}:${time.second < 10 ? '0' : ''}${time.second} ${time.day}/${time.month}/${time.year}"
        : localisation!.no_data;
    final displayMode = context.watch<SettingsProvider>().displayMode;

    return Container(
      margin: EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: displayValue.length,
                  child: Text(
                    '$displayValue ',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (displayMode != ParametersDisplayMode.grid_3)
                  Flexible(
                    flex: unit.length,
                    child: Text(
                      unit,
                      style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8), // Adjust spacing as needed
            Text(
              localisation!.parameter(parameterName),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              displayTime,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatValue(double value) {
    if (value > 400) {
      return value.round().toString();
    } else {
      return value.toStringAsFixed(1);
    }
  }
}
