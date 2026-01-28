import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebLinkSetting extends StatelessWidget {
  final String label;
  final String url;
  final IconData icon;

  const WebLinkSetting({required this.label, required this.url, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(label),
          onTap: _launchUrl,
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

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(this.url))) {
      throw Exception('Could not launch $url');
    }
  }
}