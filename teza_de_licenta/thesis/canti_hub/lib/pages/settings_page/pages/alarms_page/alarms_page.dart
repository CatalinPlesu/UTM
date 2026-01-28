import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/pages/settings_page/pages/alarms_page/alarm_config_page/alarm_config_page.dart';
import 'package:canti_hub/pages/settings_page/pages/alarms_page/detail_widget.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:provider/provider.dart';

class AlarmsPage extends StatelessWidget {
  const AlarmsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title: localisation!.alarms,
        onLeftIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: ListView.builder(
          itemCount: context.watch<DatabaseProvider>().alarms.length,
          itemBuilder: (context, index) {
            final alarm = context.watch<DatabaseProvider>().alarms[index];
            return DetailWidget(
              title: alarm.name,
              initialValue: alarm.activated, // Provide the current toggle state
              onEditPressed: () {
                context
                    .read<DatabaseProvider>()
                    .getAllAlarmParameters(alarm.id);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AlarmConfigPage(alarm: alarm)),
                );
              },
              onToggle: (value) {
                context
                    .read<DatabaseProvider>()
                    .updateAlarm(alarm.copyWith(activated: value));
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var alarm = await context
              .read<DatabaseProvider>()
              .insertAlarm(AlarmsTableCompanion.insert(
                name: '${localisation.alarm} ${context.read<DatabaseProvider>().alarms.length + 1}',
                activated: false,
              ));

          context
              .read<DatabaseProvider>()
              .getAllAlarmParameters(alarm?.id ?? 0);

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlarmConfigPage(
                    alarm: alarm ??
                        AlarmsTableData(
                            id: -1, name: 'error', activated: false)),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
