import 'package:canti_hub/pages/main_page/pages/add_device_page/add_device_page.dart';
import 'package:flutter/material.dart';

class PlusIcon extends StatelessWidget {
  const PlusIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDevicePage()),
          );
        },
        child: Container(
          width: 76,
          child: Stack(
            children: [
              // Image Container (below)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 60,
                  height: 60,
                  child: Icon(
                    Icons.add_circle,
                    size: 36.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
