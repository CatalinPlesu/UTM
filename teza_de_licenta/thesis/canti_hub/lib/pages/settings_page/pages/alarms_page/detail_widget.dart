import 'package:flutter/material.dart';

class DetailWidget extends StatefulWidget {
  final String title;
  final VoidCallback? onEditPressed;
  final ValueChanged<bool>? onToggle; // Callback for toggle action
  final bool initialValue; // Initial toggle value

  const DetailWidget({
    required this.title,
    this.onEditPressed,
    this.onToggle,
    required this.initialValue,
  });

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  late bool _toggleValue;

  @override
  void initState() {
    super.initState();
    _toggleValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit), // Edit icon
            onPressed: widget.onEditPressed, // Edit function
          ),
          Switch(
            value: _toggleValue,
            onChanged: (newValue) {
              setState(() {
                _toggleValue = newValue;
                widget.onToggle?.call(newValue);
                // Handle toggle change here
              });
            },
          ),
        ],
      ),
    );
  }
}
