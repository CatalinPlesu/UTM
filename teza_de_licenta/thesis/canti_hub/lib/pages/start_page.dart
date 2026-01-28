import 'package:canti_hub/pages/main_page/main_page.dart';
import 'package:canti_hub/providers/device_provider.dart';
import 'package:canti_hub/providers/parameters_provider.dart';
import 'package:canti_hub/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

import 'package:provider/provider.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      context.read<SettingsProvider>().loadSettings();
      Future.microtask(() {
        context.read<SettingsProvider>().loadTheme();
      });
      Future.delayed(Duration(microseconds: 500), () {
        context.read<ParametersProvider>().loadParameters(context);
        Future.microtask(() {
          context.read<DeviceProvider>().loadParameters();
        });
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    });

    return Scaffold(
      body: Container(
        child: Center(
          child: Transform.rotate(
            angle: -math.pi / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Canti ',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 40),
                ),
                Text(
                  'Hub',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
