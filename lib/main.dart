import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ridex_owner/authentication/login_screen.dart';
import 'package:ridex_owner/pages/dashboard.dart';

import 'package:ridex_owner/pages/addSpaceship.dart';
import 'firebase_options.dart';
import 'global/global_var.dart';

Future<void> main() async{

 WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;
    DatabaseReference databaseReference=FirebaseDatabase.instance.ref().child("owners").child(user!.uid);
    databaseReference.once().then((snap){
      setState(() {
        uid=user.uid;
        spaceShipCompanyName=(snap.snapshot.value as Map)["company"];
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ridex',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const LoginScreen(),
    );
  }
}
