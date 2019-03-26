import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:tie_your_shoes/simpleTools.dart';
import 'package:tie_your_shoes/utils/database_helper.dart';

class OptionsMenu extends StatefulWidget{
  @override
  OptionsMenuWidget createState() => OptionsMenuWidget();

}

class OptionsMenuWidget extends State<OptionsMenu> {
  DatabaseHelper databaseHelper;

  void initState() {
    database();
    super.initState();
  }

  @override
  void dispose()
  {
    //databaseHelper.closeDatabase();
    super.dispose();
  }

  void database() async {
    databaseHelper = DatabaseHelper();
  }

  void loadData() async{
    var temperature = await databaseHelper.getLocationsMapList();
    print(temperature);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          //Delete database tile
          return ListTile(
            title: Text("Clear Database"),
            onTap: () {
              databaseHelper.clearLocationsTable();
            },
          );
        },
      ),
    );
  }
}
