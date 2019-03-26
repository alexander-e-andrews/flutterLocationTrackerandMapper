import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:tie_your_shoes/activeScreen.dart';
import 'package:tie_your_shoes/appBar.dart';

void main() {
  runApp(new TieYourShoesApp());
}

class TieYourShoesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Flow",
      home: new MyHome(),
    );
  }
}

