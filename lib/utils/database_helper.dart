import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:tie_your_shoes/simpleTools.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'dart:io';
import 'package:tie_your_shoes/models/locations.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String tableName = 'location_table';
  String colId = 'id';
  //String colPosition = 'position';
  String colDescription = 'description';
  String colGroup = 'colgroup';

  String collatitude = 'latitude';
  String collongitude = 'longitude';
  //String coltimeStamp = 'timestamp';
  String colaccuracy = 'accuracy';
  String colaltitude = 'altitude';
  String colheading = 'heading';
  String colspeed = 'speed';
  String colspeedAccuracy = 'speedAccuracy';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();

    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database == null)
    {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'locations.db');
    
    //Create the database
    var locationsDB = await openDatabase(path, version: 1, onCreate: _createDb);
    //await locationsDB.execute('DROP TABLE $tableName');
    //_createDb(locationsDB, 1);
    return locationsDB;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
      '$colDescription TEXT, $colGroup INT, $collatitude DOUBLE, $collongitude DOUBLE,'
      /*$coltimeStamp TEXT,*/ '$colaccuracy DOUBLE, $colaltitude DOUBLE,'
      '$colheading DOUBLE, $colspeed DOUBLE, $colspeedAccuracy DOUBLE)');
  }

  //fetch Objects
  Future<List<Map<String, dynamic>>> getLocationsMapList() async{
    Database db = await this.database;

    var result = await db.rawQuery('SELECT * FROM $tableName ORDER BY $colGroup DESC');
    return result;
  }

  //Insert objcts
  Future<int> insertLocation(Location pos) async{
    Database db = await this.database;
    var result = await db.insert(tableName, pos.toMap());
    return result;
  }

  void clearLocationsTable() async
  {
    Database db = await this.database;
    db.rawDelete('DELETE FROM $tableName');
    print("Table Cleared?");

  }

  void closeDatabase() async
  {
    Database db = await this.database;
    db.close();
  }
}