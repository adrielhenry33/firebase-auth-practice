import 'package:firebase_backend/firebase_options.dart';
import 'package:firebase_backend/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart' as fb_core;
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await fb_core.Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: LoginPage(),
    );
  }
}
