import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hafilaty_driver/firebase_options.dart';
// This should work if the file exists at lib/firebase_options.dart


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Firebase App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Firebase Initialized Successfully'),
        ),
      ),
    );
  }
}
