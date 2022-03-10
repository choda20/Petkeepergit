import 'package:flutter/material.dart';

class LocationInput extends StatefulWidget {
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageurl;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          child: _previewImageurl == null
              ? const Text(
                  'No location chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageurl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(children: [
          OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.location_on),
              label: const Text('Current location')),
          OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text('Select on map'))
        ])
      ],
    );
  }
}
