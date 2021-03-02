import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wifi_app/Screens/Dashboard.dart';

void main() async {
  //this line is required after the firebase 0.7.0 release becuase it has to get initialize before running the application
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //this is the main home page of your app meanig the app will always start from this screen
      home: DashBoard(),
    );
  }
}
