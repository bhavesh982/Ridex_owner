
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ridex_owner/authentication/email_verification.dart';
import 'package:ridex_owner/splashScreen/splashScreen.dart';
import 'firebase_options.dart';

Future<void> initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Initialized default app $app');
}
Future<void> main() async{
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DEFAULT',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const SplashScreen(),
    );
  }
}
