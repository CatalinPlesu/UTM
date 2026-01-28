// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DevicesTableTable extends DevicesTable
    with TableInfo<$DevicesTableTable, DevicesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevicesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<DeviceType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<DeviceType>($DevicesTableTable.$convertertype);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNmaeMeta =
      const VerificationMeta('displayNmae');
  @override
  late final GeneratedColumn<String> displayNmae = GeneratedColumn<String>(
      'display_nmae', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _softwareVersionMeta =
      const VerificationMeta('softwareVersion');
  @override
  late final GeneratedColumn<String> softwareVersion = GeneratedColumn<String>(
      'software_version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hardwareVersionMeta =
      const VerificationMeta('hardwareVersion');
  @override
  late final GeneratedColumn<String> hardwareVersion = GeneratedColumn<String>(
      'hardware_version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _firstConnectionMeta =
      const VerificationMeta('firstConnection');
  @override
  late final GeneratedColumn<DateTime> firstConnection =
      GeneratedColumn<DateTime>('first_connection', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastOnlineMeta =
      const VerificationMeta('lastOnline');
  @override
  late final GeneratedColumn<DateTime> lastOnline = GeneratedColumn<DateTime>(
      'last_online', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
      'time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        remoteId,
        name,
        displayNmae,
        softwareVersion,
        hardwareVersion,
        firstConnection,
        lastOnline,
        time
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devices_table';
  @override
  VerificationContext validateIntegrity(Insertable<DevicesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('display_nmae')) {
      context.handle(
          _displayNmaeMeta,
          displayNmae.isAcceptableOrUnknown(
              data['display_nmae']!, _displayNmaeMeta));
    } else if (isInserting) {
      context.missing(_displayNmaeMeta);
    }
    if (data.containsKey('software_version')) {
      context.handle(
          _softwareVersionMeta,
          softwareVersion.isAcceptableOrUnknown(
              data['software_version']!, _softwareVersionMeta));
    } else if (isInserting) {
      context.missing(_softwareVersionMeta);
    }
    if (data.containsKey('hardware_version')) {
      context.handle(
          _hardwareVersionMeta,
          hardwareVersion.isAcceptableOrUnknown(
              data['hardware_version']!, _hardwareVersionMeta));
    } else if (isInserting) {
      context.missing(_hardwareVersionMeta);
    }
    if (data.containsKey('first_connection')) {
      context.handle(
          _firstConnectionMeta,
          firstConnection.isAcceptableOrUnknown(
              data['first_connection']!, _firstConnectionMeta));
    } else if (isInserting) {
      context.missing(_firstConnectionMeta);
    }
    if (data.containsKey('last_online')) {
      context.handle(
          _lastOnlineMeta,
          lastOnline.isAcceptableOrUnknown(
              data['last_online']!, _lastOnlineMeta));
    } else if (isInserting) {
      context.missing(_lastOnlineMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DevicesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DevicesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: $DevicesTableTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      displayNmae: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_nmae'])!,
      softwareVersion: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}software_version'])!,
      hardwareVersion: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}hardware_version'])!,
      firstConnection: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}first_connection'])!,
      lastOnline: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_online'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}time']),
    );
  }

  @override
  $DevicesTableTable createAlias(String alias) {
    return $DevicesTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DeviceType, int, int> $convertertype =
      const EnumIndexConverter<DeviceType>(DeviceType.values);
}

class DevicesTableData extends DataClass
    implements Insertable<DevicesTableData> {
  final int id;
  final DeviceType type;
  final String remoteId;
  final String name;
  final String displayNmae;
  final String softwareVersion;
  final String hardwareVersion;
  final DateTime firstConnection;
  final DateTime lastOnline;
  final DateTime? time;
  const DevicesTableData(
      {required this.id,
      required this.type,
      required this.remoteId,
      required this.name,
      required this.displayNmae,
      required this.softwareVersion,
      required this.hardwareVersion,
      required this.firstConnection,
      required this.lastOnline,
      this.time});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] =
          Variable<int>($DevicesTableTable.$convertertype.toSql(type));
    }
    map['remote_id'] = Variable<String>(remoteId);
    map['name'] = Variable<String>(name);
    map['display_nmae'] = Variable<String>(displayNmae);
    map['software_version'] = Variable<String>(softwareVersion);
    map['hardware_version'] = Variable<String>(hardwareVersion);
    map['first_connection'] = Variable<DateTime>(firstConnection);
    map['last_online'] = Variable<DateTime>(lastOnline);
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<DateTime>(time);
    }
    return map;
  }

  DevicesTableCompanion toCompanion(bool nullToAbsent) {
    return DevicesTableCompanion(
      id: Value(id),
      type: Value(type),
      remoteId: Value(remoteId),
      name: Value(name),
      displayNmae: Value(displayNmae),
      softwareVersion: Value(softwareVersion),
      hardwareVersion: Value(hardwareVersion),
      firstConnection: Value(firstConnection),
      lastOnline: Value(lastOnline),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
    );
  }

  factory DevicesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DevicesTableData(
      id: serializer.fromJson<int>(json['id']),
      type: $DevicesTableTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      name: serializer.fromJson<String>(json['name']),
      displayNmae: serializer.fromJson<String>(json['displayNmae']),
      softwareVersion: serializer.fromJson<String>(json['softwareVersion']),
      hardwareVersion: serializer.fromJson<String>(json['hardwareVersion']),
      firstConnection: serializer.fromJson<DateTime>(json['firstConnection']),
      lastOnline: serializer.fromJson<DateTime>(json['lastOnline']),
      time: serializer.fromJson<DateTime?>(json['time']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer
          .toJson<int>($DevicesTableTable.$convertertype.toJson(type)),
      'remoteId': serializer.toJson<String>(remoteId),
      'name': serializer.toJson<String>(name),
      'displayNmae': serializer.toJson<String>(displayNmae),
      'softwareVersion': serializer.toJson<String>(softwareVersion),
      'hardwareVersion': serializer.toJson<String>(hardwareVersion),
      'firstConnection': serializer.toJson<DateTime>(firstConnection),
      'lastOnline': serializer.toJson<DateTime>(lastOnline),
      'time': serializer.toJson<DateTime?>(time),
    };
  }

  DevicesTableData copyWith(
          {int? id,
          DeviceType? type,
          String? remoteId,
          String? name,
          String? displayNmae,
          String? softwareVersion,
          String? hardwareVersion,
          DateTime? firstConnection,
          DateTime? lastOnline,
          Value<DateTime?> time = const Value.absent()}) =>
      DevicesTableData(
        id: id ?? this.id,
        type: type ?? this.type,
        remoteId: remoteId ?? this.remoteId,
        name: name ?? this.name,
        displayNmae: displayNmae ?? this.displayNmae,
        softwareVersion: softwareVersion ?? this.softwareVersion,
        hardwareVersion: hardwareVersion ?? this.hardwareVersion,
        firstConnection: firstConnection ?? this.firstConnection,
        lastOnline: lastOnline ?? this.lastOnline,
        time: time.present ? time.value : this.time,
      );
  @override
  String toString() {
    return (StringBuffer('DevicesTableData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('remoteId: $remoteId, ')
          ..write('name: $name, ')
          ..write('displayNmae: $displayNmae, ')
          ..write('softwareVersion: $softwareVersion, ')
          ..write('hardwareVersion: $hardwareVersion, ')
          ..write('firstConnection: $firstConnection, ')
          ..write('lastOnline: $lastOnline, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, remoteId, name, displayNmae,
      softwareVersion, hardwareVersion, firstConnection, lastOnline, time);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DevicesTableData &&
          other.id == this.id &&
          other.type == this.type &&
          other.remoteId == this.remoteId &&
          other.name == this.name &&
          other.displayNmae == this.displayNmae &&
          other.softwareVersion == this.softwareVersion &&
          other.hardwareVersion == this.hardwareVersion &&
          other.firstConnection == this.firstConnection &&
          other.lastOnline == this.lastOnline &&
          other.time == this.time);
}

class DevicesTableCompanion extends UpdateCompanion<DevicesTableData> {
  final Value<int> id;
  final Value<DeviceType> type;
  final Value<String> remoteId;
  final Value<String> name;
  final Value<String> displayNmae;
  final Value<String> softwareVersion;
  final Value<String> hardwareVersion;
  final Value<DateTime> firstConnection;
  final Value<DateTime> lastOnline;
  final Value<DateTime?> time;
  const DevicesTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.name = const Value.absent(),
    this.displayNmae = const Value.absent(),
    this.softwareVersion = const Value.absent(),
    this.hardwareVersion = const Value.absent(),
    this.firstConnection = const Value.absent(),
    this.lastOnline = const Value.absent(),
    this.time = const Value.absent(),
  });
  DevicesTableCompanion.insert({
    this.id = const Value.absent(),
    required DeviceType type,
    required String remoteId,
    required String name,
    required String displayNmae,
    required String softwareVersion,
    required String hardwareVersion,
    required DateTime firstConnection,
    required DateTime lastOnline,
    this.time = const Value.absent(),
  })  : type = Value(type),
        remoteId = Value(remoteId),
        name = Value(name),
        displayNmae = Value(displayNmae),
        softwareVersion = Value(softwareVersion),
        hardwareVersion = Value(hardwareVersion),
        firstConnection = Value(firstConnection),
        lastOnline = Value(lastOnline);
  static Insertable<DevicesTableData> custom({
    Expression<int>? id,
    Expression<int>? type,
    Expression<String>? remoteId,
    Expression<String>? name,
    Expression<String>? displayNmae,
    Expression<String>? softwareVersion,
    Expression<String>? hardwareVersion,
    Expression<DateTime>? firstConnection,
    Expression<DateTime>? lastOnline,
    Expression<DateTime>? time,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (remoteId != null) 'remote_id': remoteId,
      if (name != null) 'name': name,
      if (displayNmae != null) 'display_nmae': displayNmae,
      if (softwareVersion != null) 'software_version': softwareVersion,
      if (hardwareVersion != null) 'hardware_version': hardwareVersion,
      if (firstConnection != null) 'first_connection': firstConnection,
      if (lastOnline != null) 'last_online': lastOnline,
      if (time != null) 'time': time,
    });
  }

  DevicesTableCompanion copyWith(
      {Value<int>? id,
      Value<DeviceType>? type,
      Value<String>? remoteId,
      Value<String>? name,
      Value<String>? displayNmae,
      Value<String>? softwareVersion,
      Value<String>? hardwareVersion,
      Value<DateTime>? firstConnection,
      Value<DateTime>? lastOnline,
      Value<DateTime?>? time}) {
    return DevicesTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      remoteId: remoteId ?? this.remoteId,
      name: name ?? this.name,
      displayNmae: displayNmae ?? this.displayNmae,
      softwareVersion: softwareVersion ?? this.softwareVersion,
      hardwareVersion: hardwareVersion ?? this.hardwareVersion,
      firstConnection: firstConnection ?? this.firstConnection,
      lastOnline: lastOnline ?? this.lastOnline,
      time: time ?? this.time,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($DevicesTableTable.$convertertype.toSql(type.value));
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (displayNmae.present) {
      map['display_nmae'] = Variable<String>(displayNmae.value);
    }
    if (softwareVersion.present) {
      map['software_version'] = Variable<String>(softwareVersion.value);
    }
    if (hardwareVersion.present) {
      map['hardware_version'] = Variable<String>(hardwareVersion.value);
    }
    if (firstConnection.present) {
      map['first_connection'] = Variable<DateTime>(firstConnection.value);
    }
    if (lastOnline.present) {
      map['last_online'] = Variable<DateTime>(lastOnline.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevicesTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('remoteId: $remoteId, ')
          ..write('name: $name, ')
          ..write('displayNmae: $displayNmae, ')
          ..write('softwareVersion: $softwareVersion, ')
          ..write('hardwareVersion: $hardwareVersion, ')
          ..write('firstConnection: $firstConnection, ')
          ..write('lastOnline: $lastOnline, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }
}

class $ParametersTableTable extends ParametersTable
    with TableInfo<$ParametersTableTable, ParametersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParametersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _indexMeta = const VerificationMeta('index');
  @override
  late final GeneratedColumn<int> index = GeneratedColumn<int>(
      'index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recurrenceMeta =
      const VerificationMeta('recurrence');
  @override
  late final GeneratedColumn<int> recurrence = GeneratedColumn<int>(
      'recurrence', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _normalMeta = const VerificationMeta('normal');
  @override
  late final GeneratedColumn<double> normal = GeneratedColumn<double>(
      'normal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _maxMeta = const VerificationMeta('max');
  @override
  late final GeneratedColumn<double> max = GeneratedColumn<double>(
      'max', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _minMeta = const VerificationMeta('min');
  @override
  late final GeneratedColumn<double> min = GeneratedColumn<double>(
      'min', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitsMeta = const VerificationMeta('units');
  @override
  late final GeneratedColumn<String> units = GeneratedColumn<String>(
      'units', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [index, name, recurrence, normal, max, min, units];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parameters_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ParametersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('index')) {
      context.handle(
          _indexMeta, index.isAcceptableOrUnknown(data['index']!, _indexMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('recurrence')) {
      context.handle(
          _recurrenceMeta,
          recurrence.isAcceptableOrUnknown(
              data['recurrence']!, _recurrenceMeta));
    } else if (isInserting) {
      context.missing(_recurrenceMeta);
    }
    if (data.containsKey('normal')) {
      context.handle(_normalMeta,
          normal.isAcceptableOrUnknown(data['normal']!, _normalMeta));
    } else if (isInserting) {
      context.missing(_normalMeta);
    }
    if (data.containsKey('max')) {
      context.handle(
          _maxMeta, max.isAcceptableOrUnknown(data['max']!, _maxMeta));
    } else if (isInserting) {
      context.missing(_maxMeta);
    }
    if (data.containsKey('min')) {
      context.handle(
          _minMeta, min.isAcceptableOrUnknown(data['min']!, _minMeta));
    } else if (isInserting) {
      context.missing(_minMeta);
    }
    if (data.containsKey('units')) {
      context.handle(
          _unitsMeta, units.isAcceptableOrUnknown(data['units']!, _unitsMeta));
    } else if (isInserting) {
      context.missing(_unitsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {index};
  @override
  ParametersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParametersTableData(
      index: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}index'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      recurrence: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recurrence'])!,
      normal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}normal'])!,
      max: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max'])!,
      min: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}min'])!,
      units: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}units'])!,
    );
  }

  @override
  $ParametersTableTable createAlias(String alias) {
    return $ParametersTableTable(attachedDatabase, alias);
  }
}

class ParametersTableData extends DataClass
    implements Insertable<ParametersTableData> {
  final int index;
  final String name;
  final int recurrence;
  final double normal;
  final double max;
  final double min;
  final String units;
  const ParametersTableData(
      {required this.index,
      required this.name,
      required this.recurrence,
      required this.normal,
      required this.max,
      required this.min,
      required this.units});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['index'] = Variable<int>(index);
    map['name'] = Variable<String>(name);
    map['recurrence'] = Variable<int>(recurrence);
    map['normal'] = Variable<double>(normal);
    map['max'] = Variable<double>(max);
    map['min'] = Variable<double>(min);
    map['units'] = Variable<String>(units);
    return map;
  }

  ParametersTableCompanion toCompanion(bool nullToAbsent) {
    return ParametersTableCompanion(
      index: Value(index),
      name: Value(name),
      recurrence: Value(recurrence),
      normal: Value(normal),
      max: Value(max),
      min: Value(min),
      units: Value(units),
    );
  }

  factory ParametersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParametersTableData(
      index: serializer.fromJson<int>(json['index']),
      name: serializer.fromJson<String>(json['name']),
      recurrence: serializer.fromJson<int>(json['recurrence']),
      normal: serializer.fromJson<double>(json['normal']),
      max: serializer.fromJson<double>(json['max']),
      min: serializer.fromJson<double>(json['min']),
      units: serializer.fromJson<String>(json['units']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'index': serializer.toJson<int>(index),
      'name': serializer.toJson<String>(name),
      'recurrence': serializer.toJson<int>(recurrence),
      'normal': serializer.toJson<double>(normal),
      'max': serializer.toJson<double>(max),
      'min': serializer.toJson<double>(min),
      'units': serializer.toJson<String>(units),
    };
  }

  ParametersTableData copyWith(
          {int? index,
          String? name,
          int? recurrence,
          double? normal,
          double? max,
          double? min,
          String? units}) =>
      ParametersTableData(
        index: index ?? this.index,
        name: name ?? this.name,
        recurrence: recurrence ?? this.recurrence,
        normal: normal ?? this.normal,
        max: max ?? this.max,
        min: min ?? this.min,
        units: units ?? this.units,
      );
  @override
  String toString() {
    return (StringBuffer('ParametersTableData(')
          ..write('index: $index, ')
          ..write('name: $name, ')
          ..write('recurrence: $recurrence, ')
          ..write('normal: $normal, ')
          ..write('max: $max, ')
          ..write('min: $min, ')
          ..write('units: $units')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(index, name, recurrence, normal, max, min, units);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParametersTableData &&
          other.index == this.index &&
          other.name == this.name &&
          other.recurrence == this.recurrence &&
          other.normal == this.normal &&
          other.max == this.max &&
          other.min == this.min &&
          other.units == this.units);
}

class ParametersTableCompanion extends UpdateCompanion<ParametersTableData> {
  final Value<int> index;
  final Value<String> name;
  final Value<int> recurrence;
  final Value<double> normal;
  final Value<double> max;
  final Value<double> min;
  final Value<String> units;
  const ParametersTableCompanion({
    this.index = const Value.absent(),
    this.name = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.normal = const Value.absent(),
    this.max = const Value.absent(),
    this.min = const Value.absent(),
    this.units = const Value.absent(),
  });
  ParametersTableCompanion.insert({
    this.index = const Value.absent(),
    required String name,
    required int recurrence,
    required double normal,
    required double max,
    required double min,
    required String units,
  })  : name = Value(name),
        recurrence = Value(recurrence),
        normal = Value(normal),
        max = Value(max),
        min = Value(min),
        units = Value(units);
  static Insertable<ParametersTableData> custom({
    Expression<int>? index,
    Expression<String>? name,
    Expression<int>? recurrence,
    Expression<double>? normal,
    Expression<double>? max,
    Expression<double>? min,
    Expression<String>? units,
  }) {
    return RawValuesInsertable({
      if (index != null) 'index': index,
      if (name != null) 'name': name,
      if (recurrence != null) 'recurrence': recurrence,
      if (normal != null) 'normal': normal,
      if (max != null) 'max': max,
      if (min != null) 'min': min,
      if (units != null) 'units': units,
    });
  }

  ParametersTableCompanion copyWith(
      {Value<int>? index,
      Value<String>? name,
      Value<int>? recurrence,
      Value<double>? normal,
      Value<double>? max,
      Value<double>? min,
      Value<String>? units}) {
    return ParametersTableCompanion(
      index: index ?? this.index,
      name: name ?? this.name,
      recurrence: recurrence ?? this.recurrence,
      normal: normal ?? this.normal,
      max: max ?? this.max,
      min: min ?? this.min,
      units: units ?? this.units,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<int>(recurrence.value);
    }
    if (normal.present) {
      map['normal'] = Variable<double>(normal.value);
    }
    if (max.present) {
      map['max'] = Variable<double>(max.value);
    }
    if (min.present) {
      map['min'] = Variable<double>(min.value);
    }
    if (units.present) {
      map['units'] = Variable<String>(units.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParametersTableCompanion(')
          ..write('index: $index, ')
          ..write('name: $name, ')
          ..write('recurrence: $recurrence, ')
          ..write('normal: $normal, ')
          ..write('max: $max, ')
          ..write('min: $min, ')
          ..write('units: $units')
          ..write(')'))
        .toString();
  }
}

class $ColectedDataTableTable extends ColectedDataTable
    with TableInfo<$ColectedDataTableTable, ColectedDataTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ColectedDataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _parameterIdMeta =
      const VerificationMeta('parameterId');
  @override
  late final GeneratedColumn<int> parameterId = GeneratedColumn<int>(
      'parameter_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES parameters_table ("index")'));
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<int> deviceId = GeneratedColumn<int>(
      'device_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES devices_table (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [parameterId, deviceId, createdAt, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'colected_data_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ColectedDataTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('parameter_id')) {
      context.handle(
          _parameterIdMeta,
          parameterId.isAcceptableOrUnknown(
              data['parameter_id']!, _parameterIdMeta));
    } else if (isInserting) {
      context.missing(_parameterIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {parameterId, deviceId, createdAt};
  @override
  ColectedDataTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ColectedDataTableData(
      parameterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parameter_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}device_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $ColectedDataTableTable createAlias(String alias) {
    return $ColectedDataTableTable(attachedDatabase, alias);
  }
}

class ColectedDataTableData extends DataClass
    implements Insertable<ColectedDataTableData> {
  final int parameterId;
  final int deviceId;
  final DateTime createdAt;
  final double value;
  const ColectedDataTableData(
      {required this.parameterId,
      required this.deviceId,
      required this.createdAt,
      required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['parameter_id'] = Variable<int>(parameterId);
    map['device_id'] = Variable<int>(deviceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['value'] = Variable<double>(value);
    return map;
  }

  ColectedDataTableCompanion toCompanion(bool nullToAbsent) {
    return ColectedDataTableCompanion(
      parameterId: Value(parameterId),
      deviceId: Value(deviceId),
      createdAt: Value(createdAt),
      value: Value(value),
    );
  }

  factory ColectedDataTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ColectedDataTableData(
      parameterId: serializer.fromJson<int>(json['parameterId']),
      deviceId: serializer.fromJson<int>(json['deviceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      value: serializer.fromJson<double>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'parameterId': serializer.toJson<int>(parameterId),
      'deviceId': serializer.toJson<int>(deviceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'value': serializer.toJson<double>(value),
    };
  }

  ColectedDataTableData copyWith(
          {int? parameterId,
          int? deviceId,
          DateTime? createdAt,
          double? value}) =>
      ColectedDataTableData(
        parameterId: parameterId ?? this.parameterId,
        deviceId: deviceId ?? this.deviceId,
        createdAt: createdAt ?? this.createdAt,
        value: value ?? this.value,
      );
  @override
  String toString() {
    return (StringBuffer('ColectedDataTableData(')
          ..write('parameterId: $parameterId, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(parameterId, deviceId, createdAt, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ColectedDataTableData &&
          other.parameterId == this.parameterId &&
          other.deviceId == this.deviceId &&
          other.createdAt == this.createdAt &&
          other.value == this.value);
}

class ColectedDataTableCompanion
    extends UpdateCompanion<ColectedDataTableData> {
  final Value<int> parameterId;
  final Value<int> deviceId;
  final Value<DateTime> createdAt;
  final Value<double> value;
  final Value<int> rowid;
  const ColectedDataTableCompanion({
    this.parameterId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ColectedDataTableCompanion.insert({
    required int parameterId,
    required int deviceId,
    this.createdAt = const Value.absent(),
    required double value,
    this.rowid = const Value.absent(),
  })  : parameterId = Value(parameterId),
        deviceId = Value(deviceId),
        value = Value(value);
  static Insertable<ColectedDataTableData> custom({
    Expression<int>? parameterId,
    Expression<int>? deviceId,
    Expression<DateTime>? createdAt,
    Expression<double>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (parameterId != null) 'parameter_id': parameterId,
      if (deviceId != null) 'device_id': deviceId,
      if (createdAt != null) 'created_at': createdAt,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ColectedDataTableCompanion copyWith(
      {Value<int>? parameterId,
      Value<int>? deviceId,
      Value<DateTime>? createdAt,
      Value<double>? value,
      Value<int>? rowid}) {
    return ColectedDataTableCompanion(
      parameterId: parameterId ?? this.parameterId,
      deviceId: deviceId ?? this.deviceId,
      createdAt: createdAt ?? this.createdAt,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (parameterId.present) {
      map['parameter_id'] = Variable<int>(parameterId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<int>(deviceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ColectedDataTableCompanion(')
          ..write('parameterId: $parameterId, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WifiTableTable extends WifiTable
    with TableInfo<$WifiTableTable, WifiTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WifiTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ssidMeta = const VerificationMeta('ssid');
  @override
  late final GeneratedColumn<String> ssid = GeneratedColumn<String>(
      'ssid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, ssid, password];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wifi_table';
  @override
  VerificationContext validateIntegrity(Insertable<WifiTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ssid')) {
      context.handle(
          _ssidMeta, ssid.isAcceptableOrUnknown(data['ssid']!, _ssidMeta));
    } else if (isInserting) {
      context.missing(_ssidMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WifiTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WifiTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ssid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ssid'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
    );
  }

  @override
  $WifiTableTable createAlias(String alias) {
    return $WifiTableTable(attachedDatabase, alias);
  }
}

class WifiTableData extends DataClass implements Insertable<WifiTableData> {
  final int id;
  final String ssid;
  final String password;
  const WifiTableData(
      {required this.id, required this.ssid, required this.password});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ssid'] = Variable<String>(ssid);
    map['password'] = Variable<String>(password);
    return map;
  }

  WifiTableCompanion toCompanion(bool nullToAbsent) {
    return WifiTableCompanion(
      id: Value(id),
      ssid: Value(ssid),
      password: Value(password),
    );
  }

  factory WifiTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WifiTableData(
      id: serializer.fromJson<int>(json['id']),
      ssid: serializer.fromJson<String>(json['ssid']),
      password: serializer.fromJson<String>(json['password']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ssid': serializer.toJson<String>(ssid),
      'password': serializer.toJson<String>(password),
    };
  }

  WifiTableData copyWith({int? id, String? ssid, String? password}) =>
      WifiTableData(
        id: id ?? this.id,
        ssid: ssid ?? this.ssid,
        password: password ?? this.password,
      );
  @override
  String toString() {
    return (StringBuffer('WifiTableData(')
          ..write('id: $id, ')
          ..write('ssid: $ssid, ')
          ..write('password: $password')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ssid, password);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WifiTableData &&
          other.id == this.id &&
          other.ssid == this.ssid &&
          other.password == this.password);
}

class WifiTableCompanion extends UpdateCompanion<WifiTableData> {
  final Value<int> id;
  final Value<String> ssid;
  final Value<String> password;
  const WifiTableCompanion({
    this.id = const Value.absent(),
    this.ssid = const Value.absent(),
    this.password = const Value.absent(),
  });
  WifiTableCompanion.insert({
    this.id = const Value.absent(),
    required String ssid,
    required String password,
  })  : ssid = Value(ssid),
        password = Value(password);
  static Insertable<WifiTableData> custom({
    Expression<int>? id,
    Expression<String>? ssid,
    Expression<String>? password,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ssid != null) 'ssid': ssid,
      if (password != null) 'password': password,
    });
  }

  WifiTableCompanion copyWith(
      {Value<int>? id, Value<String>? ssid, Value<String>? password}) {
    return WifiTableCompanion(
      id: id ?? this.id,
      ssid: ssid ?? this.ssid,
      password: password ?? this.password,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ssid.present) {
      map['ssid'] = Variable<String>(ssid.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WifiTableCompanion(')
          ..write('id: $id, ')
          ..write('ssid: $ssid, ')
          ..write('password: $password')
          ..write(')'))
        .toString();
  }
}

class $DeviceWifiTableTable extends DeviceWifiTable
    with TableInfo<$DeviceWifiTableTable, DeviceWifiTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceWifiTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<int> deviceId = GeneratedColumn<int>(
      'device_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES devices_table (id)'));
  static const VerificationMeta _wifiIdMeta = const VerificationMeta('wifiId');
  @override
  late final GeneratedColumn<int> wifiId = GeneratedColumn<int>(
      'wifi_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES wifi_table (id)'));
  @override
  List<GeneratedColumn> get $columns => [deviceId, wifiId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_wifi_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<DeviceWifiTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('wifi_id')) {
      context.handle(_wifiIdMeta,
          wifiId.isAcceptableOrUnknown(data['wifi_id']!, _wifiIdMeta));
    } else if (isInserting) {
      context.missing(_wifiIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId, wifiId};
  @override
  DeviceWifiTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceWifiTableData(
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}device_id'])!,
      wifiId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wifi_id'])!,
    );
  }

  @override
  $DeviceWifiTableTable createAlias(String alias) {
    return $DeviceWifiTableTable(attachedDatabase, alias);
  }
}

class DeviceWifiTableData extends DataClass
    implements Insertable<DeviceWifiTableData> {
  final int deviceId;
  final int wifiId;
  const DeviceWifiTableData({required this.deviceId, required this.wifiId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<int>(deviceId);
    map['wifi_id'] = Variable<int>(wifiId);
    return map;
  }

  DeviceWifiTableCompanion toCompanion(bool nullToAbsent) {
    return DeviceWifiTableCompanion(
      deviceId: Value(deviceId),
      wifiId: Value(wifiId),
    );
  }

  factory DeviceWifiTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceWifiTableData(
      deviceId: serializer.fromJson<int>(json['deviceId']),
      wifiId: serializer.fromJson<int>(json['wifiId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<int>(deviceId),
      'wifiId': serializer.toJson<int>(wifiId),
    };
  }

  DeviceWifiTableData copyWith({int? deviceId, int? wifiId}) =>
      DeviceWifiTableData(
        deviceId: deviceId ?? this.deviceId,
        wifiId: wifiId ?? this.wifiId,
      );
  @override
  String toString() {
    return (StringBuffer('DeviceWifiTableData(')
          ..write('deviceId: $deviceId, ')
          ..write('wifiId: $wifiId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(deviceId, wifiId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceWifiTableData &&
          other.deviceId == this.deviceId &&
          other.wifiId == this.wifiId);
}

class DeviceWifiTableCompanion extends UpdateCompanion<DeviceWifiTableData> {
  final Value<int> deviceId;
  final Value<int> wifiId;
  final Value<int> rowid;
  const DeviceWifiTableCompanion({
    this.deviceId = const Value.absent(),
    this.wifiId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceWifiTableCompanion.insert({
    required int deviceId,
    required int wifiId,
    this.rowid = const Value.absent(),
  })  : deviceId = Value(deviceId),
        wifiId = Value(wifiId);
  static Insertable<DeviceWifiTableData> custom({
    Expression<int>? deviceId,
    Expression<int>? wifiId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (wifiId != null) 'wifi_id': wifiId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceWifiTableCompanion copyWith(
      {Value<int>? deviceId, Value<int>? wifiId, Value<int>? rowid}) {
    return DeviceWifiTableCompanion(
      deviceId: deviceId ?? this.deviceId,
      wifiId: wifiId ?? this.wifiId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<int>(deviceId.value);
    }
    if (wifiId.present) {
      map['wifi_id'] = Variable<int>(wifiId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceWifiTableCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('wifiId: $wifiId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MqttTableTable extends MqttTable
    with TableInfo<$MqttTableTable, MqttTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MqttTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serverUrlMeta =
      const VerificationMeta('serverUrl');
  @override
  late final GeneratedColumn<String> serverUrl = GeneratedColumn<String>(
      'server_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
      'port', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1883));
  static const VerificationMeta _apiKeyMeta = const VerificationMeta('apiKey');
  @override
  late final GeneratedColumn<String> apiKey = GeneratedColumn<String>(
      'api_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, serverUrl, port, apiKey, username, password];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mqtt_table';
  @override
  VerificationContext validateIntegrity(Insertable<MqttTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_url')) {
      context.handle(_serverUrlMeta,
          serverUrl.isAcceptableOrUnknown(data['server_url']!, _serverUrlMeta));
    } else if (isInserting) {
      context.missing(_serverUrlMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
          _portMeta, port.isAcceptableOrUnknown(data['port']!, _portMeta));
    }
    if (data.containsKey('api_key')) {
      context.handle(_apiKeyMeta,
          apiKey.isAcceptableOrUnknown(data['api_key']!, _apiKeyMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MqttTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MqttTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serverUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_url'])!,
      port: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}port']),
      apiKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}api_key']),
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password']),
    );
  }

  @override
  $MqttTableTable createAlias(String alias) {
    return $MqttTableTable(attachedDatabase, alias);
  }
}

class MqttTableData extends DataClass implements Insertable<MqttTableData> {
  final int id;
  final String serverUrl;
  final int? port;
  final String? apiKey;
  final String username;
  final String? password;
  const MqttTableData(
      {required this.id,
      required this.serverUrl,
      this.port,
      this.apiKey,
      required this.username,
      this.password});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['server_url'] = Variable<String>(serverUrl);
    if (!nullToAbsent || port != null) {
      map['port'] = Variable<int>(port);
    }
    if (!nullToAbsent || apiKey != null) {
      map['api_key'] = Variable<String>(apiKey);
    }
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    return map;
  }

  MqttTableCompanion toCompanion(bool nullToAbsent) {
    return MqttTableCompanion(
      id: Value(id),
      serverUrl: Value(serverUrl),
      port: port == null && nullToAbsent ? const Value.absent() : Value(port),
      apiKey:
          apiKey == null && nullToAbsent ? const Value.absent() : Value(apiKey),
      username: Value(username),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
    );
  }

  factory MqttTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MqttTableData(
      id: serializer.fromJson<int>(json['id']),
      serverUrl: serializer.fromJson<String>(json['serverUrl']),
      port: serializer.fromJson<int?>(json['port']),
      apiKey: serializer.fromJson<String?>(json['apiKey']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String?>(json['password']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverUrl': serializer.toJson<String>(serverUrl),
      'port': serializer.toJson<int?>(port),
      'apiKey': serializer.toJson<String?>(apiKey),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String?>(password),
    };
  }

  MqttTableData copyWith(
          {int? id,
          String? serverUrl,
          Value<int?> port = const Value.absent(),
          Value<String?> apiKey = const Value.absent(),
          String? username,
          Value<String?> password = const Value.absent()}) =>
      MqttTableData(
        id: id ?? this.id,
        serverUrl: serverUrl ?? this.serverUrl,
        port: port.present ? port.value : this.port,
        apiKey: apiKey.present ? apiKey.value : this.apiKey,
        username: username ?? this.username,
        password: password.present ? password.value : this.password,
      );
  @override
  String toString() {
    return (StringBuffer('MqttTableData(')
          ..write('id: $id, ')
          ..write('serverUrl: $serverUrl, ')
          ..write('port: $port, ')
          ..write('apiKey: $apiKey, ')
          ..write('username: $username, ')
          ..write('password: $password')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, serverUrl, port, apiKey, username, password);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MqttTableData &&
          other.id == this.id &&
          other.serverUrl == this.serverUrl &&
          other.port == this.port &&
          other.apiKey == this.apiKey &&
          other.username == this.username &&
          other.password == this.password);
}

class MqttTableCompanion extends UpdateCompanion<MqttTableData> {
  final Value<int> id;
  final Value<String> serverUrl;
  final Value<int?> port;
  final Value<String?> apiKey;
  final Value<String> username;
  final Value<String?> password;
  const MqttTableCompanion({
    this.id = const Value.absent(),
    this.serverUrl = const Value.absent(),
    this.port = const Value.absent(),
    this.apiKey = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
  });
  MqttTableCompanion.insert({
    this.id = const Value.absent(),
    required String serverUrl,
    this.port = const Value.absent(),
    this.apiKey = const Value.absent(),
    required String username,
    this.password = const Value.absent(),
  })  : serverUrl = Value(serverUrl),
        username = Value(username);
  static Insertable<MqttTableData> custom({
    Expression<int>? id,
    Expression<String>? serverUrl,
    Expression<int>? port,
    Expression<String>? apiKey,
    Expression<String>? username,
    Expression<String>? password,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverUrl != null) 'server_url': serverUrl,
      if (port != null) 'port': port,
      if (apiKey != null) 'api_key': apiKey,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
    });
  }

  MqttTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? serverUrl,
      Value<int?>? port,
      Value<String?>? apiKey,
      Value<String>? username,
      Value<String?>? password}) {
    return MqttTableCompanion(
      id: id ?? this.id,
      serverUrl: serverUrl ?? this.serverUrl,
      port: port ?? this.port,
      apiKey: apiKey ?? this.apiKey,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverUrl.present) {
      map['server_url'] = Variable<String>(serverUrl.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (apiKey.present) {
      map['api_key'] = Variable<String>(apiKey.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MqttTableCompanion(')
          ..write('id: $id, ')
          ..write('serverUrl: $serverUrl, ')
          ..write('port: $port, ')
          ..write('apiKey: $apiKey, ')
          ..write('username: $username, ')
          ..write('password: $password')
          ..write(')'))
        .toString();
  }
}

class $DeviceMqttTableTable extends DeviceMqttTable
    with TableInfo<$DeviceMqttTableTable, DeviceMqttTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceMqttTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<int> deviceId = GeneratedColumn<int>(
      'device_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES devices_table (id)'));
  static const VerificationMeta _mqttIdMeta = const VerificationMeta('mqttId');
  @override
  late final GeneratedColumn<int> mqttId = GeneratedColumn<int>(
      'mqtt_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES mqtt_table (id)'));
  @override
  List<GeneratedColumn> get $columns => [deviceId, mqttId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_mqtt_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<DeviceMqttTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('mqtt_id')) {
      context.handle(_mqttIdMeta,
          mqttId.isAcceptableOrUnknown(data['mqtt_id']!, _mqttIdMeta));
    } else if (isInserting) {
      context.missing(_mqttIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId, mqttId};
  @override
  DeviceMqttTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceMqttTableData(
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}device_id'])!,
      mqttId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mqtt_id'])!,
    );
  }

  @override
  $DeviceMqttTableTable createAlias(String alias) {
    return $DeviceMqttTableTable(attachedDatabase, alias);
  }
}

class DeviceMqttTableData extends DataClass
    implements Insertable<DeviceMqttTableData> {
  final int deviceId;
  final int mqttId;
  const DeviceMqttTableData({required this.deviceId, required this.mqttId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<int>(deviceId);
    map['mqtt_id'] = Variable<int>(mqttId);
    return map;
  }

  DeviceMqttTableCompanion toCompanion(bool nullToAbsent) {
    return DeviceMqttTableCompanion(
      deviceId: Value(deviceId),
      mqttId: Value(mqttId),
    );
  }

  factory DeviceMqttTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceMqttTableData(
      deviceId: serializer.fromJson<int>(json['deviceId']),
      mqttId: serializer.fromJson<int>(json['mqttId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<int>(deviceId),
      'mqttId': serializer.toJson<int>(mqttId),
    };
  }

  DeviceMqttTableData copyWith({int? deviceId, int? mqttId}) =>
      DeviceMqttTableData(
        deviceId: deviceId ?? this.deviceId,
        mqttId: mqttId ?? this.mqttId,
      );
  @override
  String toString() {
    return (StringBuffer('DeviceMqttTableData(')
          ..write('deviceId: $deviceId, ')
          ..write('mqttId: $mqttId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(deviceId, mqttId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceMqttTableData &&
          other.deviceId == this.deviceId &&
          other.mqttId == this.mqttId);
}

class DeviceMqttTableCompanion extends UpdateCompanion<DeviceMqttTableData> {
  final Value<int> deviceId;
  final Value<int> mqttId;
  final Value<int> rowid;
  const DeviceMqttTableCompanion({
    this.deviceId = const Value.absent(),
    this.mqttId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceMqttTableCompanion.insert({
    required int deviceId,
    required int mqttId,
    this.rowid = const Value.absent(),
  })  : deviceId = Value(deviceId),
        mqttId = Value(mqttId);
  static Insertable<DeviceMqttTableData> custom({
    Expression<int>? deviceId,
    Expression<int>? mqttId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (mqttId != null) 'mqtt_id': mqttId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceMqttTableCompanion copyWith(
      {Value<int>? deviceId, Value<int>? mqttId, Value<int>? rowid}) {
    return DeviceMqttTableCompanion(
      deviceId: deviceId ?? this.deviceId,
      mqttId: mqttId ?? this.mqttId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<int>(deviceId.value);
    }
    if (mqttId.present) {
      map['mqtt_id'] = Variable<int>(mqttId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceMqttTableCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('mqttId: $mqttId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeviceParameterTableTable extends DeviceParameterTable
    with TableInfo<$DeviceParameterTableTable, DeviceParameterTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceParameterTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _parameterIdMeta =
      const VerificationMeta('parameterId');
  @override
  late final GeneratedColumn<int> parameterId = GeneratedColumn<int>(
      'parameter_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES parameters_table ("index")'));
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<int> deviceId = GeneratedColumn<int>(
      'device_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES devices_table (id)'));
  static const VerificationMeta _useUserConfigMeta =
      const VerificationMeta('useUserConfig');
  @override
  late final GeneratedColumn<bool> useUserConfig = GeneratedColumn<bool>(
      'use_user_config', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("use_user_config" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [parameterId, deviceId, useUserConfig];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_parameter_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<DeviceParameterTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('parameter_id')) {
      context.handle(
          _parameterIdMeta,
          parameterId.isAcceptableOrUnknown(
              data['parameter_id']!, _parameterIdMeta));
    } else if (isInserting) {
      context.missing(_parameterIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('use_user_config')) {
      context.handle(
          _useUserConfigMeta,
          useUserConfig.isAcceptableOrUnknown(
              data['use_user_config']!, _useUserConfigMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {parameterId, deviceId};
  @override
  DeviceParameterTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceParameterTableData(
      parameterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parameter_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}device_id'])!,
      useUserConfig: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}use_user_config'])!,
    );
  }

  @override
  $DeviceParameterTableTable createAlias(String alias) {
    return $DeviceParameterTableTable(attachedDatabase, alias);
  }
}

class DeviceParameterTableData extends DataClass
    implements Insertable<DeviceParameterTableData> {
  final int parameterId;
  final int deviceId;
  final bool useUserConfig;
  const DeviceParameterTableData(
      {required this.parameterId,
      required this.deviceId,
      required this.useUserConfig});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['parameter_id'] = Variable<int>(parameterId);
    map['device_id'] = Variable<int>(deviceId);
    map['use_user_config'] = Variable<bool>(useUserConfig);
    return map;
  }

  DeviceParameterTableCompanion toCompanion(bool nullToAbsent) {
    return DeviceParameterTableCompanion(
      parameterId: Value(parameterId),
      deviceId: Value(deviceId),
      useUserConfig: Value(useUserConfig),
    );
  }

  factory DeviceParameterTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceParameterTableData(
      parameterId: serializer.fromJson<int>(json['parameterId']),
      deviceId: serializer.fromJson<int>(json['deviceId']),
      useUserConfig: serializer.fromJson<bool>(json['useUserConfig']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'parameterId': serializer.toJson<int>(parameterId),
      'deviceId': serializer.toJson<int>(deviceId),
      'useUserConfig': serializer.toJson<bool>(useUserConfig),
    };
  }

  DeviceParameterTableData copyWith(
          {int? parameterId, int? deviceId, bool? useUserConfig}) =>
      DeviceParameterTableData(
        parameterId: parameterId ?? this.parameterId,
        deviceId: deviceId ?? this.deviceId,
        useUserConfig: useUserConfig ?? this.useUserConfig,
      );
  @override
  String toString() {
    return (StringBuffer('DeviceParameterTableData(')
          ..write('parameterId: $parameterId, ')
          ..write('deviceId: $deviceId, ')
          ..write('useUserConfig: $useUserConfig')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(parameterId, deviceId, useUserConfig);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceParameterTableData &&
          other.parameterId == this.parameterId &&
          other.deviceId == this.deviceId &&
          other.useUserConfig == this.useUserConfig);
}

class DeviceParameterTableCompanion
    extends UpdateCompanion<DeviceParameterTableData> {
  final Value<int> parameterId;
  final Value<int> deviceId;
  final Value<bool> useUserConfig;
  final Value<int> rowid;
  const DeviceParameterTableCompanion({
    this.parameterId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.useUserConfig = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceParameterTableCompanion.insert({
    required int parameterId,
    required int deviceId,
    this.useUserConfig = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : parameterId = Value(parameterId),
        deviceId = Value(deviceId);
  static Insertable<DeviceParameterTableData> custom({
    Expression<int>? parameterId,
    Expression<int>? deviceId,
    Expression<bool>? useUserConfig,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (parameterId != null) 'parameter_id': parameterId,
      if (deviceId != null) 'device_id': deviceId,
      if (useUserConfig != null) 'use_user_config': useUserConfig,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceParameterTableCompanion copyWith(
      {Value<int>? parameterId,
      Value<int>? deviceId,
      Value<bool>? useUserConfig,
      Value<int>? rowid}) {
    return DeviceParameterTableCompanion(
      parameterId: parameterId ?? this.parameterId,
      deviceId: deviceId ?? this.deviceId,
      useUserConfig: useUserConfig ?? this.useUserConfig,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (parameterId.present) {
      map['parameter_id'] = Variable<int>(parameterId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<int>(deviceId.value);
    }
    if (useUserConfig.present) {
      map['use_user_config'] = Variable<bool>(useUserConfig.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceParameterTableCompanion(')
          ..write('parameterId: $parameterId, ')
          ..write('deviceId: $deviceId, ')
          ..write('useUserConfig: $useUserConfig, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MqttParameterTableTable extends MqttParameterTable
    with TableInfo<$MqttParameterTableTable, MqttParameterTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MqttParameterTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _parameterIdMeta =
      const VerificationMeta('parameterId');
  @override
  late final GeneratedColumn<int> parameterId = GeneratedColumn<int>(
      'parameter_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES parameters_table ("index")'));
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<int> deviceId = GeneratedColumn<int>(
      'device_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES devices_table (id)'));
  static const VerificationMeta _mqttIdMeta = const VerificationMeta('mqttId');
  @override
  late final GeneratedColumn<int> mqttId = GeneratedColumn<int>(
      'mqtt_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES mqtt_table (id)'));
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
      'topic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [parameterId, deviceId, mqttId, topic];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mqtt_parameter_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<MqttParameterTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('parameter_id')) {
      context.handle(
          _parameterIdMeta,
          parameterId.isAcceptableOrUnknown(
              data['parameter_id']!, _parameterIdMeta));
    } else if (isInserting) {
      context.missing(_parameterIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('mqtt_id')) {
      context.handle(_mqttIdMeta,
          mqttId.isAcceptableOrUnknown(data['mqtt_id']!, _mqttIdMeta));
    } else if (isInserting) {
      context.missing(_mqttIdMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
          _topicMeta, topic.isAcceptableOrUnknown(data['topic']!, _topicMeta));
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {parameterId, deviceId, mqttId};
  @override
  MqttParameterTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MqttParameterTableData(
      parameterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parameter_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}device_id'])!,
      mqttId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mqtt_id'])!,
      topic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic'])!,
    );
  }

  @override
  $MqttParameterTableTable createAlias(String alias) {
    return $MqttParameterTableTable(attachedDatabase, alias);
  }
}

class MqttParameterTableData extends DataClass
    implements Insertable<MqttParameterTableData> {
  final int parameterId;
  final int deviceId;
  final int mqttId;
  final String topic;
  const MqttParameterTableData(
      {required this.parameterId,
      required this.deviceId,
      required this.mqttId,
      required this.topic});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['parameter_id'] = Variable<int>(parameterId);
    map['device_id'] = Variable<int>(deviceId);
    map['mqtt_id'] = Variable<int>(mqttId);
    map['topic'] = Variable<String>(topic);
    return map;
  }

  MqttParameterTableCompanion toCompanion(bool nullToAbsent) {
    return MqttParameterTableCompanion(
      parameterId: Value(parameterId),
      deviceId: Value(deviceId),
      mqttId: Value(mqttId),
      topic: Value(topic),
    );
  }

  factory MqttParameterTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MqttParameterTableData(
      parameterId: serializer.fromJson<int>(json['parameterId']),
      deviceId: serializer.fromJson<int>(json['deviceId']),
      mqttId: serializer.fromJson<int>(json['mqttId']),
      topic: serializer.fromJson<String>(json['topic']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'parameterId': serializer.toJson<int>(parameterId),
      'deviceId': serializer.toJson<int>(deviceId),
      'mqttId': serializer.toJson<int>(mqttId),
      'topic': serializer.toJson<String>(topic),
    };
  }

  MqttParameterTableData copyWith(
          {int? parameterId, int? deviceId, int? mqttId, String? topic}) =>
      MqttParameterTableData(
        parameterId: parameterId ?? this.parameterId,
        deviceId: deviceId ?? this.deviceId,
        mqttId: mqttId ?? this.mqttId,
        topic: topic ?? this.topic,
      );
  @override
  String toString() {
    return (StringBuffer('MqttParameterTableData(')
          ..write('parameterId: $parameterId, ')
          ..write('deviceId: $deviceId, ')
          ..write('mqttId: $mqttId, ')
          ..write('topic: $topic')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(parameterId, deviceId, mqttId, topic);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MqttParameterTableData &&
          other.parameterId == this.parameterId &&
          other.deviceId == this.deviceId &&
          other.mqttId == this.mqttId &&
          other.topic == this.topic);
}

class MqttParameterTableCompanion
    extends UpdateCompanion<MqttParameterTableData> {
  final Value<int> parameterId;
  final Value<int> deviceId;
  final Value<int> mqttId;
  final Value<String> topic;
  final Value<int> rowid;
  const MqttParameterTableCompanion({
    this.parameterId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.mqttId = const Value.absent(),
    this.topic = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MqttParameterTableCompanion.insert({
    required int parameterId,
    required int deviceId,
    required int mqttId,
    required String topic,
    this.rowid = const Value.absent(),
  })  : parameterId = Value(parameterId),
        deviceId = Value(deviceId),
        mqttId = Value(mqttId),
        topic = Value(topic);
  static Insertable<MqttParameterTableData> custom({
    Expression<int>? parameterId,
    Expression<int>? deviceId,
    Expression<int>? mqttId,
    Expression<String>? topic,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (parameterId != null) 'parameter_id': parameterId,
      if (deviceId != null) 'device_id': deviceId,
      if (mqttId != null) 'mqtt_id': mqttId,
      if (topic != null) 'topic': topic,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MqttParameterTableCompanion copyWith(
      {Value<int>? parameterId,
      Value<int>? deviceId,
      Value<int>? mqttId,
      Value<String>? topic,
      Value<int>? rowid}) {
    return MqttParameterTableCompanion(
      parameterId: parameterId ?? this.parameterId,
      deviceId: deviceId ?? this.deviceId,
      mqttId: mqttId ?? this.mqttId,
      topic: topic ?? this.topic,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (parameterId.present) {
      map['parameter_id'] = Variable<int>(parameterId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<int>(deviceId.value);
    }
    if (mqttId.present) {
      map['mqtt_id'] = Variable<int>(mqttId.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MqttParameterTableCompanion(')
          ..write('parameterId: $parameterId, ')
          ..write('deviceId: $deviceId, ')
          ..write('mqttId: $mqttId, ')
          ..write('topic: $topic, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlarmsTableTable extends AlarmsTable
    with TableInfo<$AlarmsTableTable, AlarmsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlarmsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _activatedMeta =
      const VerificationMeta('activated');
  @override
  late final GeneratedColumn<bool> activated = GeneratedColumn<bool>(
      'activated', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activated" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [id, name, activated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alarms_table';
  @override
  VerificationContext validateIntegrity(Insertable<AlarmsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('activated')) {
      context.handle(_activatedMeta,
          activated.isAcceptableOrUnknown(data['activated']!, _activatedMeta));
    } else if (isInserting) {
      context.missing(_activatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlarmsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlarmsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      activated: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activated'])!,
    );
  }

  @override
  $AlarmsTableTable createAlias(String alias) {
    return $AlarmsTableTable(attachedDatabase, alias);
  }
}

class AlarmsTableData extends DataClass implements Insertable<AlarmsTableData> {
  final int id;
  final String name;
  final bool activated;
  const AlarmsTableData(
      {required this.id, required this.name, required this.activated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['activated'] = Variable<bool>(activated);
    return map;
  }

  AlarmsTableCompanion toCompanion(bool nullToAbsent) {
    return AlarmsTableCompanion(
      id: Value(id),
      name: Value(name),
      activated: Value(activated),
    );
  }

  factory AlarmsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlarmsTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      activated: serializer.fromJson<bool>(json['activated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'activated': serializer.toJson<bool>(activated),
    };
  }

  AlarmsTableData copyWith({int? id, String? name, bool? activated}) =>
      AlarmsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        activated: activated ?? this.activated,
      );
  @override
  String toString() {
    return (StringBuffer('AlarmsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('activated: $activated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, activated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlarmsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.activated == this.activated);
}

class AlarmsTableCompanion extends UpdateCompanion<AlarmsTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> activated;
  const AlarmsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.activated = const Value.absent(),
  });
  AlarmsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required bool activated,
  })  : name = Value(name),
        activated = Value(activated);
  static Insertable<AlarmsTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? activated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (activated != null) 'activated': activated,
    });
  }

  AlarmsTableCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<bool>? activated}) {
    return AlarmsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      activated: activated ?? this.activated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (activated.present) {
      map['activated'] = Variable<bool>(activated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlarmsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('activated: $activated')
          ..write(')'))
        .toString();
  }
}

class $DeviceAlarmsTableTable extends DeviceAlarmsTable
    with TableInfo<$DeviceAlarmsTableTable, DeviceAlarmsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceAlarmsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<int> deviceId = GeneratedColumn<int>(
      'device_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES devices_table (id)'));
  static const VerificationMeta _alarmIdMeta =
      const VerificationMeta('alarmId');
  @override
  late final GeneratedColumn<int> alarmId = GeneratedColumn<int>(
      'alarm_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES alarms_table (id)'));
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<int> slot = GeneratedColumn<int>(
      'slot', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [deviceId, alarmId, slot];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_alarms_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<DeviceAlarmsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('alarm_id')) {
      context.handle(_alarmIdMeta,
          alarmId.isAcceptableOrUnknown(data['alarm_id']!, _alarmIdMeta));
    } else if (isInserting) {
      context.missing(_alarmIdMeta);
    }
    if (data.containsKey('slot')) {
      context.handle(
          _slotMeta, slot.isAcceptableOrUnknown(data['slot']!, _slotMeta));
    } else if (isInserting) {
      context.missing(_slotMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId, alarmId, slot};
  @override
  DeviceAlarmsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceAlarmsTableData(
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}device_id'])!,
      alarmId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}alarm_id'])!,
      slot: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}slot'])!,
    );
  }

  @override
  $DeviceAlarmsTableTable createAlias(String alias) {
    return $DeviceAlarmsTableTable(attachedDatabase, alias);
  }
}

class DeviceAlarmsTableData extends DataClass
    implements Insertable<DeviceAlarmsTableData> {
  final int deviceId;
  final int alarmId;
  final int slot;
  const DeviceAlarmsTableData(
      {required this.deviceId, required this.alarmId, required this.slot});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<int>(deviceId);
    map['alarm_id'] = Variable<int>(alarmId);
    map['slot'] = Variable<int>(slot);
    return map;
  }

  DeviceAlarmsTableCompanion toCompanion(bool nullToAbsent) {
    return DeviceAlarmsTableCompanion(
      deviceId: Value(deviceId),
      alarmId: Value(alarmId),
      slot: Value(slot),
    );
  }

  factory DeviceAlarmsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceAlarmsTableData(
      deviceId: serializer.fromJson<int>(json['deviceId']),
      alarmId: serializer.fromJson<int>(json['alarmId']),
      slot: serializer.fromJson<int>(json['slot']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<int>(deviceId),
      'alarmId': serializer.toJson<int>(alarmId),
      'slot': serializer.toJson<int>(slot),
    };
  }

  DeviceAlarmsTableData copyWith({int? deviceId, int? alarmId, int? slot}) =>
      DeviceAlarmsTableData(
        deviceId: deviceId ?? this.deviceId,
        alarmId: alarmId ?? this.alarmId,
        slot: slot ?? this.slot,
      );
  @override
  String toString() {
    return (StringBuffer('DeviceAlarmsTableData(')
          ..write('deviceId: $deviceId, ')
          ..write('alarmId: $alarmId, ')
          ..write('slot: $slot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(deviceId, alarmId, slot);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceAlarmsTableData &&
          other.deviceId == this.deviceId &&
          other.alarmId == this.alarmId &&
          other.slot == this.slot);
}

class DeviceAlarmsTableCompanion
    extends UpdateCompanion<DeviceAlarmsTableData> {
  final Value<int> deviceId;
  final Value<int> alarmId;
  final Value<int> slot;
  final Value<int> rowid;
  const DeviceAlarmsTableCompanion({
    this.deviceId = const Value.absent(),
    this.alarmId = const Value.absent(),
    this.slot = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceAlarmsTableCompanion.insert({
    required int deviceId,
    required int alarmId,
    required int slot,
    this.rowid = const Value.absent(),
  })  : deviceId = Value(deviceId),
        alarmId = Value(alarmId),
        slot = Value(slot);
  static Insertable<DeviceAlarmsTableData> custom({
    Expression<int>? deviceId,
    Expression<int>? alarmId,
    Expression<int>? slot,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (alarmId != null) 'alarm_id': alarmId,
      if (slot != null) 'slot': slot,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceAlarmsTableCompanion copyWith(
      {Value<int>? deviceId,
      Value<int>? alarmId,
      Value<int>? slot,
      Value<int>? rowid}) {
    return DeviceAlarmsTableCompanion(
      deviceId: deviceId ?? this.deviceId,
      alarmId: alarmId ?? this.alarmId,
      slot: slot ?? this.slot,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<int>(deviceId.value);
    }
    if (alarmId.present) {
      map['alarm_id'] = Variable<int>(alarmId.value);
    }
    if (slot.present) {
      map['slot'] = Variable<int>(slot.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceAlarmsTableCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('alarmId: $alarmId, ')
          ..write('slot: $slot, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlarmsParameterTableTable extends AlarmsParameterTable
    with TableInfo<$AlarmsParameterTableTable, AlarmsParameterTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlarmsParameterTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _alarmIdMeta =
      const VerificationMeta('alarmId');
  @override
  late final GeneratedColumn<int> alarmId = GeneratedColumn<int>(
      'alarm_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES alarms_table (id)'));
  static const VerificationMeta _parameterIdMeta =
      const VerificationMeta('parameterId');
  @override
  late final GeneratedColumn<int> parameterId = GeneratedColumn<int>(
      'parameter_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES parameters_table ("index")'));
  static const VerificationMeta _lowerValueMeta =
      const VerificationMeta('lowerValue');
  @override
  late final GeneratedColumn<double> lowerValue = GeneratedColumn<double>(
      'lower_value', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _upperValueMeta =
      const VerificationMeta('upperValue');
  @override
  late final GeneratedColumn<double> upperValue = GeneratedColumn<double>(
      'upper_value', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _triggerTypeMeta =
      const VerificationMeta('triggerType');
  @override
  late final GeneratedColumnWithTypeConverter<TriggerType, int> triggerType =
      GeneratedColumn<int>('trigger_type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<TriggerType>(
              $AlarmsParameterTableTable.$convertertriggerType);
  @override
  List<GeneratedColumn> get $columns =>
      [id, alarmId, parameterId, lowerValue, upperValue, triggerType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alarms_parameter_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AlarmsParameterTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('alarm_id')) {
      context.handle(_alarmIdMeta,
          alarmId.isAcceptableOrUnknown(data['alarm_id']!, _alarmIdMeta));
    } else if (isInserting) {
      context.missing(_alarmIdMeta);
    }
    if (data.containsKey('parameter_id')) {
      context.handle(
          _parameterIdMeta,
          parameterId.isAcceptableOrUnknown(
              data['parameter_id']!, _parameterIdMeta));
    } else if (isInserting) {
      context.missing(_parameterIdMeta);
    }
    if (data.containsKey('lower_value')) {
      context.handle(
          _lowerValueMeta,
          lowerValue.isAcceptableOrUnknown(
              data['lower_value']!, _lowerValueMeta));
    }
    if (data.containsKey('upper_value')) {
      context.handle(
          _upperValueMeta,
          upperValue.isAcceptableOrUnknown(
              data['upper_value']!, _upperValueMeta));
    }
    context.handle(_triggerTypeMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlarmsParameterTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlarmsParameterTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      alarmId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}alarm_id'])!,
      parameterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parameter_id'])!,
      lowerValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lower_value']),
      upperValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}upper_value']),
      triggerType: $AlarmsParameterTableTable.$convertertriggerType.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}trigger_type'])!),
    );
  }

  @override
  $AlarmsParameterTableTable createAlias(String alias) {
    return $AlarmsParameterTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TriggerType, int, int> $convertertriggerType =
      const EnumIndexConverter<TriggerType>(TriggerType.values);
}

class AlarmsParameterTableData extends DataClass
    implements Insertable<AlarmsParameterTableData> {
  final int id;
  final int alarmId;
  final int parameterId;
  final double? lowerValue;
  final double? upperValue;
  final TriggerType triggerType;
  const AlarmsParameterTableData(
      {required this.id,
      required this.alarmId,
      required this.parameterId,
      this.lowerValue,
      this.upperValue,
      required this.triggerType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['alarm_id'] = Variable<int>(alarmId);
    map['parameter_id'] = Variable<int>(parameterId);
    if (!nullToAbsent || lowerValue != null) {
      map['lower_value'] = Variable<double>(lowerValue);
    }
    if (!nullToAbsent || upperValue != null) {
      map['upper_value'] = Variable<double>(upperValue);
    }
    {
      map['trigger_type'] = Variable<int>(
          $AlarmsParameterTableTable.$convertertriggerType.toSql(triggerType));
    }
    return map;
  }

  AlarmsParameterTableCompanion toCompanion(bool nullToAbsent) {
    return AlarmsParameterTableCompanion(
      id: Value(id),
      alarmId: Value(alarmId),
      parameterId: Value(parameterId),
      lowerValue: lowerValue == null && nullToAbsent
          ? const Value.absent()
          : Value(lowerValue),
      upperValue: upperValue == null && nullToAbsent
          ? const Value.absent()
          : Value(upperValue),
      triggerType: Value(triggerType),
    );
  }

  factory AlarmsParameterTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlarmsParameterTableData(
      id: serializer.fromJson<int>(json['id']),
      alarmId: serializer.fromJson<int>(json['alarmId']),
      parameterId: serializer.fromJson<int>(json['parameterId']),
      lowerValue: serializer.fromJson<double?>(json['lowerValue']),
      upperValue: serializer.fromJson<double?>(json['upperValue']),
      triggerType: $AlarmsParameterTableTable.$convertertriggerType
          .fromJson(serializer.fromJson<int>(json['triggerType'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'alarmId': serializer.toJson<int>(alarmId),
      'parameterId': serializer.toJson<int>(parameterId),
      'lowerValue': serializer.toJson<double?>(lowerValue),
      'upperValue': serializer.toJson<double?>(upperValue),
      'triggerType': serializer.toJson<int>(
          $AlarmsParameterTableTable.$convertertriggerType.toJson(triggerType)),
    };
  }

  AlarmsParameterTableData copyWith(
          {int? id,
          int? alarmId,
          int? parameterId,
          Value<double?> lowerValue = const Value.absent(),
          Value<double?> upperValue = const Value.absent(),
          TriggerType? triggerType}) =>
      AlarmsParameterTableData(
        id: id ?? this.id,
        alarmId: alarmId ?? this.alarmId,
        parameterId: parameterId ?? this.parameterId,
        lowerValue: lowerValue.present ? lowerValue.value : this.lowerValue,
        upperValue: upperValue.present ? upperValue.value : this.upperValue,
        triggerType: triggerType ?? this.triggerType,
      );
  @override
  String toString() {
    return (StringBuffer('AlarmsParameterTableData(')
          ..write('id: $id, ')
          ..write('alarmId: $alarmId, ')
          ..write('parameterId: $parameterId, ')
          ..write('lowerValue: $lowerValue, ')
          ..write('upperValue: $upperValue, ')
          ..write('triggerType: $triggerType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, alarmId, parameterId, lowerValue, upperValue, triggerType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlarmsParameterTableData &&
          other.id == this.id &&
          other.alarmId == this.alarmId &&
          other.parameterId == this.parameterId &&
          other.lowerValue == this.lowerValue &&
          other.upperValue == this.upperValue &&
          other.triggerType == this.triggerType);
}

class AlarmsParameterTableCompanion
    extends UpdateCompanion<AlarmsParameterTableData> {
  final Value<int> id;
  final Value<int> alarmId;
  final Value<int> parameterId;
  final Value<double?> lowerValue;
  final Value<double?> upperValue;
  final Value<TriggerType> triggerType;
  const AlarmsParameterTableCompanion({
    this.id = const Value.absent(),
    this.alarmId = const Value.absent(),
    this.parameterId = const Value.absent(),
    this.lowerValue = const Value.absent(),
    this.upperValue = const Value.absent(),
    this.triggerType = const Value.absent(),
  });
  AlarmsParameterTableCompanion.insert({
    this.id = const Value.absent(),
    required int alarmId,
    required int parameterId,
    this.lowerValue = const Value.absent(),
    this.upperValue = const Value.absent(),
    required TriggerType triggerType,
  })  : alarmId = Value(alarmId),
        parameterId = Value(parameterId),
        triggerType = Value(triggerType);
  static Insertable<AlarmsParameterTableData> custom({
    Expression<int>? id,
    Expression<int>? alarmId,
    Expression<int>? parameterId,
    Expression<double>? lowerValue,
    Expression<double>? upperValue,
    Expression<int>? triggerType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alarmId != null) 'alarm_id': alarmId,
      if (parameterId != null) 'parameter_id': parameterId,
      if (lowerValue != null) 'lower_value': lowerValue,
      if (upperValue != null) 'upper_value': upperValue,
      if (triggerType != null) 'trigger_type': triggerType,
    });
  }

  AlarmsParameterTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? alarmId,
      Value<int>? parameterId,
      Value<double?>? lowerValue,
      Value<double?>? upperValue,
      Value<TriggerType>? triggerType}) {
    return AlarmsParameterTableCompanion(
      id: id ?? this.id,
      alarmId: alarmId ?? this.alarmId,
      parameterId: parameterId ?? this.parameterId,
      lowerValue: lowerValue ?? this.lowerValue,
      upperValue: upperValue ?? this.upperValue,
      triggerType: triggerType ?? this.triggerType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (alarmId.present) {
      map['alarm_id'] = Variable<int>(alarmId.value);
    }
    if (parameterId.present) {
      map['parameter_id'] = Variable<int>(parameterId.value);
    }
    if (lowerValue.present) {
      map['lower_value'] = Variable<double>(lowerValue.value);
    }
    if (upperValue.present) {
      map['upper_value'] = Variable<double>(upperValue.value);
    }
    if (triggerType.present) {
      map['trigger_type'] = Variable<int>($AlarmsParameterTableTable
          .$convertertriggerType
          .toSql(triggerType.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlarmsParameterTableCompanion(')
          ..write('id: $id, ')
          ..write('alarmId: $alarmId, ')
          ..write('parameterId: $parameterId, ')
          ..write('lowerValue: $lowerValue, ')
          ..write('upperValue: $upperValue, ')
          ..write('triggerType: $triggerType')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  late final $DevicesTableTable devicesTable = $DevicesTableTable(this);
  late final $ParametersTableTable parametersTable =
      $ParametersTableTable(this);
  late final $ColectedDataTableTable colectedDataTable =
      $ColectedDataTableTable(this);
  late final $WifiTableTable wifiTable = $WifiTableTable(this);
  late final $DeviceWifiTableTable deviceWifiTable =
      $DeviceWifiTableTable(this);
  late final $MqttTableTable mqttTable = $MqttTableTable(this);
  late final $DeviceMqttTableTable deviceMqttTable =
      $DeviceMqttTableTable(this);
  late final $DeviceParameterTableTable deviceParameterTable =
      $DeviceParameterTableTable(this);
  late final $MqttParameterTableTable mqttParameterTable =
      $MqttParameterTableTable(this);
  late final $AlarmsTableTable alarmsTable = $AlarmsTableTable(this);
  late final $DeviceAlarmsTableTable deviceAlarmsTable =
      $DeviceAlarmsTableTable(this);
  late final $AlarmsParameterTableTable alarmsParameterTable =
      $AlarmsParameterTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        devicesTable,
        parametersTable,
        colectedDataTable,
        wifiTable,
        deviceWifiTable,
        mqttTable,
        deviceMqttTable,
        deviceParameterTable,
        mqttParameterTable,
        alarmsTable,
        deviceAlarmsTable,
        alarmsParameterTable
      ];
}
