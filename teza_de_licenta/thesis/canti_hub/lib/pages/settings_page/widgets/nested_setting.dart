import 'package:flutter/material.dart';

class NestedSetting extends StatelessWidget {
  final String label;
  final Widget page;

  const NestedSetting({required this.label, required this.page});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(label),
          onTap: () {
            // Navigate to a new page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          trailing: Icon(Icons.navigate_next),
        ),
        Divider(height: 0)
      ],
    );
  }
}
