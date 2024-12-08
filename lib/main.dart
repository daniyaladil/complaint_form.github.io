import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'complaints.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: "AIzaSyBhX6HXDDY_yVNdGMCuZbiGvXq2eQbaSDA",
      authDomain: "complaints-d725d.firebaseapp.com",
      projectId: "complaints-d725d",
      storageBucket: "complaints-d725d.appspot.com",
      messagingSenderId: "208554970280",
      appId: "1:208554970280:web:cab7fae21ce82b6255069d",
      measurementId: "G-B77L4BKR6L",
      databaseURL: "https://complaints-d725d-default-rtdb.firebaseio.com/",
    ));
  }
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ComplaintForm(),
    );
  }
}




