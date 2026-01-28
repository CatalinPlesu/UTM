import 'package:flutter/material.dart';

class ToggleSetting extends StatefulWidget {
  final String label;
  final bool initialValue;
  final ValueChanged<bool>? updateValue;

  const ToggleSetting({
    required this.label,
    required this.initialValue,
    this.updateValue,
  });

  @override
  _ToggleSettingState createState() => _ToggleSettingState();
}

class _ToggleSettingState extends State<ToggleSetting> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.label),
          trailing: Switch(
            value: _value,
            onChanged: (newValue) {
              setState(() {
                _value = newValue;
                // updateValue(newValue);
                widget.updateValue?.call(newValue);
                // Handle toggle change here
              });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Divider(
            height: 0, // Adjust the height as needed
          ),
        ),
      ],
    );
  }
}
