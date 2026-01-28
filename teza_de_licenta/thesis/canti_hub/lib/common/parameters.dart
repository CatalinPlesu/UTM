class Parameter {
  final String name;
  final int index;
  final int recurrence;
  final double normal;
  final double max;
  final double min;
  final String units;

  Parameter({
    required this.name,
    required this.index,
    required this.recurrence,
    required this.normal,
    required this.max,
    required this.min,
    required this.units,
  });

  factory Parameter.fromJson(Map<String, dynamic> json) {
    return Parameter(
      name: json['name'],
      index: json['index'],
      recurrence: json['recurrence'],
      normal: json['normal'],
      max: json['max'],
      min: json['min'],
      units: json['units'],
    );
  }
}
