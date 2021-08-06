import 'package:esportshub/pages2/homepage/homepage2.dart';
import 'package:esportshub/pages2/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black87,
    statusBarColor: Colors.black54,
  ));

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // themeMode: ThemeMode.dark,
    theme: ThemeData.dark(),
    home: FirebaseAuth.instance.currentUser == null ? LoginPg() : Homepage1(index: 0,),
  ));
}
