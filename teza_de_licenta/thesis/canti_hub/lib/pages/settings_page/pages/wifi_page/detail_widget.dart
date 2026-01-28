import 'package:flutter/material.dart';

class DetailWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onEditPressed;
  final VoidCallback? onRemovePressed;

  const DetailWidget({
    required this.title,
    this.onEditPressed,
    this.onRemovePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit), // Edit icon
            onPressed: onEditPressed, // Edit function
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onRemovePressed,
          ),
        ],
      ),
    );
  }
}
