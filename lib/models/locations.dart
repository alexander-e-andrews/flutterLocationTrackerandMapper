import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:tie_your_shoes/activeScreen.dart';
import 'package:tie_your_shoes/mapWidget.dart';
import 'package:sqflite/sqflite.dart';

class Location {
  int _id;
  Position _p;
  int _group;
  String _description;

  Location.withId(this._id, this._p, this._group, [this._description]);
  Location(this._p, this._group, [this._description]);

  int get id => _id;
  Position get position => _p;
  int get group => _group;
  String get description => _description;

  set position(Position newPos) {
    this._p = newPos;
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set group(int newGroup) {
    this._group = newGroup;
  }

  //COnvert our pbject into a map object like a boss
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    // map['position'] = _p;
    map['colgroup'] = _group;

    map['description'] = _description;
    map['longitude'] = _p.longitude;
    map['latitude'] = _p.latitude;
    //map['timestamp'] = _p.timestamp;
    map['accuracy'] = _p.accuracy;
    map['altitude'] = _p.altitude;
    map['heading'] = _p.heading;
    map['speed'] = _p.speed;
    map['speedAccuracy'] = _p.speedAccuracy;
    return map;
  }

  //COnvert mpa object to string
  Location.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._p = new Position(
        longitude: map['longitude'],
        latitude: map['latitude'],
        /*timestamp: map['timestamp'],*/
        accuracy: map['accuracy'],
        altitude: map['altitude'],
        heading: map['heading'],
        speed: map['speed'],
        speedAccuracy: map['speedAccuracy']);
    this._group = map['colgroup'];
    this._description = map['description'];
  }
}

List<LatLng> mapToLatLng(List<Map> mapList) {
  List<LatLng> _latlnglist = [];
  for (Map m in mapList) {
    Location t = Location.fromMapObject(m);
    _latlnglist.add(new LatLng(t._p.latitude, t._p.longitude));
  }
  return _latlnglist;
}
