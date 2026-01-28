import 'package:flutter/material.dart';
import 'package:canti_hub/providers/device_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MqttParameterWidget extends StatefulWidget {
  final MqttParameter parameter;
  final Function(bool) onCheckboxChanged;
  final Function(String) onTopicChanged;

  MqttParameterWidget({
    required this.parameter,
    required this.onCheckboxChanged,
    required this.onTopicChanged,
  });

  @override
  _MqttParameterWidgetState createState() => _MqttParameterWidgetState();
}

class _MqttParameterWidgetState extends State<MqttParameterWidget> {
  TextEditingController _topicController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _topicController.text = widget.parameter.topic;
  }

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0), // Add padding to the bottom
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  8.0, 0.0, 8.0, 0.0), // Adjust top and bottom padding for name
              child: Row(
                children: [
                  Text(
                    widget.parameter.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0), // Adjust font size for name
                  ),
                  SizedBox(
                      width: 8.0), // Add space between the text and checkbox
                  Checkbox(
                    value: widget.parameter.checkbox,
                    onChanged: (value) {
                      setState(() {
                        widget.parameter.checkbox = value!;
                        widget.onCheckboxChanged(value);
                      });
                    },
                  ),
                ],
              ),
            ),
            if (widget.parameter.checkbox)
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                child: TextFormField(
                  controller: _topicController,
                  onChanged: (value) {
                    widget.parameter.topic = value;
                    widget.onTopicChanged(value);
                  },
                  style:
                      TextStyle(fontSize: 16.0), // Adjust font size for topic
                  decoration: InputDecoration(
                    labelText: localisation!.mqtt_topic,
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }
}
