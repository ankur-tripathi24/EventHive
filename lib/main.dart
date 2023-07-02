import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:eventhive/screens/login.dart';
import 'package:eventhive/screens/register.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyRegister());

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyRegister(),
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
    },
  ));
}
