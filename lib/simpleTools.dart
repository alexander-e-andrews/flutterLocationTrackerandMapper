import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

//A set of simple tools that may be need throught
//this program, we will see how useful it is

List<LatLng> posListToLatLng(List<Position> posList){
  List<LatLng> latLngList = [];
  for(Position p in posList)
  {
    latLngList.add(new LatLng(p.latitude, p.longitude));
  }
  return latLngList;
}