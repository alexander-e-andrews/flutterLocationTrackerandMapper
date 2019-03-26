import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:tie_your_shoes/simpleTools.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:tie_your_shoes/utils/database_helper.dart';
import 'package:tie_your_shoes/models/locations.dart';


/*
User starts tracking, and important information will be shown
Maybe show the map as well, but I dont want to do that right now for the sake of testing
And for my battery life,
Maps also require internet to downaload the map tiles so it will be better if instead the user can switch this on and off
*/
class ActiveScreen extends StatefulWidget {
  Position _position;
  ActiveScreen(Position position){
    this._position = position;
  }

  ActiveScreenState createState() => ActiveScreenState(_position);
}

class ActiveScreenState extends State<ActiveScreen> {
  
  //Position _position;
  List<Position> spots = [];
  int count = 0;
  Position _position;
  Timer _timer;
  DatabaseHelper databaseHelper = DatabaseHelper();

  ActiveScreenState(position){
    this._position = position;
  }

  @override
  void initState()
  {
    //_timer = new Timer.periodic(new Duration(seconds:30), (Timer timer) => getPosition());
    super.initState();
  }

  @override
  void dispose()
  {
    for(Position p in spots)
    {
      databaseHelper.insertLocation(new Location(p, 0));
    }
    tramples();
    //_timer.cancel();
    //databaseHelper.closeDatabase();
    super.dispose();
  }
  
  void tramples() async{
    var test = await databaseHelper.getLocationsMapList();
    for(var p in test)
    {
      print(p);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(spots == null)
    {
      spots = List<Position>();
      print("Spots was null");
    }
    return new Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    //Creates the three sub images
                    buildChildren(),
              ),
            ),
            FloatingActionButton(
              onPressed: () => getPosition(),
              tooltip: 'Get Location',
              child: Icon(Icons.gps_fixed),
            ),
            FloatingActionButton(
              onPressed: () => clearLocationsTable(),
              tooltip: 'Clear Database',
              child: Icon(Icons.cancel),
            ),
          ],
        ),
      ),
    );
  }

  //Returns a list of infomrations
  //The _ifposition starts all values at 0
  //This ensures that we dont crash on null pointers
  List<Widget> buildChildren() {
    var builder;
    if (_position == null)
      builder = [
        information(0.0, 'LONG'),
        information(0.0, 'LAT'),
        information(0.0, 'SPEED'),
      ];
    else {
      builder = [
        information(_position.longitude, 'LONG'),
        information(_position.latitude, 'LAT'),
        information(_position.speed, 'SPEED(KNOT)'),
      ];
    }
    return builder;
  }

  //Get your position from geolocator
  void getPosition() async {
    print("Getting position");
    //var pointList =
    _position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    spots.add(_position);
    setState(() {
      _position = _position;
    });
  }

  void clearLocationsTable() async{
    databaseHelper.clearLocationsTable();
  }

  //Builds an item that contains two text fields
  //These are columned together
  Column information(double info, String label) {
    //print('Inside INfomration, probably info crashing');
    Color color = Theme.of(context).primaryColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            '$info',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
