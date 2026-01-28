import 'dart:convert';
import 'package:canti_hub/common/files.dart';
import 'package:canti_hub/common/parameters.dart';
import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParametersProvider extends ChangeNotifier {
  List<Parameter> parameters = [];
  DatabaseProvider? _dbProvider;

  void loadParameters(BuildContext context) async {
    try {
      String contents =
          await DefaultAssetBundle.of(context).loadString(Files.parameters);

      var l = jsonDecode(contents);
      parameters = (l["parameters"] as List<dynamic>)
          .map((json) => Parameter.fromJson(json))
          .toList();

      notifyListeners();

      _insertParameters();
    } catch (e) {
      print('Error loading parameters: $e');
    }
  }

  void updateDb(DatabaseProvider? dbProvider) {
    _dbProvider = dbProvider;
  }

  void _insertParameters() async {
    if (_dbProvider != null &&
        _dbProvider!.parameters.length != parameters.length) {
      for (var parameter in parameters) {
        _dbProvider!.insertParameter(ParametersTableCompanion(
            index: Value(parameter.index),
            name: Value(parameter.name),
            recurrence: Value(parameter.recurrence),
            normal: Value(parameter.normal),
            min: Value(parameter.min),
            max: Value(parameter.max),
            units: Value(parameter.units)));
      }
    }
  }
}
