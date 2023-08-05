import 'package:firebase_database/firebase_database.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rider_app/AllScreens/registerationScreen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Brand Bold",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: MainScreen.idScreen,
      routes: {
        RegisterationScreen.idScreen: (context) => RegisterationScreen(),
        LoginScreen.idScreen: (context) => LoginScreen(),
        MainScreen.idScreen: (context) => const MainScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
