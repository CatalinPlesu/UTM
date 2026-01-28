import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DropdownSetting extends StatefulWidget {
  final String label;
  final List<String> items;
  final Function(String) onChanged;
  final String value;

  const DropdownSetting({
    required this.label,
    required this.items,
    required this.onChanged,
    required this.value,
  });

  @override
  _DropdownSettingState createState() => _DropdownSettingState();
}

class _DropdownSettingState extends State<DropdownSetting> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.label),
          onTap: () {
            _showDropdown(context);
          },
          trailing: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text(
              selectedValue,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
        Divider(height: 0),
      ],
    );
  }

  Future<void> _showDropdown(BuildContext context) async {
    var localisation = AppLocalizations.of(context);
    String? newValue = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.label),
          content: DropdownButtonFormField<String>(
            value: selectedValue,
            items: widget.items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedValue = value ?? selectedValue;
              });
            },
            decoration: InputDecoration(
              hintText: 'Select an item',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedValue);
              },
              child: Text(localisation!.ok),
            ),
          ],
        );
      },
    );

    if (newValue != null) {
      widget.onChanged(newValue);
    }
  }
}
