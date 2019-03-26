import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:tie_your_shoes/simpleTools.dart';
import 'package:tie_your_shoes/utils/database_helper.dart';
import 'package:tie_your_shoes/models/locations.dart';

class MapScreen extends StatefulWidget {
  MapScreen(Position position);

  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Position _position;
  LatLng _latLng;
  List<LatLng> points;
  List<Marker> markerList;
  MapController mapController = new MapController();
  FlutterMap _currentMap;
  DatabaseHelper databaseHelper;
  List<bool> popupsShown;
  bool popupShown = false;
  LatLng centerLatLng = new LatLng(0, 0);

  void initState() {
    database();
    super.initState();
  }

  void database() async {
    databaseHelper = DatabaseHelper();
    points = [];
    markerList = [];
    popupsShown = [];
    var temperature = await databaseHelper.getLocationsMapList();
    setState(() {
      points.addAll(mapToLatLng(temperature));
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Here's the popup
    Container popupContainer = new Container(
      child: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          popupShown = false;
          setState(() {});
        }, // remove the popup if we click on it
        child: new Card(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ListTile(
                title: Text('This is at:'),
                subtitle: Text(centerLatLng.toString()),
              ),
            ],
          ),
        ),
      ),
    );

    /// Add the Marker to our list if we previously clicked it and set popupshown=true
    if (popupShown == true) {
      markerList.add(new Marker(
        width: 150.0,
        height: 150.0,
        point:
            centerLatLng, // Probably want to add an offset so it appears above the point, rather than over it
        builder: (ctx) => popupContainer,
      ));
    }

    return new Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Flexible(
              child: _currentMap = mapBuilder(),
            )
          ],
        ),
      ),
    );
  }

  //Lets  build out map
  FlutterMap mapBuilder() {
    FlutterMap p = new FlutterMap(
      mapController: mapController,
      options: new MapOptions(
        center: new LatLng(0, 0),
        interactive: false,
        zoom: 13.0,
      ),
      layers: [
        new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        new PolylineLayerOptions(
          polylines: [
            new Polyline(
              points: points,
              strokeWidth: 4.0,
              color: Colors.amber,
            ),
          ],
        ),
        new MarkerLayerOptions(markers: markerList)
      ],
    );
    mapUpdate();
    return p;
  }

  Container testMarkerContainerBuild() {
    return new Container(
        child: new GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: new Icon(Icons.location_on, size: 20.0, color: Colors.orange),
      onTap: () {
        /// So we want to display the marker if tapped
        popupShown = true;
        setState(() {});
      },
    ));
  }

  void mapUpdate() {
    var bounds = new LatLngBounds();
    if (points.length > 0) {
      for (LatLng l in points) {
        bounds.extend(l);

        /// Add it to our MarkerList
        markerList.add(
          new Marker(
            width: 80.0,
            height: 80.0,
            point: l, // a latlng of where you want it
            builder: (ctx) => testMarkerContainerBuild(),
          ),
        );
      }
      mapController.move(
          //new LatLng(_position.latitude, _position.longitude), 13.0);
          points.elementAt(0),
          13.0);
      mapController.fitBounds(
        bounds,
        options: new FitBoundsOptions(
          padding: new Point<double>(15.0, 15.0),
        ),
      );
    }
  }
}
