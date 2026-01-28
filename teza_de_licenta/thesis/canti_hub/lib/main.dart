import 'package:canti_hub/pages/start_page.dart';
import 'package:canti_hub/providers/bluetooth_provider.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:canti_hub/providers/device_provider.dart';
import 'package:canti_hub/providers/parameters_provider.dart';
import 'package:canti_hub/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  requestAppPermissions();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(App());
}

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProxyProvider<DatabaseProvider, ParametersProvider>(
            create: (_) => ParametersProvider(),
            update: (_, db, element) => (element != null)
                ? (element..updateDb(db))
                : ParametersProvider()),
        ChangeNotifierProxyProvider<DatabaseProvider, DeviceProvider>(
            create: (_) => DeviceProvider(),
            update: (_, db, element) =>
                (element != null) ? (element..updateDb(db)) : DeviceProvider()),
        ChangeNotifierProxyProvider<DatabaseProvider, BluetoothProvider>(
            create: (_) => BluetoothProvider(),
            update: (_, db, bl) =>
                (bl != null) ? (bl..updateDb(db)) : BluetoothProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Canti Hub',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: themeProvider.getLightTheme,
            darkTheme: themeProvider.getDarkTheme,
            themeMode: themeProvider.getThemeMode,
            home: const StartPage(),
          );
        },
      ),
    );
  }
}

// Function to request necessary permissions
void requestAppPermissions() {
  Permission.bluetooth.request();
  Permission.bluetoothScan.request();
  Permission.bluetoothConnect.request();
  Permission.notification.request();
//   Permission.systemAlertWindow.request();
//   Permission.ignoreBatteryOptimizations.request();
}
