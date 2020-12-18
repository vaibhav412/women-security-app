import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_women/screen/home_screen.dart';
import 'package:safe_women/screen/intro_screen.dart';
import 'package:safe_women/services/location_service.dart';

import 'contacts/database_helper.dart';
import 'screen/numbers/numbers.dart';

var query;

Future<List> getData() async {
  List<Map<String, dynamic>> queryRows =
      await DatabaseHelper.instance.queryAll();
  return queryRows;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  query = await getData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<LocationService>(
      create: (context) => LocationService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/numberScreen': (BuildContext context) => new NumbersPage()
        },
        home: query.length == 0 ? Intro() : HomeScreen(),
      ),
    );
  }
}
